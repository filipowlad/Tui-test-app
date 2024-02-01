//
//  RouteProviding.swift
//  Test app
//
//  Created by Vladyslav Filipov on 29.01.2024.
//

public protocol RouteProviding: FeatureProviding {
    func coordinator(with viewData: RouteViewData) -> FeatureCoordinator
}
