//
//  AssetsListView.swift
//  AssetsPriceTracker
//
//  Created by Kittisak Phetrungnapha on 11/11/2568 BE.
//

import SwiftUI

struct AssetsListView: View {
    @State private var viewModel: AssetsListViewModelInterface
    @State private var flashColor = Color.clear
    @State private var isFlashing = false
    
    init(viewModel: AssetsListViewModelInterface) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            List($viewModel.assetsPrice) { assetPrice in
                NavigationLink {
                    AssetDetailView(assetPrice: assetPrice)
                } label: {
                    ZStack {
//                        flashColor
//                            .animation(.easeInOut(duration: 0.5), value: flashColor)
//                            .onAppear {
//                                let color: Color = switch assetPrice.wrappedValue.priceDirection {
//                                case .up: .green
//                                case .down: .red
//                                case .unchanged: .clear
//                                }
//                                flashBackground(color: color)
//                            }
                        
                        AssetListItemView(assetPrice: assetPrice)
                    }
                }
            }
            .navigationTitle("Assets Price")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(viewModel.isStarted ? "🟢" : "🔴")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if viewModel.isStarted {
                            viewModel.stop()
                        } else {
                            viewModel.start()
                        }
                    } label: {
                        Text(viewModel.isStarted ? "Stop" : "Start")
                    }
                }
            }
            .onAppear {
                viewModel.start()
            }
        }
    }
    
    private func flashBackground(color: Color) {
        guard !isFlashing, color != .clear else { return }
        isFlashing = true

        flashColor = color

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            flashColor = .clear
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isFlashing = false
        }
    }
}

#if DEBUG

private final class MockAssetListViewModel: AssetsListViewModelInterface {
    var assetsPrice: [AssetPrice] = []
    var isStarted: Bool = false
    
    func start() {
        isStarted = true
    }
    
    func stop() {
        isStarted = false
    }
}

#Preview {
    AssetsListView(viewModel: MockAssetListViewModel())
}

#endif
