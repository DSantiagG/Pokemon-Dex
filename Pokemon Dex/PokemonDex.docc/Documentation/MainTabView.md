# MainTabView
Root tab container that presents the application's primary feature tabs and search.

A root tab container responsible for presenting the application's primary feature tabs (for example: Pokémon, Items, Abilities) and the global Search tab. This article documents the intent, main responsibilities, and the public-facing surface of `MainTabView` so it can be viewed in Xcode's Documentation viewer (DocC).

- Author: David Giron
- Since: 1.0

## Key responsibilities

- Configure the global `UITabBar` appearance so the selected icon and label reflect the app styling.
- Provide a `TabView` that exposes primary feature tabs + a Search tab.
- Keep track of the last non-search selection so that a search action can target the previously active feature.
- Provide the `AppRouter` instance (via `@StateObject`) which exposes per-feature routers for navigation.

## Properties

The following properties are the primary state holders used by `MainTabView`:

- `appRouter: AppRouter` — A `@StateObject` that owns per-feature routers and coordinates navigation between features.
- `selection: AppTab` — The currently selected tab in the `TabView`.
- `lastPrimarySelection: AppTab` — The last primary (non-search) selected tab. Used to restore search context.
- `searchTarget: AppTab` — The tab which will receive search results when the Search tab is active.

## Initializer

`init()`

Perform a minimal UI appearance configuration for the `UITabBar`. This method intentionally only touches global appearance and contains no business logic.

## Example

```swift
// Place this as the root view in your scene or App struct
struct MyAppScene: Scene {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
```

## Notes & Guidance

- `MainTabView` expects `AppTab` to provide per-tab metadata and a way to create the corresponding view. The concrete tab views and routing are provided by `AppRouter`.
- The Search tab leverages `searchTarget` to forward search invocations to the appropriate feature router. This preserves the user's previous context when switching to Search and back.

## See also

- `AppRouter` — coordinates navigation between feature routers.
- `AppTab` — enum that represents primary tabs and their metadata.

---

*This article is part of the project's DocC documentation bundle and can be viewed in Xcode's Documentation viewer.*
