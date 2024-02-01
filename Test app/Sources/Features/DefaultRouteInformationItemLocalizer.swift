//
//  DefaultRouteInformationItemLocalizer.swift
//  Test app
//
//  Created by Vladyslav Filipov on 31.01.2024.
//

final class DefaultRouteInformationItemLocalizer {
    lazy var goesThroughTitle: String = .init(localized: "ROUTE_INFORMATION_PASSTHROUGH_TITLE")
    
    func price(_ price: Double) -> String {
        .init(format: "%.2f $", price)
    }
    
    func stopsTitle(numberOfPasthroughLocations: Int) -> String {
        numberOfPasthroughLocations == 0
        ? .init(localized: "ROUTE_INFORMATION_NO_STOPS_TITLE")
        : .init(localized: "ROUTE_INFORMATION_\(numberOfPasthroughLocations)_OF_STOPS_TITLE")
    }
}
