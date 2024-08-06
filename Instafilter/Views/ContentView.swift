//
//  ContentView.swift
//  Instafilter
//
//  Created by Eliezer Rodrigo Beltramin de Sant Ana on 05/08/24.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import SwiftUI

struct ContentView: View {
    
    // Filters
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    @State private var showingFilters = false
    
    // Picker
    @State private var selectedItem: PhotosPickerItem?
    
    // Review
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                //                .buttonStyle(.plain) // if we want to disable the default blue color
                .onChange(of: selectedItem, loadImage)
                
                Spacer()
                
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity, applyProcessing)
                        .disabled(selectedItem == nil)
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter", action: changeFilter)
                        .disabled(selectedItem == nil)
                    
                    Spacer()
                    
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
                    }
                }
                
                
                
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Cancel", role: .cancel) { }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
        }
    }
    
    func changeFilter() {
        showingFilters = true
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self),
                  let inputImage = UIImage(data: imageData) else { return }
            
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)}
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey)}
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey)}
        
        guard let outputImage = currentFilter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    @MainActor func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        
        filterCount += 1
        
        if filterCount >= 20 {
            requestReview()
        }
    }
}

#Preview {
    ContentView()
}
