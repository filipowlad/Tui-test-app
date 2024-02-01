//
//  Then.swift
//  Test app
//
//  Created by Vladyslav Filipov on 28.01.2024.
//

public protocol Then {}

public extension Then where Self: Any {
    func with(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }
}

public extension Then where Self: AnyObject {
    func then(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}
