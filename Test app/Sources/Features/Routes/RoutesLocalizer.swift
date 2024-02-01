//
//  RoutesLocalizer.swift
//  Test app
//
//  Created by Vladyslav Filipov on 31.01.2024.
//

import Features

final class RoutesLocalizer: RoutesLocalizing {
    private let defaultRouteInformationItemLocalizer = DefaultRouteInformationItemLocalizer()
    
    lazy var addNewRoute: String = .init(localized: "ADD_NEW_ROUTE_ACTION_TITLE")
    lazy var goesThroughTitle: String = defaultRouteInformationItemLocalizer.goesThroughTitle
    
    func price(_ price: Double) -> String {
        defaultRouteInformationItemLocalizer.price(price)
    }
    
    func stopsTitle(numberOfPasthroughLocations: Int) -> String {
        defaultRouteInformationItemLocalizer.stopsTitle(numberOfPasthroughLocations: numberOfPasthroughLocations)
    }
}
