//
//  File.swift
//  
//
//  Created by Vladyslav Filipov on 01.02.2024.
//

import API
import Combine
import XCTest
@testable import Features

@MainActor final class RoutesViewModelTests: XCTestCase {
    var localizer: MockRoutesLocalizer!
    var storage: MockStorageService!
    var viewModel: RoutesViewModel<MockRoutesLocalizer, MockStorageService>!
    
    private var cancellables: [AnyCancellable] = []
    
    override func setUp() {
        localizer = .init()
        storage = .init()
        viewModel = .init(localizer: localizer, storage: storage)
    }
    
    override func tearDown() {
        localizer = nil
        storage = nil
        viewModel = nil
    }
    
    func test_showAddNewRoute() async throws {
        let expectation = expectation(description: "showAddNewRoute received")
        
        viewModel.showAddNewRoute
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.didTapShowAddNewRoute.send()
        
        await fulfillment(of: [expectation], timeout: 0.1)
    }
    
    func test_showRoute() async throws {
        let expectation = expectation(description: "showRoute received")
        
        let route: StorageRoute = .init(
            id: .init(),
            startLocation: .init(title: "First", coordinates: .init(latitude: 0, longitude: 1)),
            destinationLocation: .init(title: "Second", coordinates: .init(latitude: 0, longitude: 2)),
            passThroughLocations: [],
            price: 1,
            creationDate: .init()
        )
        
        viewModel.showRoute
            .sink { viewData in
                XCTAssertEqual(viewData.route, route)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.didTapShowRoute.send(.init(route: route, localizer: localizer))
        
        await fulfillment(of: [expectation], timeout: 0.1)
    }
    
    func test_getRoutes() async throws {
        let expectation = expectation(description: "getRoutes received")
        let route: StorageRoute = .init(
            id: .init(),
            startLocation: .init(title: "First", coordinates: .init(latitude: 0, longitude: 1)),
            destinationLocation: .init(title: "Second", coordinates: .init(latitude: 0, longitude: 2)),
            passThroughLocations: [],
            price: 1,
            creationDate: .init()
        )
        
        storage.routesProvider = {
            expectation.fulfill()
            return [route]
        }
        
        viewModel = .init(localizer: localizer, storage: storage)
        
        await fulfillment(of: [expectation], timeout: 0.1)
        
        let routeItem = try XCTUnwrap(viewModel.state.routeItems.first)
        
        XCTAssertEqual(routeItem.id, route)
    }
    
    func test_getRoute() async throws {
        let expectation = expectation(description: "getRoute received")
        let route: StorageRoute = .init(
            id: .init(),
            startLocation: .init(title: "First", coordinates: .init(latitude: 0, longitude: 1)),
            destinationLocation: .init(title: "Second", coordinates: .init(latitude: 0, longitude: 2)),
            passThroughLocations: [],
            price: 1,
            creationDate: .init()
        )
        
        storage.routeProvider = {
            expectation.fulfill()
            return route
        }
        
        XCTAssertTrue(viewModel.state.routeItems.isEmpty)
        
        viewModel.didReceiveSavedRouteId.send(route.id)
        
        await fulfillment(of: [expectation], timeout: 0.1)
        
        let routeItem = try XCTUnwrap(viewModel.state.routeItems.first)
        
        XCTAssertEqual(routeItem.id, route)
    }
    
    func test_removeRoute() async throws {
        let expectation = expectation(description: "removeRoute received")
        let route: StorageRoute = .init(
            id: .init(),
            startLocation: .init(title: "First", coordinates: .init(latitude: 0, longitude: 1)),
            destinationLocation: .init(title: "Second", coordinates: .init(latitude: 0, longitude: 2)),
            passThroughLocations: [],
            price: 1,
            creationDate: .init()
        )
        
        storage.routesProvider = {
            [route]
        }
        
        viewModel = .init(localizer: localizer, storage: storage)
        
        let routeItem = try XCTUnwrap(viewModel.state.routeItems.first)
        
        XCTAssertEqual(routeItem.id, route)
        
        viewModel.$state
            .filter { $0.routeItems.isEmpty }
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.didReceiveRemovedRouteId.send(route.id)
        
        await fulfillment(of: [expectation], timeout: 0.1)
    }
}

