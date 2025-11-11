//
//  AssetsListViewModel.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import Foundation
import Combine

protocol AssetsListViewModelInterface: AnyObject {
    func stop()
    func start()
    
    var assetsPrice: [AssetPrice] { get set }
    var isStarted: Bool { get }
}

@Observable
final class AssetsListViewModel: AssetsListViewModelInterface {
    
    private let webSocketClient: WebSocketClientInterface
    
    private var cancellables: Set<AnyCancellable> = []
    private var sendMessagesTimer: AnyCancellable?
    
    // TODO: Handle force unwrapped optional
    private let webSocketUrl = URL(string: "wss://ws.postman-echo.com/raw")!
    
    var assetsPrice: [AssetPrice] = []
    private(set) var isStarted = false
    private var previousPrices: [Asset: Double] = [:]
    
    init(webSocketClient: WebSocketClientInterface) {
        self.webSocketClient = webSocketClient
        
        webSocketClient.isConnected
            .removeDuplicates()
            .sink { [weak self] isConnected in
                if isConnected {
                    self?.subscribeToAssets()
                    self?.isStarted = true
                } else {
                    self?.isStarted = false
                }
            }
            .store(in: &cancellables)
        
        webSocketClient.messageString
            .map { [weak self] messageText in
                return self?.processMessageText(messageText)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] assetsPrice in
                if let assetsPrice, !assetsPrice.isEmpty {
                    self?.assetsPrice = assetsPrice
                }
            }
            .store(in: &cancellables)
    }
    
    private func processMessageText(_ messageText: String) -> [AssetPrice]? {
        let data = Data(messageText.utf8)
        var assetsPrice = try? JSONDecoder().decode([AssetPrice].self, from: data)
        assetsPrice?.sort { item1, item2 in
            item1.price > item2.price
        }
        
        for (index, asset) in (assetsPrice ?? []).enumerated() {
            let assetId = asset.id
            let currentPrice = asset.price
            
            if let previousPrice = previousPrices[assetId] {
                if currentPrice > previousPrice {
                    assetsPrice?[index].priceDirection = .up
                } else if currentPrice < previousPrice {
                    assetsPrice?[index].priceDirection = .down
                }
            }
            
            previousPrices[assetId] = currentPrice
        }
        
        return assetsPrice
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
                        {
                        "id": "\(id)",
                        "price": \(price)
                        }
                        """
                    queries.append(query)
                }
                
                let queryString = "[\(queries.joined(separator: ", "))]"
                self?.webSocketClient.send(message: queryString)
            }
    }
    
    func stop() {
        webSocketClient.disconnect()
    }
    
    func start() {
        webSocketClient.connect(url: webSocketUrl)
    }
}
