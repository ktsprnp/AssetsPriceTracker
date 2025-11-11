//
//  AssetDetailViewModel.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import Foundation

protocol AssetDetailViewModelInterface: AnyObject {
    var title: String { get }
    var formattedPrice: String { get }
    var directionText: String { get }
    var priceDirection: PriceDirection { get }
}

@Observable
final class AssetDetailViewModel: AssetDetailViewModelInterface {
    
    private let assetPrice: AssetPrice
    
    var title: String {
        assetPrice.id
    }
    
    var formattedPrice: String {
        numberFormatter.string(from: NSNumber(floatLiteral: assetPrice.price)) ?? "N/A"
    }
    
    var directionText: String {
        assetPrice.priceDirection.text
    }
    
    var priceDirection: PriceDirection {
        assetPrice.priceDirection
    }
    
    init(assetPrice: AssetPrice) {
        self.assetPrice = assetPrice
    }
}
