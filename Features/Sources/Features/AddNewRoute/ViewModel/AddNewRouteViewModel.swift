//
//  AddNewRouteViewModel.swift
//  Test app
//
//  Created by Vladyslav Filipov on 27.01.2024.
//

import API
import Combine
import Foundation
import _MapKit_SwiftUI

@MainActor public final class AddNewRouteViewModel<
    Localizer: AddNewRouteLocalizing,
    Connections: ConnectionsService,
    Storage: StorageService
>: ObservableObject {
    typealias ViewState = AddNewRouteViewState
    
    // MARK: - Dependencies
    
    private let localizer: Localizer
    private let connectionsService: Connections
    private let storageService: Storage
    
    // MARK: - Coordination result
    
    let savedRouteWithId: PassthroughSubject<UUID, Never> = .init()
    public private(set) lazy var shouldClose: AnyPublisher<UUID, Never> = savedRouteWithId.eraseToAnyPublisher()

    @Published var state: ViewState
    
    public init(
        localizer: Localizer,
        connectionsService: Connections,
        storageService: Storage
    ) {
        self.localizer = localizer
        self.connectionsService = connectionsService
        self.storageService = storageService
        self.state = .initial(localizer: localizer)
    }
    
    func initialFetch() async {
        await fetchConnections()
    }
}

// MARK: - Actions

extension AddNewRouteViewModel {
    func saveRoute() {
        guard let route = state.routeItem?.route else { return }
        
        storageService.save(
            route: .init(
                id: route.id,
                startLocation: route.startLocation,
                destinationLocation: route.destinationLocationItem.location,
                passThroughLocations: route.passThroughLocations,
                price: route.price,
                creationDate: .init()
            )
        )
        
        savedRouteWithId.send(route.id)
    }
    
    func updateStartLocationText(_ text: String) {
        state = state.update(startLocationText: text)
    }
    
    func updateDestinationLocationText(_ text: String) {
        state = state.update(destinationLocationText: text)
    }
    
    func updateStartLocation(with id: UUID?) {
        state = state.updateStartLocation(with: id, localizer: localizer)
    }
    
    func updateDestinationLocation(with id: UUID?) {
        state = state.updateDestinationLocation(with: id, localizer: localizer)
    }
    
    func updateStartLocationError(with pickerFocusState: Bool) {
        state = state.updateStartLocationError(with: pickerFocusState)
    }
    
    func updateDestinationLocationError(with pickerFocusState: Bool) {
        state = state.updateDestinationLocationError(with: pickerFocusState)
    }
}

// MARK: - Connections

private extension AddNewRouteViewModel {
    func fetchConnections() async {
        do {
            state = state.update(fetchState: .loading)
            let connections = try await connectionsService.fetchConnections()
            state = state.update(connections: connections)
        } catch {
            state = state.update(fetchState: .error)
        }
    }
}
