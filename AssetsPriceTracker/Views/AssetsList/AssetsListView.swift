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
        NavigationView {
            List(viewModel.assetsPrice) { assetPrice in
                NavigationLink {
                    AssetDetailView()
                } label: {
                    AssetListItemView(assetPrice: assetPrice)
                }
            }
            .navigationTitle("Assets Price")
            .onAppear {
                viewModel.resume()
            }
        }
    }
}

// TODO: Uncomment #preview
//#Preview {
//    AssetsListView()
//}
