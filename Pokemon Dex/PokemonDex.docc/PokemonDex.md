# ``Pokemon_Dex``

EjemploA modular SwiftUI application that consumes the PokéAPI using its official Swift wrapper library.


## Overview

`Pokemon_Dex` is a feature-modular iOS application built with **SwiftUI** and modern Swift concurrency.

The project emphasizes:

* Clean architecture
* Feature-based modularization
* Decoupled navigation
* Reusable generic components
* Scalable state management

The application allows users to explore:

* Pokémon
* Items
* Abilities

Each domain is implemented as an isolated feature module containing its own models, services, view models, and views.

---

## Architecture

The app follows a strict feature-based modular structure:

* **App** — Entry point and global configuration
* **Core** — Shared abstractions, routing, providers, base models
* **Features** — Independent domains (Pokemon, Item, Ability)
* **Shared** — Reusable UI components and generic ViewModels

### Design Principles

* MVVM with centralized `ViewState`
* Decoupled navigation via `AppRouter` and `NavigationRouter`
* Protocol-oriented services
* Generic paginated and searchable ViewModels
* Thread-safe persistence using `actor`

---

## Navigation Flow

Navigation logic is fully abstracted from Views.

1. `MainTabView` controls active tab selection.
2. Each feature maintains an independent navigation stack.
3. `AppRouter` coordinates cross-feature navigation.
4. `NavigationRouter` manages per-feature stack state.
5. `NavigationContext` resolves the active router.

This prevents navigation conflicts and ensures stable feature isolation.

---

## Concurrency Model

The application uses modern Swift concurrency:

* `async/await` for networking
* `actor` for favorites persistence
* Structured task handling within ViewModels

---

## Data Source

Data is fetched from the official **PokéAPI** using its Swift wrapper library.

API Reference
[PokéAPI](https://pokeapi.co)

Source Repository
[GitHub Repository](https://github.com/DSantiagG/Pokemon-Dex/)

---

## Feature Modules

### Pokemon

* Grid and List browsing
* Type filtering
* Search
* Favorites persistence
* Modular detail sections (characteristics, stats, abilities, capture info, breeding info, held items, evolution, forms)

@Row {
    @Column {
        @Image(source: "pokemon-home.png", alt: "Pokemon Home")
    }
    @Column {
        @Image(source: "pokemon-detail.png", alt: "Pokemon Detail")
    }
    @Column {
        @Image(source: "pokemon-search.png", alt: "Pokemon Search")
    }
}

@Row {
    @Column {
        @Image(source: "pokemon-filter.png", alt: "Pokemon Filter")
    }
    @Column {
        @Image(source: "pokemon-favorites.png", alt: "Pokemon Favorites")
    }
}

---

### Item

* Grid and List browsing
* Search
* Modular detail sections (attributes, effects, related Pokémon)

@Row {
    @Column {
        @Image(source: "items-home.png", alt: "Items Home")
    }
    @Column {
        @Image(source: "items-detail.png", alt: "Item Detail")
    }
}

---

### Ability

* Grid and List browsing
* Search
* Modular detail sections (Effect desciptions, Related Pokémon)

@Row {
    @Column {
        @Image(source: "abilities-home.png", alt: "Abilities Home")
    }
    @Column {
        @Image(source: "ability-detail.png", alt: "Ability Detail")
    }
}

---

## Purpose

This project serves as an architectural reference implementation for scalable SwiftUI applications that consume external APIs using modern concurrency and modular design.


## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
