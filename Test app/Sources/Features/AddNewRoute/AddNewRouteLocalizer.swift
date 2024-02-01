//
//  AddNewRouteLocalizer.swift
//  Test app
//
//  Created by Vladyslav Filipov on 31.01.2024.
//

import Features

final class AddNewRouteLocalizer: AddNewRouteLocalizing {
    private let defaultRouteInformationItemLocalizer = DefaultRouteInformationItemLocalizer()
    
    lazy var startLocationPrompt: String = .init(localized: "ADD_NEW_ROUTE_START_PROMPT")
    lazy var destinationLocationPrompt: String = .init(localized: "ADD_NEW_ROUTE_DESTINATION_PROMPT")
    lazy var saveButton: String = .init(localized: "ADD_NEW_ROUTE_SAVE_ROUTE_ACTION_TITLE")
    lazy var loader: String = .init(localized: "ADD_NEW_ROUTE_LOADER_TEXT")
    lazy var goesThroughTitle: String = defaultRouteInformationItemLocalizer.goesThroughTitle
    
    func price(_ price: Double) -> String {
        defaultRouteInformationItemLocalizer.price(price)
    }
    
    func stopsTitle(numberOfPasthroughLocations: Int) -> String {
        defaultRouteInformationItemLocalizer.stopsTitle(numberOfPasthroughLocations: numberOfPasthroughLocations)
    }
}
