//
//  StoreReviewContentView.swift
//  Instafilter
//
//  Created by Eliezer Rodrigo Beltramin de Sant Ana on 05/08/24.
//

import StoreKit
import SwiftUI

struct StoreReviewContentView: View {
    
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        Button("Leave a review") {
            requestReview()
        }
    }
}

#Preview {
    StoreReviewContentView()
}
