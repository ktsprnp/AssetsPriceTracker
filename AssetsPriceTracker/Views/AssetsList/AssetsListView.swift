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
        NavigationStack {
            List(viewModel.assetsPrice) { assetPrice in
                NavigationLink {
                    AssetDetailView()
                } label: {
                    AssetListItemView(assetPrice: assetPrice)
                }
            }
            .navigationTitle("Assets Price")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(viewModel.isStarted ? "🟢" : "🔴")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if viewModel.isStarted {
                            viewModel.stop()
                        } else {
                            viewModel.start()
                        }
                    } label: {
                        Text(viewModel.isStarted ? "Stop" : "Start")
                    }
                }
            }
            .onAppear {
                viewModel.start()
            }
        }
    }
}

// TODO: Uncomment #preview
//#Preview {
//    AssetsListView()
//}
