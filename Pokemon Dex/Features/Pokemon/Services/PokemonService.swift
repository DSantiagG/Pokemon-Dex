//
//  PokemonService.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/11/25.
//
import PokemonAPI
import Foundation

//TODO: Ver si cado uno de los prints de cache si se ejecutan
actor PokemonService {
    private let api = PokemonAPI()
    private var pagedObject: PKMPagedObject<PKMPokemon>?

    private var pokemonCache = [String: PKMPokemon]()
    private var speciesCache = [String: PKMPokemonSpecies]()
    private var chainCache = [Int: [EvolutionStage]]()
    private var typeCache = [String: PKMType]()

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
        if let cached = pokemonCache[name] {
            print("Retornando de cache de pokemon: \(name)")
            return cached
        }
        let pokemon = try await api.pokemonService.fetchPokemon(name)
        pokemonCache[name] = pokemon
        return pokemon
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
        
        var names: [String] = []
        extractNames(from: root, into: &names)
        
        var stages: [EvolutionStage] = []
        for name in names {
            let poke = try await fetchPokemon(name: name)
            let sprite = poke.sprites?.other?.officialArtwork?.frontDefault
            stages.append(EvolutionStage(name: name, sprite: sprite))
        }
        
        if let id = chain.id {
            chainCache[id] = stages
        }
        
        return stages
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
    
    private func fetchPokemons(from results: [PKMAPIResource<PKMPokemon>]) async throws -> [PKMPokemon] {
        try await withThrowingTaskGroup(of: (Int, PKMPokemon).self) { group in
            for (index, result) in results.enumerated() {
                group.addTask {
                    let name = result.name ?? ""
                    let pokemon = try await self.fetchPokemon(name: name)
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
    
    private func extractNames(from node: PKMChainLink, into array: inout [String]) {
        if let speciesName = node.species?.name, !speciesName.isEmpty {
            array.append(speciesName)
        }
        for next in node.evolvesTo ?? [] {
            extractNames(from: next, into: &array)
        }
    }
}

