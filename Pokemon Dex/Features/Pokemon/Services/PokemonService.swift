//
//  PokemonService.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/11/25.
//
import PokemonAPI

actor PokemonService {
    private let api = PokemonAPI()
    private var pagedObject: PKMPagedObject<PKMPokemon>?
    private var cache = [String: PKMPokemon]()

    func fetchInitialPage() async throws -> [PKMPokemon] {
        let result = try await api.pokemonService.fetchPokemonList(paginationState: .initial(pageLimit: 20))
        pagedObject = result
        return try await fetchPokemons(from: result.results ?? [])
    }

    func fetchNextPage() async throws -> [PKMPokemon]? {
        
        guard let paged = pagedObject,
              paged.hasNext else { return nil }

        let next = try await api.pokemonService.fetchPokemonList(paginationState: .continuing(paged, .next))
        pagedObject = next
        return try await fetchPokemons(from: next.results ?? [])
    }

    func fetchPokemon(name: String) async throws -> PKMPokemon {
        //TODO: Ver si esto si esta haciendo algo
        if let cached = cache[name] {
            print("Entre a la cache")
            return cached }
        let pokemon = try await api.pokemonService.fetchPokemon(name)
        cache[name] = pokemon
        return pokemon
    }

    private func fetchPokemons(from results: [PKMAPIResource<PKMPokemon>]) async throws -> [PKMPokemon] {
        try await withThrowingTaskGroup(of: (Int, PKMPokemon).self) { group in
            for (index, result) in results.enumerated() {
                group.addTask {
                    let pokemon = try await self.api.resourceService.fetch(result)
                    return (index, pokemon)
                }
            }
            var pairs: [(Int, PKMPokemon)] = []
            for try await pair in group {
                pairs.append(pair)
            }
            return pairs.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
    }
}
