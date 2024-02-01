//
//  RoutesProvider.swift
//  Test app
//
//  Created by Vladyslav Filipov on 28.01.2024.
//

import Facade
import Features

final class RoutesProvider<Provider: Providing>: RoutesProviding {
    typealias FeatureCoordinator = RoutesCoordinator<Provider>
    
    private let provider: Provider
    
    init(provider: Provider) {
        self.provider = provider
    }
    
    func coordinator() -> FeatureCoordinator {
        .init(provider: provider)
    }
}
