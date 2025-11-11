//
//  AssetsListViewModel.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import Foundation
import Combine

protocol AssetsListViewModelInterface: AnyObject {
    func pause()
    func resume()
}

@Observable final class AssetsListViewModel: AssetsListViewModelInterface {
    
    private let webSocketClient: WebSocketClient
    
    private var cancellables: Set<AnyCancellable> = []
    private var sendMessagesTimer: AnyCancellable?
    
    // TODO: Handle force unwrapped optional
    private let webSocketUrl = URL(string: "wss://ws.postman-echo.com/raw")!
    
    init(webSocketClient: WebSocketClient) {
        self.webSocketClient = webSocketClient
        
        webSocketClient.$isConnected
            .removeDuplicates()
            .sink { [weak self] isConnected in
                if isConnected {
                    self?.subscribeToAssets()
                } else {
                    // TODO: Handle connect to websocket error
                }
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
        sendMessagesTimer?.cancel()
        sendMessagesTimer = nil
    }
    
    private func subscribeToAssets() {
        let sendMessagesIntervalInSeconds: TimeInterval = 2
        
        sendMessagesTimer = Timer.publish(every: sendMessagesIntervalInSeconds, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                var queries: [String] = []
                
                for asset in Asset.allCases {
                    let id = asset.rawValue
                    let price = Double.random(in: 10.0...10_000)
                    let query = """
                        "\(id)": \(price)
                        """
                    queries.append(query)
                }
                
                let queryString = "{\(queries.joined(separator: ", "))}"
                self?.webSocketClient.send(message: queryString)
            }
    }
    
    func pause() {
        webSocketClient.disconnect()
    }
    
    func resume() {
        webSocketClient.connect(url: webSocketUrl)
    }
}
