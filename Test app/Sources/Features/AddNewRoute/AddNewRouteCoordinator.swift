//
//  AddNewRouteCoordinator.swift
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

final class AddNewRouteCoordinator<Provider: Providing>: Coordinator {
    private let provider: Provider
    private var cancellables: [AnyCancellable] = []
    private let didReceiveResult: PassthroughSubject<UUID, Never> = .init()
    
    let id: UUID = .init()
    lazy var result: AnyPublisher<UUID, Never> = didReceiveResult.eraseToAnyPublisher()
    lazy var view: some View = makeView()
    
    init(provider: Provider) {
        self.provider = provider
    }
}

private extension AddNewRouteCoordinator {
    func makeView() -> some View {
        let viewModel = AddNewRouteViewModel(
            localizer: AddNewRouteLocalizer(),
            connectionsService: provider.services.connections,
            storageService: provider.services.storage
        )
        
        setupBindings(viewModel)
        
        return AddNewRouteView(viewModel: viewModel, styler: .init(loader: .init(style: .circular)))
            .navigationTitle(String(localized: "ADD_NEW_ROUTE_NAVIGATION_TITLE"))
            .navigationBarTitleDisplayMode(.inline)
    }
    
    func setupBindings(_ viewModel: AddNewRouteViewModel<some AddNewRouteLocalizing, some ConnectionsService, some StorageService>) {
        viewModel.shouldClose
            .subscribe(didReceiveResult)
            .store(in: &cancellables)
        
        viewModel.shouldClose
            .receive(on: DispatchQueue.main)
            .sink(weak: self) { this, _ in
                this.provider.navigator.pop()
            }
            .store(in: &cancellables)
    }
}

