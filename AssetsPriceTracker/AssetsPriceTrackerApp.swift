//
//  AssetsPriceTrackerApp.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import SwiftUI

@main
struct AssetsPriceTrackerApp: App {
    
    private let webSocketClient = WebSocketClient.shared
    
    var body: some Scene {
        WindowGroup {
            AssetsListView(viewModel: AssetsListViewModel(webSocketClient: webSocketClient))
        }
    }
}
