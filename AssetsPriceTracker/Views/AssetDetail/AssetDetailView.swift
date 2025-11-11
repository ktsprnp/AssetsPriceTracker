//
//  AssetDetailView.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import SwiftUI

struct AssetDetailView: View {
    @State var viewModel: AssetDetailViewModelInterface
    
    var body: some View {
        Text("Hello, World!")
            .navigationTitle(viewModel.title)
    }
}

// TODO: Uncomment #preview
//#Preview {
//    AssetDetailView()
//}
