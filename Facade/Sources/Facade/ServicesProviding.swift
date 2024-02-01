//
//  ServicesProviding.swift
//  Test app
//
//  Created by Vladyslav Filipov on 28.01.2024.
//

import API

public protocol ServicesProviding {
    var config: Config { get }
    
    associatedtype Connections: ConnectionsService
    var connections: Connections { get }
    
    associatedtype Storage: StorageService
    var storage: Storage { get }
}
