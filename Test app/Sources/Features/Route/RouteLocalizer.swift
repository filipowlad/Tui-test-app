//
//  RouteLocalizer.swift
//  Test app
//
//  Created by Vladyslav Filipov on 31.01.2024.
//

import Features

final class RouteLocalizer: RouteLocalizing {
    private let defaultRouteInformationItemLocalizer = DefaultRouteInformationItemLocalizer()
    
    lazy var deleteButton: String = .init(localized: "ROUTE_DELETE_ROUTE_ACTION_TITLE")
    lazy var goesThroughTitle: String = defaultRouteInformationItemLocalizer.goesThroughTitle
    
    func price(_ price: Double) -> String {
        defaultRouteInformationItemLocalizer.price(price)
    }
    
    func stopsTitle(numberOfPasthroughLocations: Int) -> String {
        defaultRouteInformationItemLocalizer.stopsTitle(numberOfPasthroughLocations: numberOfPasthroughLocations)
    }
}
