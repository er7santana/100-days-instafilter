//
//  PthotoLibraryMultipleContentView.swift
//  Instafilter
//
//  Created by Eliezer Rodrigo Beltramin de Sant Ana on 05/08/24.
//

import PhotosUI
import SwiftUI

struct PthotoLibraryMultipleContentView: View {
    
    @State private var pickerItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    
    var body: some View {
        VStack {
            
            ScrollView {
                ForEach(0..<selectedImages.count, id: \.self) { index in
                    selectedImages[index]
                        .resizable()
                        .scaledToFit()
                }
            }
            
            PhotosPicker(selection: $pickerItems,
                         maxSelectionCount: 2,
                         matching: .images
            ) {
                Label("Select pictures", systemImage: "photo")
            }
            .onChange(of: pickerItems) {
                Task {
                    selectedImages.removeAll()
                    
                    for item in pickerItems {
                        if let loadedImage = try await item.loadTransferable(type: Image.self) {
                            selectedImages.append(loadedImage)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PthotoLibraryMultipleContentView()
}
