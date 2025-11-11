//
//  AssetsListViewModel.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import Foundation

protocol AssetsListViewModelInterface: AnyObject {
    func subscribeToAssets()
    func pause()
    func resume()
}

@Observable final class AssetsListViewModel: AssetsListViewModelInterface {
    
    private let webSocketClient: WebSocketClientInterface
    
    // TODO: Handle force unwrapped optional
    private let webSocketUrl = URL(string: "wss://ws.postman-echo.com/raw")!
    
    init(webSocketClient: WebSocketClientInterface) {
        self.webSocketClient = webSocketClient
    }
    
    func subscribeToAssets() {
        
    }
    
    func pause() {
        webSocketClient.disconnect()
    }
    
    func resume() {
        webSocketClient.connect(url: webSocketUrl)
    }
}
