//
//  PriceDirection.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import Foundation

enum PriceDirection: Codable {
    case up
    case down
    case unchanged
    
    var text: String {
        switch self {
        case .up:
            "↑"
        case .down:
            "↓"
        case .unchanged:
            "-"
        }
    }
}
