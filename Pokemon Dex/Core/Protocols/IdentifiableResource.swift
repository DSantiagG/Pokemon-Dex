//
//  IdentifiableResource.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/12/25.
//


/// A minimal protocol for resources that expose a stable, human-readable name.
///
/// Types conforming to `IdentifiableResource` provide a single `resourceName`
/// property which can be used for display, identification in lists, or as a
/// lightweight fallback when constructing identifiers.
// MARK: - Identifiable Resource Protocol
protocol IdentifiableResource {
    /// A human-readable identifier for the resource.
    var resourceName: String { get }
}
