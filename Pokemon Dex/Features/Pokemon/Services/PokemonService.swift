//
//  PokemonService.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/11/25.
//
import PokemonAPI
import Foundation

actor PokemonService {
    private let api = PokemonAPI()
    private var pagedObject: PKMPagedObject<PKMPokemon>?
    
    private var pokemonResourcesCache: [PKMAPIResource<PKMPokemon>]?
    
    private var pokemonCache = [String: PKMPokemon]()
    private var typeCache = [String: PKMType]()
    private var speciesCache = [String: PKMPokemonSpecies]()
    private var chainCache = [Int: [EvolutionStage]]()
    
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
        let pokemons = try await fetchPokemons(from: next.results ?? [])
        return pokemons
    }
    
    func fetchAllPokemonResources() async throws -> [PKMAPIResource<PKMPokemon>] {
        if let cached = pokemonResourcesCache { return cached }
        let result = try await api.pokemonService.fetchPokemonList(paginationState: .initial(pageLimit: 2000))
        let pokemonResources = result.results ?? []
        pokemonResourcesCache = pokemonResources
        return pokemonResources
    }
    
    func fetchPokemon(name: String) async throws -> PKMPokemon {
        try await fetchPokemon(usingKey: name) {
            try await self.api.pokemonService.fetchPokemon(name)
        }
    }
    
    func fetchPokemon(resource: PKMAPIResource<PKMPokemon>) async throws -> PKMPokemon {
        let key = resource.name ?? resource.url ?? "unknown"
        return try await fetchPokemon(usingKey: key) {
            if let success = try? await self.api.resourceService.fetch(resource) {
                return success
            }
            return try await self.api.pokemonService.fetchPokemon(resource.name ?? "")
        }
    }
    
    private func fetchPokemon(usingKey key: String, fetcher: () async throws -> PKMPokemon) async throws -> PKMPokemon {
        if let cached = pokemonCache[key] {
            return cached
        }
        let pokemon = try await fetcher()
        pokemonCache[key] = pokemon
        return pokemon
    }
    
    func fetchType(resource: PKMAPIResource<PKMType>) async throws -> PKMType {
        let key = resource.name ?? resource.url ?? "unknown"
        if let cached = typeCache[key] {
            print("Retornando de cache de type: \(key)")
            return cached
        }
        let type = try await api.resourceService.fetch(resource)
        typeCache[key] = type
        return type
    }
    
    func fetchSpecies(resource: PKMAPIResource<PKMPokemonSpecies>) async throws -> PKMPokemonSpecies {
        let key = resource.name ?? resource.url ?? "unknown"
        if let cached = speciesCache[key] {
            print("Retornando de cache de species: \(key)")
            return cached
        }
        let species = try await api.resourceService.fetch(resource)
        speciesCache[key] = species
        return species
    }
    
    func fetchEvolutionChain(resource: PKMAPIResource<PKMEvolutionChain>) async throws -> [EvolutionStage]? {
        
        guard let url = resource.url else { return nil }
        
        if let id = Int(url.split(separator: "/").last ?? ""), let cached = chainCache[id] {
            print("Retornando de cache de evolution: \(id)")
            return cached
        }
        
        let chain = try await api.resourceService.fetch(resource)
        guard let root = chain.chain else { return nil }
        
        var pokemonResources: [PKMAPIResource<PKMPokemon>] = []
        await extractNames(from: root, into: &pokemonResources)
        
        var stages: [EvolutionStage] = []
        for resource in pokemonResources {
            let poke = try await fetchPokemon(resource: resource)
            let sprite = poke.sprites?.other?.officialArtwork?.frontDefault
            stages.append(EvolutionStage(name: poke.name, sprite: sprite))
        }
        
        if let id = chain.id {
            chainCache[id] = stages
        }
        
        return stages
    }
    
    func fetchPokemons(from results: [PKMAPIResource<PKMPokemon>]) async throws -> [PKMPokemon] {
        try await withThrowingTaskGroup(of: (Int, PKMPokemon).self) { group in
            for (index, result) in results.enumerated() {
                group.addTask {
                    let pokemon = try await self.fetchPokemon(resource: result)
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
    
    private func extractNames(from node: PKMChainLink, into array: inout [PKMAPIResource<PKMPokemon>]) async {
        
        guard let specieResource = node.species else { return }
        guard let specie = try? await fetchSpecies(resource: specieResource),
              let pokemon = specie.varieties?.first(where: { $0.isDefault == true })?.pokemon else { return }
        
        array.append(pokemon)
        
        for next in node.evolvesTo ?? [] {
            await extractNames(from: next, into: &array)
        }
    }
}
