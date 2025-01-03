//
//  CustomSlider.swift
//  Dimple
//
//  Created by Adrian Topka on 06/11/2024.
//

import SwiftUI

struct CarouselModel: Identifiable {
    var id: UUID = .init()
    var value: String
}

struct CustomCarousel<Content: View, Data: RandomAccessCollection>: View where Data.Element: Identifiable {
    
    @Binding var selection: Data.Element.ID?
    var data: Data
    @ViewBuilder var content: (Data.Element) -> Content
    
    let cellWidth = UIScreen.main.bounds.width - 42
    
    var body: some View {
        GeometryReader { _ in
            
            ScrollView(.horizontal) {
                HStack(spacing: 48) {
                    ForEach(data) { item in
                        ItemView(item)
                    }
                }
                .scrollTargetLayout()
            }
            .safeAreaPadding(.horizontal, max((UIScreen.main.bounds.width) / 2.45, 0))
            .scrollPosition(id: $selection)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .scrollIndicators(.hidden)
        }
    }
    
    /// Item View
    @ViewBuilder
    func ItemView(_ item: Data.Element) -> some View {
        GeometryReader { proxy in
            
            let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
            let progress = minX / (cellWidth + 10)
            
            let opacityValue = 0.9 * abs(progress)
            
            content(item)
                .frame(width: cellWidth)
                .opacity(1 - opacityValue)

        }
        .frame(width: cellWidth / 3.3)
    }
}
#Preview {
    OnboardingHeightView(viewModel: .init())
}


