//
//  File.swift
//  
//
//  Created by Vladyslav Filipov on 01.02.2024.
//

import API
import XCTest
@testable import Features

final class RouteViewStateTests: XCTestCase {
    var viewData: RouteViewData!
    var localizer: MockRouteLocalizer!
    var initialState: RouteViewState!
    
    override func setUp() {
        viewData = .init(
            route: .init(
                id: .init(),
                startLocation: .init(title: "First", coordinates: .init(latitude: 0, longitude: 1)),
                destinationLocation: .init(title: "Second", coordinates: .init(latitude: 0, longitude: 2)),
                passThroughLocations: [],
                price: 1,
                creationDate: .init()
            )
        )
        localizer = .init()
        initialState = .initial(viewData: viewData, localizer: localizer)
    }
    
    override func tearDown() {
        viewData = nil
        localizer = nil
        initialState = nil
    }
    
    func test_initial_state() {
        XCTAssertEqual(initialState.deleteButtonTitle, localizer.deleteButton)
        XCTAssertEqual(initialState.goesThroughTitle, localizer.goesThroughTitle)
        XCTAssertEqual(initialState.priceText, localizer.price(1))
        XCTAssertEqual(initialState.stopsTitle, localizer.stopsTitle(numberOfPasthroughLocations: 0))
    }
}
