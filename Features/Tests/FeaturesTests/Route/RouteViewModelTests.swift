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

@MainActor final class RouteViewModelTests: XCTestCase {
    var viewData: RouteViewData!
    var localizer: MockRouteLocalizer!
    var storage: MockStorageService!
    var viewModel: RouteViewModel<MockRouteLocalizer, MockStorageService>!
    
    private var cancellables: [AnyCancellable] = []
    
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
        storage = .init()
        viewModel = .init(localizer: localizer, storageService: storage, viewData: viewData)
    }
    
    override func tearDown() {
        viewData = nil
        localizer = nil
        storage = nil
        viewModel = nil
    }
    
    func test_deleteRoute() async throws {
        let expectedId = viewData.route.id
        let resultExpectation = expectation(description: "coordinationResult received")
        let storageExpectation = expectation(description: "routeRemoved")
        
        storage.removeRouteProvider = {
            storageExpectation.fulfill()
        }
        
        viewModel.shouldClose
            .sink { id in
                XCTAssertEqual(id, expectedId)
                resultExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.deleteRoute()
        
        await fulfillment(of: [
            resultExpectation,
            storageExpectation
        ], timeout: 0.1)
    }
}
