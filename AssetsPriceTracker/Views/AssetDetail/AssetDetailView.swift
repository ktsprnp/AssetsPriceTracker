//
//  AssetDetailView.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import SwiftUI

struct AssetDetailView: View {
    @State var viewModel: AssetDetailViewModelInterface
    
    private var priceDirectionColor: Color {
        switch viewModel.priceDirection {
        case .up: .green
        case .down: .red
        case .unchanged: .gray
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.formattedPrice)
                    .font(.largeTitle)
                Spacer()
                Text(viewModel.directionText)
                    .font(.largeTitle)
                    .foregroundStyle(priceDirectionColor)
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle(viewModel.title)
    }
}

// TODO: Uncomment #preview
//#Preview {
//    AssetDetailView()
//}
