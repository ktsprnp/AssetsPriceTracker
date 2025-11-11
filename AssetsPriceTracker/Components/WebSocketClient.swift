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
    
    var messageString: PassthroughSubject<String, Never> { get }
    var messageData: PassthroughSubject<Data, Never> { get }
    var isConnected: PassthroughSubject<Bool, Never> { get }
}

final class WebSocketClient: NSObject, WebSocketClientInterface {
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    private var pingTimer: AnyCancellable?
    
    static let shared = WebSocketClient()
    
    let messageData = PassthroughSubject<Data, Never>()
    let messageString = PassthroughSubject<String, Never>()
    let isConnected = PassthroughSubject<Bool, Never>()
    
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
        isConnected.send(false)
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
                    self?.messageString.send(text)
                case .data(let data):
                    self?.messageData.send(data)
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
        isConnected.send(true)
        ping()
        receive()
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        isConnected.send(false)
    }
}
