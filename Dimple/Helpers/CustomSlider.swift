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

let ageValues: [CarouselModel] = (20...99).compactMap({ CarouselModel(value: "\($0)") })
let heightValues: [CarouselModel] = [.init(value: "4'0"), .init(value: "4'1"), .init(value: "4'2"), .init(value: "4'3"), .init(value: "4'4"), .init(value: "4'5"), .init(value: "4'6"), .init(value: "4'7"), .init(value: "4'8"), .init(value: "4'9")]


struct CustomCarousel<Content: View, Data: RandomAccessCollection>: View where Data.Element: Identifiable {
    
    @Binding var selection: Data.Element.ID?
    var data: Data
    @ViewBuilder var content: (Data.Element) -> Content
    
    let cellWidth = UIScreen.main.bounds.width - 64
    
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
            .safeAreaPadding(.horizontal, max((UIScreen.main.bounds.width) / 2.4, 0))
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
//#Preview {
//    CustomCarousel(selection: .constant(UUID), data: ageValues) { ageModel in
//        <#code#>
//    }
//}


