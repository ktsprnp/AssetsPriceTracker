//
//  AssetDetailView.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import SwiftUI

struct AssetDetailView: View {
    @Binding var assetPrice: AssetPrice
    
    private var priceDirectionColor: Color {
        switch assetPrice.priceDirection {
        case .up: .green
        case .down: .red
        case .unchanged: .gray
        }
    }
    
    private var formattedPrice: String {
        numberFormatter.string(from: NSNumber(floatLiteral: assetPrice.price)) ?? "N/A"
    }
    
    private var priceDirectionText: String {
        assetPrice.priceDirection.text
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(formattedPrice)
                    .font(.largeTitle)
                Text(priceDirectionText)
                    .font(.largeTitle)
                    .foregroundStyle(priceDirectionColor)
                Spacer()
            }
            .padding(.bottom, 16)
            
            Text(assetPrice.id.detail)
            
            Spacer()
        }
        .padding()
        .navigationTitle(assetPrice.id.rawValue)
    }
}

// TODO: Uncomment #preview
//#Preview {
//    AssetDetailView()
//}
