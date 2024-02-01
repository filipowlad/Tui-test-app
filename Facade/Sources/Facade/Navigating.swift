//
//  Navigating.swift
//  Test app
//
//  Created by Vladyslav Filipov on 27.01.2024.
//

import Features

public protocol Navigating {
    func push<Destination: Coordinator>(_ destination: Destination)
    func pop()
}
