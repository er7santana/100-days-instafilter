//
//  OnChangeContentView.swift
//  Instafilter
//
//  Created by Eliezer Rodrigo Beltramin de Sant Ana on 03/08/24.
//

import SwiftUI

struct OnChangeContentView: View {
    
    @State private var blurAmount = 0.0
    
    var body: some View {
        VStack {
            Text("Hello, World")
                .font(.system(size: 40))
                .blur(radius: blurAmount)
            
            Slider(value: $blurAmount, in: 0...20)
                .onChange(of: blurAmount) { oldValue, newValue in
                    print("New value: \(newValue)")
                }
            
            Button("Random Blur") {
                blurAmount = Double.random(in: 0...20)
            }
        }
        .padding()
    }
}

#Preview {
    OnChangeContentView()
}
