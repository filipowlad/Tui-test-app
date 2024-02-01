//
//  Coordinator.swift
//  Test app
//
//  Created by Vladyslav Filipov on 29.01.2024.
//

import Combine
import SwiftUI

@MainActor public protocol Coordinator: Hashable, Identifiable {
    associatedtype Result
    associatedtype Content: View
    
    var id: UUID { get }
    var view: Content { get }
    var result: AnyPublisher<Result, Never> { get }
}

public extension Coordinator {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
