//
//  FeaturesProviding.swift
//  Test app
//
//  Created by Vladyslav Filipov on 28.01.2024.
//

import Features
import Foundation

@MainActor public protocol FeaturesProviding {
    associatedtype Routes: RoutesProviding where Routes.FeatureCoordinator.Result == Void
    var routes: Routes { get }
    
    associatedtype Route: RouteProviding where Route.FeatureCoordinator.Result == UUID
    var route: Route { get }
    
    associatedtype AddNewRoute: AddNewRouteProviding where AddNewRoute.FeatureCoordinator.Result == UUID
    var addNewRoute: AddNewRoute { get }
}
