//
//  Navigator.swift
//  Test app
//
//  Created by Vladyslav Filipov on 27.01.2024.
//

import Facade
import Features
import SwiftUI

final class Navigator: ObservableObject, Navigating {
    @Published var navigationPath: NavigationPath = .init()
    
    func push<Destination: Coordinator>(_ destination: Destination) {
        navigationPath.append(destination)
    }
    
    func pop() {
        navigationPath.removeLast()
    }
}
