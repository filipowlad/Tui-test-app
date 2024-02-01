//
//  RoutesViewModel.swift
//  Test app
//
//  Created by Vladyslav Filipov on 27.01.2024.
//

import API
import Combine
import Foundation

@MainActor public class RoutesViewModel<
    Localizer: RoutesLocalizing,
    Storage: StorageService
>: ObservableObject {
    typealias ViewState = RoutesViewState
    
    // MARK: - Dependencies
    
    private let localizer: Localizer
    private let storage: Storage
    
    // MARK: - Output
    
    let didTapShowRoute: PassthroughSubject<ViewState.RouteItem, Never> = .init()
    public private(set) lazy var showRoute: AnyPublisher<RouteViewData, Never> = didTapShowRoute
        .map(\.route)
        .map(RouteViewData.init)
        .eraseToAnyPublisher()
    
    let didTapShowAddNewRoute: PassthroughSubject<Void, Never> = .init()
    public private(set) lazy var showAddNewRoute: AnyPublisher<Void, Never> = didTapShowAddNewRoute.eraseToAnyPublisher()
    
    // MARK: - Input
    
    public let didReceiveSavedRouteId: PassthroughSubject<UUID, Never> = .init()
    public let didReceiveRemovedRouteId: PassthroughSubject<UUID, Never> = .init()
    
    @Published private(set) var state: ViewState
    private var cancellables: [AnyCancellable] = []
    
    public init(
        localizer: Localizer,
        storage: Storage
    ) {
        self.localizer = localizer
        self.storage = storage
        self.state = .initial(
            routes: storage.getRoutes(),
            localizer: localizer
        )
        
        setupObservers()
    }
}

// MARK: - Service

private extension RoutesViewModel {
    func fetchRoute(with id: UUID) {
        let route = storage.getRoute(with: id)
        state = state.addRoute(route, localizer: localizer)
    }
}

// MARK: - Observers

private extension RoutesViewModel {
    func setupObservers() {
        didReceiveSavedRouteId
            .receive(on: DispatchQueue.main)
            .sink(weak: self) { this, id in
                this.fetchRoute(with: id)
            }
            .store(in: &cancellables)
        
        didReceiveRemovedRouteId
            .receive(on: DispatchQueue.main)
            .compactMap(weak: self) { this, id in
                this.state.removeRoute(with: id)
            }
            .assign(to: &$state)
    }
}
