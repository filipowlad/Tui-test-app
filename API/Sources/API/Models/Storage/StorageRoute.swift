//
//  StorageRoute.swift
//  Test app
//
//  Created by Vladyslav Filipov on 29.01.2024.
//

import Foundation

public struct StorageRoute: Hashable, Codable, Identifiable {
    public let id: UUID
    public let startLocation: Location
    public let destinationLocation: Location
    public let passThroughLocations: [Location]
    public let price: Double
    public let creationDate: Date
    
    public var locations: [Location] {
        [startLocation] + passThroughLocations + [destinationLocation]
    }
    
    public init(
        id: UUID,
        startLocation: Location,
        destinationLocation: Location,
        passThroughLocations: [Location],
        price: Double,
        creationDate: Date
    ) {
        self.id = id
        self.startLocation = startLocation
        self.destinationLocation = destinationLocation
        self.passThroughLocations = passThroughLocations
        self.price = price
        self.creationDate = creationDate
    }
}
