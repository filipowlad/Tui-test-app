//
//  Providing.swift
//  Test app
//
//  Created by Vladyslav Filipov on 28.01.2024.
//

public protocol Providing {
    associatedtype Navigator: Navigating
    var navigator: Navigator { get }
    
    associatedtype Features: FeaturesProviding
    @MainActor var features: Features { get }
    
    associatedtype Services: ServicesProviding
    var services: Services { get }
}
