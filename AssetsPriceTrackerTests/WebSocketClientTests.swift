//
// WebSocketClientTests.swift
// AssetsPriceTrackerTests
//
// Created on 2025-11-12.
//

import XCTest
import Combine
@testable import AssetsPriceTracker

final class WebSocketClientTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }

    func testDidOpenSendsIsConnectedTrue() {
        let client = WebSocketClient()
        let expect = expectation(description: "isConnected true")

        client.isConnected
            .sink { isConnected in
                XCTAssertTrue(isConnected)
                expect.fulfill()
            }
            .store(in: &cancellables)

        let session = URLSession(configuration: .default)
        let task = session.webSocketTask(with: URL(string: "wss://example.com")!)

        client.urlSession(session, webSocketTask: task, didOpenWithProtocol: nil)

        waitForExpectations(timeout: 1.0)
    }

    func testDidCloseSendsIsConnectedFalse() {
        let client = WebSocketClient()
        let expect = expectation(description: "isConnected false")
        client.isConnected.send(true)

        client.isConnected
            .sink { isConnected in
                XCTAssertFalse(isConnected)
                expect.fulfill()
            }
            .store(in: &cancellables)

        let session = URLSession(configuration: .default)
        let task = session.webSocketTask(with: URL(string: "wss://example.com")!)

        client.urlSession(session, webSocketTask: task, didCloseWith: .goingAway, reason: nil)

        waitForExpectations(timeout: 1.0)
    }

    func testMessageSubjectsDeliver() {
        let client = WebSocketClient()
        let expectString = expectation(description: "messageString received")
        let expectData = expectation(description: "messageData received")

        client.messageString
            .sink { text in
                XCTAssertEqual(text, "hello")
                expectString.fulfill()
            }
            .store(in: &cancellables)

        client.messageData
            .sink { data in
                if let string = String(data: data, encoding: .utf8) {
                    XCTAssertEqual(string, "payload")
                    expectData.fulfill()
                }
            }
            .store(in: &cancellables)

        client.messageString.send("hello")
        client.messageData.send(Data("payload".utf8))

        waitForExpectations(timeout: 1.0)
    }
}
