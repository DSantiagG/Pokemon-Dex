//
//  PokemonService.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/11/25.
//
import PokemonAPI
import Foundation

enum PokemonEndpoints: ResourceEndpoints {
    static func fetchPage(_ state: PaginationState<PKMPokemon>) async throws -> PKMPagedObject<PKMPokemon> {
        try await PokemonAPI().pokemonService.fetchPokemonList(paginationState: state)
    }

    static func fetchByName(_ name: String) async throws -> PKMPokemon {
        try await PokemonAPI().pokemonService.fetchPokemon(name)
    }
}

actor PokemonService: PagingService, SearchService {
    
    private let api = PokemonAPI()
    
    private let core = ResourceService<PokemonEndpoints>()
    
    private var typeCache = [String: PKMType]()
    private var speciesCache = [String: PKMPokemonSpecies]()
    private var chainCache = [Int: [EvolutionStage]]()
    
    // MARK: - Pagination
    
    func fetchInitialPage() async throws -> [PKMPokemon] {
        try await core.fetchInitialPage()
    }
    
    func fetchNextPage() async throws -> [PKMPokemon]? {
        try await core.fetchNextPage()
    }
    
    func fetchAllResources() async throws -> [PKMAPIResource<PKMPokemon>] {
        try await core.fetchAllResources()
    }
    
    // MARK: - Fetch by name / resource
    
    func fetch(name: String) async throws -> PKMPokemon {
        try await core.fetch(byName: name)
    }
    
    func fetch(resource: PKMAPIResource<PKMPokemon>) async throws -> PKMPokemon {
        try await core.fetch(byResource: resource)
    }
    
    // MARK: - Fetch List
    func fetch(from resources: [PKMAPIResource<PKMPokemon>]) async throws -> [PKMPokemon] {
        try await core.fetch(from: resources)
    }
    
    // MARK: - Types
    
    func fetchType(resource: PKMAPIResource<PKMType>) async throws -> PKMType {
        let key = resource.name ?? resource.url ?? "unknown"
        if let cached = typeCache[key] { return cached }
        
        let type = try await api.resourceService.fetch(resource)
        typeCache[key] = type
        return type
    }
    
    // MARK: - Species
    
    func fetchSpecies(resource: PKMAPIResource<PKMPokemonSpecies>) async throws -> PKMPokemonSpecies {
        let key = resource.name ?? resource.url ?? "unknown"
        if let cached = speciesCache[key] { return cached }
        
        let species = try await api.resourceService.fetch(resource)
        speciesCache[key] = species
        return species
    }
    
    // MARK: - Evolution Chain
    
    func fetchEvolutionChain(resource: PKMAPIResource<PKMEvolutionChain>) async throws -> [EvolutionStage]? {
        
        guard let url = resource.url else { return nil }
        
        if let id = Int(url.split(separator: "/").last ?? ""), let cached = chainCache[id] { return cached }
        
        let chain = try await api.resourceService.fetch(resource)
        guard let root = chain.chain else { return nil }
        
        var pokemonResources: [PKMAPIResource<PKMPokemon>] = []
        await extractNames(from: root, into: &pokemonResources)
        
        var stages: [EvolutionStage] = []
        for resource in pokemonResources {
            let poke = try await fetch(resource: resource)
            let sprite = poke.sprites?.other?.officialArtwork?.frontDefault
            stages.append(EvolutionStage(name: poke.name, sprite: sprite))
        }
        
        if let id = chain.id {
            chainCache[id] = stages
        }
        
        return stages
    }
    
    // MARK: --- Helpers
    
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
