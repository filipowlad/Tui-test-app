//
//  File.swift
//  
//
//  Created by Vladyslav Filipov on 31.01.2024.
//

import API
import Features
import Foundation

enum MockedError: Error {
    case connectionsNotLoading
}

final class MockConnectionsService: ConnectionsService {
    var connectionsProvider: (() throws -> [Connection])?
    func fetchConnections() async throws -> [Connection] {
        try connectionsProvider?() ?? []
    }
}

final class MockStorageService: StorageService {
    var saveRouteProvider: (() -> Void)?
    func save(route: StorageRoute) {
        saveRouteProvider?()
    }
    
    var removeRouteProvider: (() -> Void)?
    func remove(route: StorageRoute) { 
        removeRouteProvider?()
    }
    
    var routeProvider: (() -> StorageRoute?)?
    func getRoute(with id: UUID) -> StorageRoute? {
        routeProvider?()
    }
    
    var routesProvider: (() -> [StorageRoute])?
    func getRoutes() -> [StorageRoute] {
        routesProvider?() ?? []
    }
}

final class MockAddNewRouteLocalizer: AddNewRouteLocalizing {
    var startLocationPrompt: String { "startLocationPrompt" }
    var destinationLocationPrompt: String { "destinationLocationPrompt" }
    var saveButton: String { "saveButton" }
    var loader: String { "loader" }
    var goesThroughTitle: String { "goesThroughTitle" }
    
    func price(_ price: Double) -> String {
        "\(price)"
    }
    
    func stopsTitle(numberOfPasthroughLocations: Int) -> String {
        "\(numberOfPasthroughLocations)"
    }
}

final class MockRouteLocalizer: RouteLocalizing {
    var deleteButton: String { "deleteButton" }
    var goesThroughTitle: String { "goesThroughTitle" }
    
    func price(_ price: Double) -> String {
        "\(price)"
    }
    
    func stopsTitle(numberOfPasthroughLocations: Int) -> String {
        "\(numberOfPasthroughLocations)"
    }
}

final class MockRoutesLocalizer: RoutesLocalizing {
    var addNewRoute: String { "addNewRoute" }
    var goesThroughTitle: String { "goesThroughTitle" }
    
    func price(_ price: Double) -> String {
        "\(price)"
    }
    
    func stopsTitle(numberOfPasthroughLocations: Int) -> String {
        "\(numberOfPasthroughLocations)"
    }
}
