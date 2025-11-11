//
//  AssetPrice.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import Foundation

struct AssetPrice: Codable, Identifiable {
    let id: String
    let price: Double
}
