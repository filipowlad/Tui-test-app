//
//  Connections.swift
//  Test app
//
//  Created by Vladyslav Filipov on 28.01.2024.
//

import MapKit

public struct Connections: Decodable, Hashable {
    public let connections: [Connection]
}

public struct Connection: Decodable, Hashable {
    public let from: Location
    public let to: Location
    public let price: Double
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fromTitle = try container.decode(String.self, forKey: .fromTitle)
        let toTitle = try container.decode(String.self, forKey: .toTitle)
        let coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
        
        from = .init(title: fromTitle, coordinates: coordinates.from)
        to = .init(title: toTitle, coordinates: coordinates.to)
        price = try container.decode(Double.self, forKey: .price)
    }
    
    public init(
        from: Location,
        to: Location,
        price: Double
    ) {
        self.from = from
        self.to = to
        self.price = price
    }
    
    enum CodingKeys: String, CodingKey {
        case fromTitle = "from"
        case toTitle = "to"
        case coordinates
        case price
    }
}

public struct Location: Codable, Hashable {
    public let title: String
    public let coordinates: LocationsCoordinates
    
    public init(
        title: String,
        coordinates: LocationsCoordinates
    ) {
        self.title = title
        self.coordinates = coordinates
    }
}

public struct Coordinates: Codable, Hashable {
    public let from: LocationsCoordinates
    public let to: LocationsCoordinates
    
    public init(
        from: LocationsCoordinates,
        to: LocationsCoordinates
    ) {
        self.from = from
        self.to = to
    }
}

public struct LocationsCoordinates: Codable, Hashable {
    public let latitude: Double
    public let longitude: Double
    
    public var cllocationCoordinates: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
    
    public init(
        latitude: Double,
        longitude: Double
    ) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "long"
    }
}
