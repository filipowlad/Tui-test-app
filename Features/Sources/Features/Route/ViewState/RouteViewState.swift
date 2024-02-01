//
//  RouteViewState.swift
//  Test app
//
//  Created by Vladyslav Filipov on 29.01.2024.
//

import API
import Helpers
import _MapKit_SwiftUI

struct RouteViewState: Hashable, Then {
    let route: StorageRoute
    let priceText: String
    let goesThroughTitle: String
    let stopsTitle: String
    let deleteButtonTitle: String
    var mapData: MapData
}

// MARK: - Models

extension RouteViewState {
    struct MapData: Hashable {
        let id: UUID = .init()
        var mapCameraPosition: MapCameraPosition
        
        init(route: StorageRoute) {
            mapCameraPosition = .camera(
                .init(
                    centerCoordinate: .init(
                        latitude: route.startLocation.coordinates.latitude,
                        longitude: route.startLocation.coordinates.longitude
                    ),
                    distance: 200000
                )
            )
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}

// MARK: - Factory

extension RouteViewState {
    static func initial(viewData: RouteViewData, localizer: some RouteLocalizing) -> Self {
        .init(
            route: viewData.route,
            priceText: localizer.price(viewData.route.price),
            goesThroughTitle: localizer.goesThroughTitle,
            stopsTitle: localizer.stopsTitle(numberOfPasthroughLocations: viewData.route.passThroughLocations.count),
            deleteButtonTitle: localizer.deleteButton,
            mapData: .init(route: viewData.route)
        )
    }
    
    func updateMapCameraPosition(_ mapCameraPosition: MapCameraPosition) -> Self {
        with {
            $0.mapData.mapCameraPosition = mapCameraPosition
        }
    }
}
