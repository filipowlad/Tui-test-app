//
//  RouteViewModel.swift
//  Test app
//
//  Created by Vladyslav Filipov on 29.01.2024.
//

import API
import Combine
import _MapKit_SwiftUI

@MainActor public class RouteViewModel<
    Localizer: RouteLocalizing,
    Storage: StorageService
>: ObservableObject {
    typealias ViewState = RouteViewState
    
    // MARK: - Dependencies
    
    private let localizer: Localizer
    private let storageService: Storage
    
    // MARK: - Coordination result
    
    let removedRouteWithId: PassthroughSubject<UUID, Never> = .init()
    public private(set) lazy var shouldClose: AnyPublisher<UUID, Never> = removedRouteWithId.eraseToAnyPublisher()
    
    @Published private(set) var state: ViewState
    
    public init(
        localizer: Localizer,
        storageService: Storage,
        viewData: RouteViewData
    ) {
        self.localizer = localizer
        self.storageService = storageService
        self.state = .initial(viewData: viewData, localizer: localizer)
    }
}

// MARK: - Actions

extension RouteViewModel {
    func deleteRoute() {
        storageService.remove(route: state.route)
        removedRouteWithId.send(state.route.id)
    }
    
    func updateMapCameraPosition(_ mapCameraPosition: MapCameraPosition) {
        state = state.updateMapCameraPosition(mapCameraPosition)
    }
}
