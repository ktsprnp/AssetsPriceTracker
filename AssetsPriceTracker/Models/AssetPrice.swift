//
//  AssetPrice.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import Foundation

enum PriceDirection: Codable {
    case up
    case down
    case unknown
    
    var text: String {
        switch self {
        case .up:
            "↑"
        case .down:
            "↓"
        case .unknown:
            "-"
        }
    }
}

struct AssetPrice: Codable, Identifiable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case price
    }
    
    let id: String
    let price: Double
    
    var priceDirection: PriceDirection = .unknown
}
