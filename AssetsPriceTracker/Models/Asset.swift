//
//  Asset.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import Foundation

enum Asset: String, Codable, CaseIterable {
    case apple = "AAPL"
    case google = "GOOG"
    case tesla = "TSLA"
    case amazon = "AMZN"
    case microsoft = "MSFT"
    case nvidia = "NVDA"
    case bitcoin = "BTC"
    case ethereum = "ETH"
    case binanceCoin = "BNB"
    case solana = "SOL"
    case ripple = "XRP"
    case cardano = "ADA"
    case tron = "TRX"
    case doge = "DOGE"
    case hyperliquid = "HYPE"
    case chainlink = "LINK"
    case bitcoinCash = "BCH"
    case stellar = "XLM"
    case litecoin = "LTC"
    case sui = "SUI"
    case monero = "XMR"
    case shiba = "SHIB"
    case uniswap = "UNI"
    case ton = "TON"
    case aave = "AAVE"
}
