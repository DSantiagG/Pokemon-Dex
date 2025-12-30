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
    
    private let api: PokemonAPI
    private let core: ResourceService<PokemonEndpoints>
    
    init() {
        self.api = PokemonAPI()
        self.core = ResourceService<PokemonEndpoints>()
    }
    
    private var typeCache = [String: PKMType]()
    private var speciesCache = [String: PKMPokemonSpecies]()
    private var chainCache = [Int: [EvolutionStage]]()
    
    private var typeResourcesCache: [PKMAPIResource<PKMType>]?
    
    // MARK: - Pagination
    
    func fetchInitialPage(limit: Int) async throws -> [PKMPokemon] {
        try await core.fetchInitialPage(limit: limit)
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
    
    // MARK: - Fetch List by resources / types
    func fetch(from resources: [PKMAPIResource<PKMPokemon>]) async throws -> [PKMPokemon] {
        try await core.fetch(from: resources)
    }
    
    func fetch(byTypes types: [PKMAPIResource<PKMType>]) async throws -> [PKMPokemon] {
        var pokemonsPerType: [[PKMAPIResource<PKMPokemon>]] = []

        for typeResource in types {
            let type = try await fetchType(resource: typeResource)
            pokemonsPerType.append(type.pokemon?.compactMap{ $0.pokemon } ?? [])
        }

        guard let basePokemons = pokemonsPerType.first else { return [] }
        
        let intersectedPokemons = basePokemons.filter { pokemon in
            pokemonsPerType.dropFirst().allSatisfy { typeList in
                typeList.contains { $0.name == pokemon.name }
            }
        }

        return try await fetch(from: intersectedPokemons)
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
    
    // MARK: - Types List
    
    func fetchAllTypeResources() async throws -> [PKMAPIResource<PKMType>] {
        if let cached = typeResourcesCache { return cached }
        
        let result = try await api.pokemonService.fetchTypeList()
        let res = result.results ?? []
        typeResourcesCache = res
        return res
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
