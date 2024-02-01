//
//  AddNewRouteLocalizing.swift
//
//
//  Created by Vladyslav Filipov on 31.01.2024.
//

public protocol AddNewRouteLocalizing {
    var startLocationPrompt: String { get }
    var destinationLocationPrompt: String { get }
    var saveButton: String { get }
    var loader: String { get }
    var goesThroughTitle: String { get }
    
    func price(_ price: Double) -> String
    func stopsTitle(numberOfPasthroughLocations: Int) -> String
}
