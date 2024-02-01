//
//  AddNewRouteViewStateTests.swift
//
//
//  Created by Vladyslav Filipov on 31.01.2024.
//

import API
import XCTest
@testable import Features

final class AddNewRouteViewStateTests: XCTestCase {
    var localizer: MockAddNewRouteLocalizer!
    var initialState: AddNewRouteViewState!
    
    override func setUp() {
        localizer = .init()
        initialState = .initial(localizer: localizer)
    }
    
    override func tearDown() {
        localizer = nil
        initialState = nil
    }
    
    func test_initial_state() {
        XCTAssertEqual(initialState.fetchState, .initial)
        XCTAssertEqual(initialState.localizer.startLocationPrompt, localizer.startLocationPrompt)
        XCTAssertEqual(initialState.localizer.destinationLocationPrompt, localizer.destinationLocationPrompt)
        XCTAssertEqual(initialState.localizer.saveButton, localizer.saveButton)
        XCTAssertEqual(initialState.localizer.loader, localizer.loader)
    }
    
    func test_update_fetchState_state() {
        XCTAssertEqual(initialState.fetchState, .initial)
        
        let viewState = initialState.update(fetchState: .success)
        
        XCTAssertEqual(viewState.fetchState, .success)
    }
    
    func test_update_startLocationText_state() {
        XCTAssertEqual(initialState.startLocationText, "")
        
        let viewState = initialState.update(startLocationText: "startLocationText")
        
        XCTAssertEqual(viewState.startLocationText, "startLocationText")
    }
    
    func test_update_destinationLocationText_state() {
        XCTAssertEqual(initialState.destinationLocationText, "")
        
        let viewState = initialState.update(destinationLocationText: "destinationLocationText")
        
        XCTAssertEqual(viewState.destinationLocationText, "destinationLocationText")
    }
    
    func test_update_startLocationErrorOccured_state() {
        XCTAssertEqual(initialState.startLocationErrorOccured, false)
        
        let viewState = initialState.updateStartLocationError(with: true)
        
        XCTAssertEqual(viewState.startLocationErrorOccured, true)
    }
    
    func test_update_destinationLocationErrorOccured_state() {
        XCTAssertEqual(initialState.destinationLocationErrorOccured, false)
        
        let viewState = initialState.updateDestinationLocationError(with: true)
        
        XCTAssertEqual(viewState.destinationLocationErrorOccured, true)
    }
    
    func test_update_connections_state() throws {
        XCTAssertNil(initialState.routeItem)
        XCTAssertTrue(initialState.locationItems.isEmpty)
        
        let firstLocation = Location(title: "First", coordinates: .init(latitude: 0, longitude: 1))
        let secondLocation = Location(title: "Second", coordinates: .init(latitude: 0, longitude: 2))
        let thirdLocation = Location(title: "Third", coordinates: .init(latitude: 0, longitude: 3))
        
        let connections = [
            Connection(from: firstLocation, to: secondLocation, price: 2),
            Connection(from: firstLocation, to: thirdLocation, price: 10),
            Connection(from: secondLocation, to: thirdLocation, price: 5),
        ]
        
        var viewState = initialState.update(connections: connections)
        
        XCTAssertEqual(viewState.locationItems.count, 3)
        
        let firstLocationItem = try XCTUnwrap(viewState.locationItems.first(where: { $0.title == "First" }))
        let thirdLocationItem = try XCTUnwrap(viewState.locationItems.first(where: { $0.title == "Third" }))
        
        viewState = viewState.updateStartLocation(with: firstLocationItem.id, localizer: localizer)
        viewState = viewState.updateDestinationLocation(with: thirdLocationItem.id, localizer: localizer)
        
        let routeItem = try XCTUnwrap(viewState.routeItem)
        
        XCTAssertEqual(routeItem.route.price, 7)
        XCTAssertEqual(routeItem.route.passThroughLocations.count, 1)
    }
}
