//
//  Provider.swift
//  Test app
//
//  Created by Vladyslav Filipov on 28.01.2024.
//

import Facade

final class Provider<Navigator: Navigating>: Providing {
    let navigator: Navigator
    
    lazy var features: some FeaturesProviding = FeaturesProvider(provider: self)
    lazy var services: some ServicesProviding = ServicesProvider(provider: self)
    
    init(navigator: Navigator) {
        self.navigator = navigator
    }
}
