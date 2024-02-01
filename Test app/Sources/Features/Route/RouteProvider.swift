//
//  RouteProvider.swift
//  Test app
//
//  Created by Vladyslav Filipov on 28.01.2024.
//

import Facade
import Features

final class RouteProvider<Provider: Providing>: RouteProviding {
    typealias FeatureCoordinator = RouteCoordinator<Provider>
    
    private let provider: Provider
    
    init(provider: Provider) {
        self.provider = provider
    }
    
    func coordinator(with viewData: RouteViewData) -> FeatureCoordinator {
        .init(
            provider: provider,
            viewData: viewData
        )
    }
}
