//
//  AssetListItemView.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import SwiftUI

struct AssetListItemView: View {
    
    @Binding var assetPrice: AssetPrice
    
    private var formattedPrice: String {
        numberFormatter.string(from: NSNumber(floatLiteral: assetPrice.price)) ?? "N/A"
    }
    
    private var priceDirectionColor: Color {
        switch assetPrice.priceDirection {
        case .up: .green
        case .down: .red
        case .unchanged: .gray
        }
    }
    
    var body: some View {
        HStack {
            Text(assetPrice.priceDirection.text)
                .foregroundStyle(priceDirectionColor)
            
            Text(assetPrice.id.rawValue)
            Spacer()
            Text(formattedPrice)
        }
    }
}

#Preview {
    AssetListItemView(assetPrice: .constant(AssetPrice(id: .bitcoin, price: 100_000.00, priceDirection: .unchanged)))
}
