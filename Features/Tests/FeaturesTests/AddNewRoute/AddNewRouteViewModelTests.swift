//
//  AddNewRouteViewModelTests.swift
//  
//
//  Created by Vladyslav Filipov on 31.01.2024.
//

import API
import Combine
import XCTest
@testable import Features

@MainActor final class AddNewRouteViewModelTests: XCTestCase {
    var localizer: MockAddNewRouteLocalizer!
    var connections: MockConnectionsService!
    var storage: MockStorageService!
    var viewModel: AddNewRouteViewModel<MockAddNewRouteLocalizer, MockConnectionsService, MockStorageService>!
    
    private var cancellables: [AnyCancellable] = []
    
    override func setUp() {
        localizer = .init()
        connections = .init()
        storage = .init()
        viewModel = .init(localizer: localizer, connectionsService: connections, storageService: storage)
    }
    
    override func tearDown() {
        localizer = nil
        connections = nil
        storage = nil
        viewModel = nil
    }
    
    func test_fetch_success() async {
        XCTAssertEqual(viewModel.state.fetchState, .initial)
        
        await viewModel.initialFetch()
        
        XCTAssertEqual(viewModel.state.fetchState, .success)
    }
    
    func test_fetch_error() async {
        XCTAssertEqual(viewModel.state.fetchState, .initial)
        
        connections.connectionsProvider = {
            throw MockedError.connectionsNotLoading
        }
        
        await viewModel.initialFetch()
        
        XCTAssertEqual(viewModel.state.fetchState, .error)
    }
    
    func test_update_startLocationText_state() {
        XCTAssertEqual(viewModel.state.startLocationText, "")
        
        viewModel.updateStartLocationText("startLocationText")
        
        XCTAssertEqual(viewModel.state.startLocationText, "startLocationText")
    }
    
    func test_update_destinationLocationText_state() {
        XCTAssertEqual(viewModel.state.destinationLocationText, "")
        
        viewModel.updateDestinationLocationText("destinationLocationText")
        
        XCTAssertEqual(viewModel.state.destinationLocationText, "destinationLocationText")
    }
    
    func test_update_startLocationErrorOccured_state() {
        XCTAssertEqual(viewModel.state.startLocationErrorOccured, false)
        
        viewModel.updateStartLocationError(with: true)
        
        XCTAssertEqual(viewModel.state.startLocationErrorOccured, true)
    }
    
    func test_update_destinationLocationErrorOccured_state() {
        XCTAssertEqual(viewModel.state.destinationLocationErrorOccured, false)
        
        viewModel.updateDestinationLocationError(with: true)
        
        XCTAssertEqual(viewModel.state.destinationLocationErrorOccured, true)
    }
    
    func test_coordinationResult() async {
        let expectedId: UUID = .init()
        let expectation = expectation(description: "coordinationResult received")
        
        viewModel.shouldClose
            .sink { id in
                XCTAssertEqual(id, expectedId)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.savedRouteWithId.send(expectedId)
        
        await fulfillment(of: [expectation], timeout: 0.1)
    }
    
    func test_saveRoute() async throws {
        let resultExpectation = expectation(description: "coordinationResult received")
        let storageExpectation = expectation(description: "routeRemoved")
        
        connections.connectionsProvider = {
            let firstLocation = Location(title: "First", coordinates: .init(latitude: 0, longitude: 1))
            let secondLocation = Location(title: "Second", coordinates: .init(latitude: 0, longitude: 2))
            let thirdLocation = Location(title: "Third", coordinates: .init(latitude: 0, longitude: 3))
            
            let connections = [
                Connection(from: firstLocation, to: secondLocation, price: 2),
                Connection(from: firstLocation, to: thirdLocation, price: 10),
                Connection(from: secondLocation, to: thirdLocation, price: 5),
            ]
            
            return connections
        }
        
        storage.saveRouteProvider = {
            storageExpectation.fulfill()
        }
        
        viewModel.shouldClose
            .sink { id in
                resultExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        await viewModel.initialFetch()
        
        let firstLocationItem = try XCTUnwrap(viewModel.state.locationItems.first(where: { $0.title == "First" }))
        let thirdLocationItem = try XCTUnwrap(viewModel.state.locationItems.first(where: { $0.title == "Third" }))
        
        viewModel.updateStartLocation(with: firstLocationItem.id)
        viewModel.updateDestinationLocation(with: thirdLocationItem.id)
        
        viewModel.saveRoute()
        
        await fulfillment(of: [
            resultExpectation,
            storageExpectation
        ], timeout: 0.1)
    }
}
