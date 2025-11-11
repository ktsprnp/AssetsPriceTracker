//
//  AssetsListView.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import SwiftUI

struct AssetsListView: View {
    @State private var viewModel: AssetsListViewModelInterface
    
    init(viewModel: AssetsListViewModelInterface) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(viewModel.assetsPrice) { assetPrice in
            AssetListItemView(assetPrice: assetPrice)
        }
        .onAppear {
            viewModel.resume()
        }
    }
}

// TODO: Uncomment #preview
//#Preview {
//    AssetsListView()
//}
