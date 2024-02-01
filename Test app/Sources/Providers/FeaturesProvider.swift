//
//  FeaturesProvider.swift
//  Test app
//
//  Created by Vladyslav Filipov on 28.01.2024.
//

import Facade
import Features

final class FeaturesProvider<Provider: Providing>: FeaturesProviding {
    private let provider: Provider
    
    lazy var routes = RoutesProvider(provider: provider)
    lazy var route = RouteProvider(provider: provider)
    lazy var addNewRoute = AddNewRouteProvider(provider: provider)
    
    init(provider: Provider) {
        self.provider = provider
    }
}
