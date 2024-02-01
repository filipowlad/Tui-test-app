//
//  RouteLocalizing.swift
//
//
//  Created by Vladyslav Filipov on 31.01.2024.
//

public protocol RouteLocalizing {
    var deleteButton: String { get }
    var goesThroughTitle: String { get }
    
    func price(_ price: Double) -> String
    func stopsTitle(numberOfPasthroughLocations: Int) -> String
}
