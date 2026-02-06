//
//  MainTabView.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/11/25.
//

import SwiftUI

/// The root tab view for the application.
///
/// `MainTabView` is responsible for presenting the app's primary feature tabs
/// (Pokémon, Items, Abilities) plus the Search tab. It holds a shared
/// ``AppRouter`` instance and manages the currently selected tab and the last
/// non-search selection so the search target can default to the previously
/// active primary tab.
struct MainTabView: View {
    // MARK: - Properties

    /// Shared application router that provides per-feature routers
    /// and coordinates navigation between feature modules.
    @StateObject var appRouter = AppRouter()

    /// The currently selected tab in the `TabView`.
    @State private var selection: AppTab = .pokemon

    /// The last selected primary tab (used to restore the search target).
    @State private var lastPrimarySelection: AppTab = .pokemon

    /// The tab that should receive search actions when the Search tab is used.
    @State private var searchTarget: AppTab = .pokemon

    // MARK: - Init TabBar appearance

    /// Configure the global `UITabBar` appearance used by this view.
    init() {
        UITabBar.configureAppearance()
    }

    // MARK: - Body

    /// The content of this view: a `TabView` that iterates over the primary
    /// tabs and also provides a Search tab. The Search tab delegates search
    /// routing back to the appropriate per-feature router using `searchTarget`.
    var body: some View {
        TabView (selection: $selection){
            ForEach(AppTab.primaryTabs, id: \.self) { tab in
                Tab(tab.title, systemImage: tab.systemImageName, value: tab) {
                    tab.view(appRouter: appRouter)
                }
            }

            Tab(value: AppTab.search, role: .search) {
                SearchView(searchTarget: searchTarget) {
                    selection = searchTarget
                }
                .environmentObject(searchTarget.searchRouter(appRouter: appRouter))
            }
        }
        .onChange(of: selection) { _ , newValue in
            newValue == .search ? (searchTarget = lastPrimarySelection) : (lastPrimarySelection = newValue)
        }
    }
}

#Preview{
    MainTabView()
}
