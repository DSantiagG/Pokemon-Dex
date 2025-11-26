//
//  CustomSegmentedControl.swift
//  Pokemon Dex
//
//  Created by David Giron on 24/11/25.
//

import SwiftUI

public struct CustomSegmentedControl<Selection: Hashable>: View {
    
    public struct Item: Identifiable {
        public let id: Selection
        public let title: String
        public init(_ title: String, tag: Selection) {
            self.title = title
            self.id = tag
        }
    }
    @Binding private var selection: Selection
    
    private let title: String
    private let items: [Item]
    private let color: Color
    
    public init(_ title: String = "", selection: Binding<Selection>, color: Color, items: [Item]) {
        self.title = title
        self._selection = selection
        self.items = items
        self.color = color
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !title.isEmpty {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            ZStack(alignment: .leading) {
                Color.gray.opacity(0.12)
                    .frame(height: 30)
                    .clipShape(Capsule())
                    .overlay(
                        GeometryReader { geo in
                            let count = max(items.count, 1)
                            let segmentWidth = geo.size.width / CGFloat(count)
                            Capsule()
                                .fill(color)
                                .frame(width: segmentWidth, height: 30)
                                .offset(x: offsetX(width: segmentWidth))
                        }
                    )
                
                HStack(spacing: 0) {
                    ForEach(items) { item in
                        Text(item.title)
                            .fontWeight(.bold)
                            .foregroundStyle(selection == item.id ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    selection = item.id
                                }
                            }
                    }
                }
            }
        }
    }
    
    private func offsetX(width: CGFloat) -> CGFloat {
        guard let idx = items.firstIndex(where: { $0.id == selection }) else { return 0 }
        return CGFloat(idx) * width
    }
}


private struct SegmentedPickerPreviews: View {
    
    enum Fruit: String, CaseIterable, Hashable { case apple, banana, cherry}
    
    @State var enumSelection: Fruit = .banana
    
    var body: some View {
        CustomSegmentedControl("", selection: $enumSelection, color: .red, items:
                                Fruit.allCases.map { fruit in
                .init(fruit.rawValue.capitalized, tag: fruit)
        })
        .padding()
    }
}

#Preview{
    SegmentedPickerPreviews()
}
