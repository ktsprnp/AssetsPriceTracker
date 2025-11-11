//
//  AssetDetailViewModel.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import Foundation

protocol AssetDetailViewModelInterface: AnyObject {
    var title: String { get }
}

@Observable
final class AssetDetailViewModel: AssetDetailViewModelInterface {
    
    private let assetPrice: AssetPrice
    
    var title: String {
        assetPrice.id
    }
    
    init(assetPrice: AssetPrice) {
        self.assetPrice = assetPrice
    }
}
