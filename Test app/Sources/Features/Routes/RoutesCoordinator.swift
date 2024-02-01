//
//  RoutesCoordinator.swift
//  Test app
//
//  Created by Vladyslav Filipov on 29.01.2024.
//

import API
import Combine
import Facade
import Features
import Helpers
import SwiftUI

final class RoutesCoordinator<Provider: Providing>: Coordinator {
    private let provider: Provider
    private var cancellables: [AnyCancellable] = []
    
    let id: UUID = .init()
    lazy var result: AnyPublisher<Void, Never> = Empty(completeImmediately: false)
        .eraseToAnyPublisher()
    lazy var view: some View = makeView()
    
    init(provider: Provider) {
        self.provider = provider
    }
}

private extension RoutesCoordinator {
    func makeView() -> some View {
        let viewModel = RoutesViewModel(
            localizer: RoutesLocalizer(),
            storage: provider.services.storage
        )
        let view = RoutesView(
            viewModel: viewModel,
            styler: .init(backgroundImage: .init("routes", bundle: nil))
        )
        .navigationTitle(String(localized: "ROUTES_NAVIGATION_TITLE"))
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: AddNewRouteCoordinator<Provider>.self) { coordinator in
            coordinator.view
        }
        .navigationDestination(for: RouteCoordinator<Provider>.self) { coordinator in
            coordinator.view
        }
        
        setupObservers(viewModel)
        
        return view
    }
    
    func setupObservers(_ viewModel: RoutesViewModel<some RoutesLocalizing, some StorageService>) {
        viewModel.showAddNewRoute
            .flatMap(weak: self) { this, _ in
                this.coordinateToAddNewRoute()
            }
            .subscribe(viewModel.didReceiveSavedRouteId)
            .store(in: &cancellables)
        
        viewModel.showRoute
            .flatMap(weak: self) { this, viewData in
                this.coordinateToRoute(with: viewData)
            }
            .subscribe(viewModel.didReceiveRemovedRouteId)
            .store(in: &cancellables)
    }
}

private extension RoutesCoordinator {
    func coordinateToAddNewRoute() -> AnyPublisher<UUID, Never> {
        let coordinator = provider.features.addNewRoute.coordinator()
        
        provider.navigator.push(coordinator)
        
        return coordinator.result
    }
    
    func coordinateToRoute(with viewData: RouteViewData) -> AnyPublisher<UUID, Never> {
        let coordinator = provider.features.route.coordinator(with: viewData)
        
        provider.navigator.push(coordinator)
        
        return coordinator.result
    }
}
