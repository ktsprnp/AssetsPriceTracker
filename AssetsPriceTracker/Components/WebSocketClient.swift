//
//  WebSocketClient.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import Foundation
import Combine

protocol WebSocketClientInterface: AnyObject {
    func connect()
    func disconnect()
    func send(message: String)
}

final class WebSocketClient: NSObject, WebSocketClientInterface {
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    private var pingTimer: Timer?
    
    static let shared = WebSocketClient()
    
    // TODO: Handle force unwrapped optional
    private let webSocketUrl = URL(string: "wss://ws.postman-echo.com/raw")!

    func connect() {
        guard webSocketTask == nil else { return }
        
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = urlSession?.webSocketTask(with: webSocketUrl)
        webSocketTask?.resume()
    }

    func disconnect() {
        guard webSocketTask != nil else { return }
        
        pingTimer?.invalidate()
        pingTimer = nil
        
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        urlSession = nil
    }

    func send(message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        
        webSocketTask?.send(message) { error in
            if let error {
                // TODO: Handle websocket send message error
            }
        }
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
                    // TODO: Handle received success text message
                    break
                case .data(let data):
                    // TODO: Handle received success data message
                    break
                @unknown default:
                    break
                }
            }
            
            self?.receive()
        }
    }
    
    private func ping() {
        let pingIntervalInSeconds: TimeInterval = 10
        
        pingTimer = Timer.scheduledTimer(withTimeInterval: pingIntervalInSeconds, repeats: true) { [weak self] _ in
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
        ping()
        receive()
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        // TODO: Handle web socket connection closed
    }
}
