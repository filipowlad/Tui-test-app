//
//  AddNewRouteProviding.swift
//  Test app
//
//  Created by Vladyslav Filipov on 29.01.2024.
//

public protocol AddNewRouteProviding: FeatureProviding {
    func coordinator() -> FeatureCoordinator
}
