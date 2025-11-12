//
//  AssetsPriceTrackerApp.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import SwiftUI

@main
struct AssetsPriceTrackerApp: App {
    
    @State private var assetsListViewModel: AssetsListViewModelInterface = AssetsListViewModel(webSocketClient: WebSocketClient.shared)
    
    var body: some Scene {
        WindowGroup {
            AssetsListView(viewModel: $assetsListViewModel)
                .onAppear {
                    assetsListViewModel.start()
                }
        }
    }
}
