//
//  RoutesViewState.swift
//  Test app
//
//  Created by Vladyslav Filipov on 29.01.2024.
//

import API
import Helpers
import Foundation

struct RoutesViewState: Hashable, Then {
    let addNewRouteTitle: String
    var routeItems: [RouteItem] = []
}

extension RoutesViewState {
    struct RouteItem: Identifiable, Hashable, Comparable {
        var id: StorageRoute { route }
        let route: StorageRoute
        let priceText: String
        let goesThroughTitle: String
        let stopsTitle: String
        
        init(
            route: StorageRoute,
            localizer: some RoutesLocalizing
        ) {
            self.route = route
            self.priceText = localizer.price(route.price)
            self.goesThroughTitle = localizer.goesThroughTitle
            self.stopsTitle = localizer.stopsTitle(numberOfPasthroughLocations: route.passThroughLocations.count)
        }
        
        static func < (lhs: RoutesViewState.RouteItem, rhs: RoutesViewState.RouteItem) -> Bool {
            lhs.route.creationDate > rhs.route.creationDate
        }
    }
}

extension RoutesViewState {
    static func initial(
        routes: [StorageRoute],
        localizer: some RoutesLocalizing
    ) -> Self {
        .init(
            addNewRouteTitle: localizer.addNewRoute, 
            routeItems: routes.map { route in
                .init(route: route, localizer: localizer)
            }.sorted()
        )
    }
    
    func addRoute(
        _ route: StorageRoute?,
        localizer: some RoutesLocalizing
    ) -> Self {
        with {
            $0.routeItems = [
                route.flatMap { route in
                    .init(route: route, localizer: localizer)
                }
            ].compactMap { $0 } + routeItems
            $0.routeItems.sort()
        }
    }
    
    func removeRoute(with id: UUID) -> Self {
        with {
            $0.routeItems = routeItems.filter { $0.route.id != id }
        }
    }
}
