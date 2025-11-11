//
//  AssetListItemView.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import SwiftUI

struct AssetListItemView: View {
    
    let assetPrice: AssetPrice
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    private var formattedPrice: String {
        numberFormatter.string(from: NSNumber(floatLiteral: assetPrice.price)) ?? "N/A"
    }
    
    private var priceDirectionColor: Color {
        switch assetPrice.priceDirection {
        case .up:
            Color.green
        case .down:
            Color.red
        case .unchanged:
            Color.gray
        }
    }
    
    var body: some View {
        HStack {
            Text(assetPrice.priceDirection.text)
                .foregroundStyle(priceDirectionColor)
            
            Text(assetPrice.id)
            Spacer()
            Text(formattedPrice)
        }
    }
}

#Preview {
    AssetListItemView(assetPrice: AssetPrice(id: "BTC", price: 100_000.00))
}
