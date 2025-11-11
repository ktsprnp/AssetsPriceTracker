//
//  WebSocketClient.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import Foundation
import Combine

protocol WebSocketClientInterface: AnyObject {
    func connect(url: URL)
    func disconnect()
    func send(message: String)
    
    var messagesString: [String] { get }
    var messagesData: [Data] { get }
    var isConnected: Bool { get }
}

final class WebSocketClient: NSObject, WebSocketClientInterface {
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    private var pingTimer: AnyCancellable?
    
    static let shared = WebSocketClient()
    
    @Published private(set) var messagesString: [String] = []
    @Published private(set) var messagesData: [Data] = []
    @Published private(set) var isConnected = false
    
    deinit {
        invalidatePingTimer()
    }

    func connect(url: URL) {
        guard webSocketTask == nil else { return }
        
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = urlSession?.webSocketTask(with: url)
        webSocketTask?.resume()
    }

    func disconnect() {
        guard webSocketTask != nil else { return }
        
        invalidatePingTimer()
        
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        urlSession = nil
        isConnected = false
    }

    func send(message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        
        webSocketTask?.send(message) { error in
            if let error {
                // TODO: Handle websocket send message error
            }
        }
    }
    
    private func invalidatePingTimer() {
        pingTimer?.cancel()
        pingTimer = nil
    }

    private func receive() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                // TODO: Handle websocket received error
                break
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.messagesString.append(text)
                case .data(let data):
                    self?.messagesData.append(data)
                @unknown default:
                    break
                }
            }
            
            self?.receive()
        }
    }
    
    private func ping() {
        let pingIntervalInSeconds: TimeInterval = 10
        
        pingTimer = Timer.publish(every: pingIntervalInSeconds, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.webSocketTask?.sendPing { error in
                    if let error {
                        // TODO: Handle ping error
                    }
                }
            }
    }
}

// MARK: - URLSessionWebSocketDelegate

extension WebSocketClient: URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        isConnected = true
        ping()
        receive()
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        isConnected = false
    }
}
