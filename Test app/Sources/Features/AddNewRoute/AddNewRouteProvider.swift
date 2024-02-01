//
//  AddNewRouteProvider.swift
//  Test app
//
//  Created by Vladyslav Filipov on 28.01.2024.
//

import Facade
import Features

final class AddNewRouteProvider<Provider: Providing>: AddNewRouteProviding {
    typealias FeatureCoordinator = AddNewRouteCoordinator<Provider>
    
    private let provider: Provider
    
    init(provider: Provider) {
        self.provider = provider
    }
    
    func coordinator() -> FeatureCoordinator {
        .init(provider: provider)
    }
}
