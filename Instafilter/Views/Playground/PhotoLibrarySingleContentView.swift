//
//  PhotoLibrarySingleContentView.swift
//  Instafilter
//
//  Created by Eliezer Rodrigo Beltramin de Sant Ana on 05/08/24.
//

import PhotosUI
import SwiftUI

struct PhotoLibrarySingleContentView: View {
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    var body: some View {
        VStack {
            
            selectedImage?
                .resizable()
                .scaledToFit()
            
            PhotosPicker("Select a picture",
                         selection: $pickerItem,
                         matching: .images
            )
        }
        .onChange(of: pickerItem) {
            Task {
                selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
            }
        }
    }
}

#Preview {
    PhotoLibrarySingleContentView()
}
