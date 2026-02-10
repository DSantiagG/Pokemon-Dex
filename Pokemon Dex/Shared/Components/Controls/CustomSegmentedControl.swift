//
//  CustomSegmentedControl.swift
//  Pokemon Dex
//
//  Created by David Giron on 24/11/25.
//

import SwiftUI

/// A lightweight, customizable segmented control that supports any `Hashable` selection type.
///
/// Use `CustomSegmentedControl` when you need a pill-style segment control with a colored
/// selection indicator. The control accepts an array of `Item` values and binds to a
/// `Selection` value that updates when the user taps a segment.
///
/// - Parameters:
///   - selection: Binding to the currently selected tag.
///   - color: Accent color used for the selection indicator.
///   - items: Array of `Item` values describing each segment.
///
/// Example:
/// ```swift
/// @State private var selection: Fruit = .banana
/// CustomSegmentedControl(selection: $selection, color: .red, items: Fruit.allCases.map {
///     .init($0.rawValue.capitalized, tag: $0)
/// })
/// ```
public struct CustomSegmentedControl<Selection: Hashable>: View {
    
    // MARK: - Item
    
    /// Minimal model representing a single segment.
    ///
    /// - `id`: The selection tag used to match the bound `selection` value.
    /// - `title`: The text shown inside the segment.
    public struct Item: Identifiable {
        public let id: Selection
        public let title: String
        public init(_ title: String, tag: Selection) {
            self.title = title
            self.id = tag
        }
    }
    
    // MARK: - Properties
    @Binding private var selection: Selection
    private let color: Color
    private let items: [Item]
    
    // MARK: - Init
    /// Create a segmented control bound to `selection`.
    public init(selection: Binding<Selection>, color: Color, items: [Item]) {
        self._selection = selection
        self.items = items
        self.color = color
    }
    
    // MARK: - View
    
    /// The segmented control view.
    ///
    /// The control renders a capsule background with an animated colored capsule
    /// representing the selected segment. Tapping a segment animates selection
    /// to the corresponding item.
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
    
    // MARK: - Helpers
    
    /// Calculate the horizontal offset for the colored selection indicator.
    ///
    /// - Parameter width: Width of a single segment; computed in the `GeometryReader`.
    /// - Returns: X offset to position the colored capsule over the selected segment.
    private func offsetX(width: CGFloat) -> CGFloat {
        guard let idx = items.firstIndex(where: { $0.id == selection }) else { return 0 }
        return CGFloat(idx) * width
    }
}


private struct SegmentedPickerPreviews: View {
    
    enum Fruit: String, CaseIterable, Hashable { case apple, banana, cherry}
    
    @State var enumSelection: Fruit = .banana
    
    var body: some View {
        CustomSegmentedControl(selection: $enumSelection, color: .red, items:
                                Fruit.allCases.map { fruit in
                .init(fruit.rawValue.capitalized, tag: fruit)
        })
        .padding()
    }
}

#Preview{
    SegmentedPickerPreviews()
}
