//
//  AssetPrice.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import Foundation

struct AssetPrice: Codable, Identifiable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case price
    }
    
    let id: String
    let price: Double
    
    var priceDirection: PriceDirection = .unchanged
}
