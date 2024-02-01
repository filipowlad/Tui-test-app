//
//  AddNewRouteViewState.swift
//  Test app
//
//  Created by Vladyslav Filipov on 29.01.2024.
//

import API
import Foundation
import Helpers
import _MapKit_SwiftUI

struct AddNewRouteViewState: Hashable {
    let localizer: Localizer
    private(set) var fetchState: FetchState = .initial
    private(set) var locationItems: [LocationItem] = []
    private(set) var routeItem: RouteItem?
    private(set) var startLocation: LocationItem?
    private(set) var destinationLocation: LocationItem?
    private(set) var startLocationErrorOccured: Bool = false
    private(set) var destinationLocationErrorOccured: Bool = false
    private(set) var startLocationText: String = ""
    private(set) var destinationLocationText: String = ""
    
    var mapData: MapData = .init()
    
    var startLocations: [LocationItem] {
        startLocation == nil 
        ? locationItems(for: startLocationText).filter { $0 != destinationLocation }
        : []
    }
    
    var destinationLocations: [LocationItem] {
        destinationLocation == nil 
        ? locationItems(for: destinationLocationText).filter { $0 != startLocation }
        : []
    }
}

// MARK: - Models

extension AddNewRouteViewState: Then {
    enum FetchState: Hashable {
        case initial
        case loading
        case success
        case error
    }
}

extension AddNewRouteViewState {
    struct Localizer: Hashable {
        let startLocationPrompt: String
        let destinationLocationPrompt: String
        let saveButton: String
        let loader: String
    }
    
    struct LocationItem: Hashable {
        let id: UUID = .init()
        let location: Location
        let connections: [Connection]
        
        var title: String {
            location.title
        }
    }
    
    struct RouteItem: Hashable {
        let route: Route
        let priceText: String
        let goesThroughTitle: String
        let stopsTitle: String
        
        init(
            route: Route,
            localizer: some AddNewRouteLocalizing
        ) {
            self.route = route
            self.priceText = localizer.price(route.price)
            self.goesThroughTitle = localizer.goesThroughTitle
            self.stopsTitle = localizer.stopsTitle(numberOfPasthroughLocations: route.passThroughLocations.count)
        }
    }
    
    struct Route: Hashable, Comparable {
        let id: UUID = .init()
        let destinationLocationItem: LocationItem
        let connections: [Connection]
        let locations: [Location]
        
        var startLocation: Location {
            locations.first ?? destinationLocationItem.location
        }
        
        var passThroughLocations: [Location] {
            locations.filter {
                $0 != startLocation && $0 != destinationLocationItem.location
            }
        }
        
        var price: Double {
            connections.reduce(into: 0) { price, connection in
                price += connection.price
            }
        }
        
        init(
            location: LocationItem,
            previousRoute: Route? = nil,
            connection: Connection? = nil,
            locations: [Location] = []
        ) {
            self.destinationLocationItem = location
            self.connections = previousRoute.flatMap { previousRoute in
                previousRoute.connections + [connection].compactMap { $0 }
            } ?? []
            self.locations = connections.locations
        }
        
        static func < (lhs: AddNewRouteViewState.Route, rhs: AddNewRouteViewState.Route) -> Bool {
            lhs.price < rhs.price
        }
    }
    
    struct MapData: Hashable {
        let id: UUID = .init()
        var mapCameraPosition: MapCameraPosition
        
        init() {
            mapCameraPosition = .automatic
        }
        
        init(location: Location) {
            mapCameraPosition = .camera(
                .init(
                    centerCoordinate: location.coordinates.cllocationCoordinates,
                    distance: 200000
                )
            )
        }
        
        init(route: Route) {
            self.init(location: route.startLocation)
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}

// MARK: - Factory

extension AddNewRouteViewState {
    static func initial(localizer: some AddNewRouteLocalizing) -> Self {
        .init(
            localizer: .init(
                startLocationPrompt: localizer.startLocationPrompt,
                destinationLocationPrompt: localizer.destinationLocationPrompt,
                saveButton: localizer.saveButton,
                loader: localizer.loader
            )
        )
    }
}

extension AddNewRouteViewState {
    func update(fetchState: FetchState) -> Self {
        with {
            $0.fetchState = fetchState
        }
    }
    
    func update(connections: [Connection]) -> Self {
        with {
            $0.fetchState = .success
            $0.locationItems = connections.locations.map { location in
                LocationItem(
                    location: location,
                    connections: connections.filter { $0.from == location }
                )
            }
        }
    }
}

// MARK: - Start location actions

extension AddNewRouteViewState {
    func update(startLocationText: String) -> Self {
        with {
            $0.startLocationText = startLocationText
            
            if startLocation?.title != startLocationText {
                $0.startLocation = nil
                $0.routeItem = nil
            }
        }
    }
    
    func updateStartLocationError(with pickerFocusState: Bool) -> Self {
        with {
            $0.startLocationErrorOccured = pickerFocusState && startLocation == nil
        }
    }
    
    func updateStartLocation(
        with id: UUID?,
        localizer: some AddNewRouteLocalizing
    ) -> Self {
        with {
            let locationItem = id.flatMap($0.locationItem)
            let route = buildCheapestRoute(
                startLocationItem: locationItem,
                destinationLocationItem: destinationLocation
            )
            $0.startLocation = locationItem
            $0.startLocationText = locationItem?.title ?? ""
            $0.routeItem = route.flatMap { route in
                .init(route: route, localizer: localizer)
            }
            $0.mapData = buildMapData(
                route: route,
                location: locationItem?.location
            )
        }
    }
}

// MARK: - Destination location actions

extension AddNewRouteViewState {
    func update(destinationLocationText: String) -> Self {
        with {
            $0.destinationLocationText = destinationLocationText
            
            if destinationLocation?.title != destinationLocationText {
                $0.destinationLocation = nil
                $0.routeItem = nil
            }
        }
    }
    
    func updateDestinationLocationError(with pickerFocusState: Bool) -> Self {
        with {
            $0.destinationLocationErrorOccured = pickerFocusState && destinationLocation == nil
        }
    }
    
    func updateDestinationLocation(
        with id: UUID?,
        localizer: some AddNewRouteLocalizing
    ) -> Self {
        with {
            let locationItem = id.flatMap($0.locationItem)
            let route = buildCheapestRoute(
                startLocationItem: startLocation,
                destinationLocationItem: locationItem
            )
            
            $0.destinationLocation = locationItem
            $0.destinationLocationText = locationItem?.title ?? ""
            $0.routeItem = route.flatMap { route in
                .init(route: route, localizer: localizer)
            }
            $0.mapData = buildMapData(
                route: route,
                location: locationItem?.location
            )
        }
    }
}

// MARK: - Cheapest route

private extension AddNewRouteViewState {
    func buildCheapestRoute(
        startLocationItem: LocationItem?,
        destinationLocationItem: LocationItem?
    ) -> Route? {
        guard
            let startLocationItem = startLocationItem,
            let destinationLocationItem = destinationLocationItem
        else { return nil }
        
        var checkedLocations: Set<LocationItem> = .init()
        var routes: [Route] = [.init(location: startLocationItem)]
        
        while !routes.isEmpty {
            let route = routes.removeFirst()
            
            if checkedLocations.contains(route.destinationLocationItem) { continue }
            
            checkedLocations.insert(route.destinationLocationItem)
            
            if route.destinationLocationItem == destinationLocationItem { return route }
            
            let newRoutes = buildConnectionRoutes(for: route, checkedLocations: checkedLocations)
            
            routes.append(contentsOf: newRoutes)
            routes.sort()
        }
        
        return nil
    }
    
    func buildConnectionRoutes(for route: Route, checkedLocations: Set<LocationItem>) -> [Route] {
        route.destinationLocationItem.connections.reduce(into: []) { routes, connection in
            guard let item = locationItem(connection.to), !checkedLocations.contains(item) else { return }
            routes.append(
                Route(
                    location: item,
                    previousRoute: route,
                    connection: connection
                )
            )
        }
    }
}

// MARK: - Utilities

private extension AddNewRouteViewState {
    func buildMapData(
        route: Route?,
        location: Location?
    ) -> MapData {
        route.flatMap(MapData.init) ?? location.flatMap(MapData.init) ?? mapData
    }
    
    func locationItems(for request: String) -> [LocationItem] {
        request.isEmpty ? [] : locationItems.filter { $0.location.title.starts(with: request) }
    }
    
    func locationItem(with id: UUID?) -> LocationItem? {
        locationItems.first(where: { $0.id == id })
    }
    
    func locationItem(_ location: Location) -> LocationItem? {
        locationItems.first(where: { $0.location == location })
    }
}

extension Array where Element == Connection {
    var locations: [Location] {
        reduce(into: []) { locations, connection in
            if !locations.contains(connection.from) {
                locations.append(connection.from)
            }
            
            if !locations.contains(connection.to) {
                locations.append(connection.to)
            }
        }
    }
}
