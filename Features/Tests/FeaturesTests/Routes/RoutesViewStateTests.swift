//
//  File.swift
//  
//
//  Created by Vladyslav Filipov on 01.02.2024.
//

import API
import XCTest
@testable import Features

final class RoutesViewStateTests: XCTestCase {
    var localizer: MockRoutesLocalizer!
    
    override func setUp() {
        localizer = .init()
    }
    
    override func tearDown() {
        localizer = nil
    }
    
    func test_initial_state_withoutRoutes() {
        let initialState: RoutesViewState = .initial(routes: [], localizer: localizer)
        XCTAssertEqual(initialState.addNewRouteTitle, localizer.addNewRoute)
        XCTAssertTrue(initialState.routeItems.isEmpty)
    }
    
    func test_initial_state_withRoutes() throws {
        let routes: [StorageRoute] = [
            .init(
                id: .init(),
                startLocation: .init(title: "First", coordinates: .init(latitude: 0, longitude: 1)),
                destinationLocation: .init(title: "Second", coordinates: .init(latitude: 0, longitude: 2)),
                passThroughLocations: [],
                price: 1,
                creationDate: .init()
            ),
            .init(
                id: .init(),
                startLocation: .init(title: "First", coordinates: .init(latitude: 0, longitude: 1)),
                destinationLocation: .init(title: "Second", coordinates: .init(latitude: 0, longitude: 2)),
                passThroughLocations: [],
                price: 1,
                creationDate: .init(timeIntervalSinceNow: 1000)
            )
        ]
        let initialState: RoutesViewState = .initial(
            routes: routes,
            localizer: localizer
        )
        
        // testing order
        XCTAssertEqual(initialState.routeItems.map(\.id), routes.reversed())
        
        let route = try XCTUnwrap(initialState.routeItems.first)
        
        XCTAssertEqual(route.goesThroughTitle, localizer.goesThroughTitle)
        XCTAssertEqual(route.priceText, localizer.price(1))
        XCTAssertEqual(route.stopsTitle, localizer.stopsTitle(numberOfPasthroughLocations: 0))
    }
    
    func test_add_route() throws {
        var viewState: RoutesViewState = .initial(routes: [], localizer: localizer)
        XCTAssertTrue(viewState.routeItems.isEmpty)
        
        let route: StorageRoute = .init(
            id: .init(),
            startLocation: .init(title: "First", coordinates: .init(latitude: 0, longitude: 1)),
            destinationLocation: .init(title: "Second", coordinates: .init(latitude: 0, longitude: 2)),
            passThroughLocations: [],
            price: 1,
            creationDate: .init()
        )
        
        viewState = viewState.addRoute(route, localizer: localizer)
        
        XCTAssertEqual(viewState.routeItems.count, 1)
        
        let routeItem = try XCTUnwrap(viewState.routeItems.first)
        
        XCTAssertEqual(routeItem.id, route)
    }
}

