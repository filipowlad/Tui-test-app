//
//  AppCoordinator.swift
//  Test app
//
//  Created by Vladyslav Filipov on 30.01.2024.
//

import Combine
import Facade
import Features
import Foundation
import SwiftUI

final class AppCoordinator<Provider: Providing>: Coordinator {
    private let provider: Provider
    private lazy var rootCoordinator: some Coordinator = provider.features.routes.coordinator()
    
    let id: UUID = .init()
    let result: AnyPublisher<Void, Never> = Empty(completeImmediately: false)
        .eraseToAnyPublisher()
    
    lazy var view: some View = rootCoordinator.view
    
    init(provider: Provider) {
        self.provider = provider
    }
}
