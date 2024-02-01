//
//  FeatureProviding.swift
//  Test app
//
//  Created by Vladyslav Filipov on 28.01.2024.
//

@MainActor public protocol FeatureProviding {
    associatedtype FeatureCoordinator: Coordinator
}
