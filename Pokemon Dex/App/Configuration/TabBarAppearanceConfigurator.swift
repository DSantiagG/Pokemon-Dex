//
//  TabBar+Appearance.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/01/26.
//

import UIKit

// MARK: - Tab Bar Appearance

/// Utilities to configure the global `UITabBar` appearance used across the app.
extension UITabBar {
    /// Configure the shared `UITabBarAppearance` used by the app's tab bars.
    ///
    /// - Parameter selectedColor: The tint color applied to the selected tab icon and title. Defaults to `.systemRed`.
    static func configureAppearance(selectedColor: UIColor = .systemRed) {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
