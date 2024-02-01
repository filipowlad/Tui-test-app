//
//  RouteCoordinator.swift
//  Test app
//
//  Created by Vladyslav Filipov on 29.01.2024.
//

import API
import Combine
import Facade
import Features
import SwiftUI

final class RouteCoordinator<Provider: Providing>: Coordinator {
    private let provider: Provider
    private let viewData: RouteViewData
    private var cancellables: [AnyCancellable] = []
    private let didReceiveResult: PassthroughSubject<UUID, Never> = .init()
    
    let id: UUID = .init()
    lazy var result: AnyPublisher<UUID, Never> = didReceiveResult.eraseToAnyPublisher()
    
    lazy var view: some View = makeView()
    
    init(
        provider: Provider,
        viewData: RouteViewData
    ) {
        self.provider = provider
        self.viewData = viewData
    }
}

private extension RouteCoordinator {
    func makeView() -> some View {
        let viewModel = RouteViewModel(
            localizer: RouteLocalizer(),
            storageService: provider.services.storage,
            viewData: viewData
        )
        
        setupBindings(viewModel)
        
        return RouteView(viewModel: viewModel)
            .navigationTitle(String(localized: "ROUTE_NAVIGATION_TITLE"))
            .navigationBarTitleDisplayMode(.inline)
    }
    
    func setupBindings(_ viewModel: RouteViewModel<some RouteLocalizing, some StorageService>) {
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

