//
//  ShareLinkContentView.swift
//  Instafilter
//
//  Created by Eliezer Rodrigo Beltramin de Sant Ana on 05/08/24.
//

import SwiftUI

struct ShareLinkContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            ShareLink(item: URL(string: "https://www.hackingwithswift.com")!)
            ShareLink(item: URL(string: "https://www.hackingwithswift.com")!, subject: Text("Learn Swift here"), message: Text("Check out the 100 Days of SwiftUI!"))
            ShareLink(item: URL(string: "https://www.hackingwithswift.com")!) {
                Label("Spread the word about Swift", systemImage: "swift")
            }
            
            let example = Image(.example)
            
            ShareLink(item: example, preview: SharePreview("Singapore Airport", image: example)) {
                Label("Click to share", systemImage: "airplane")
            }
        }
    }
}

#Preview {
    ShareLinkContentView()
}
