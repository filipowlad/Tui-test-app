//
//  StorageService.swift
//  Test app
//
//  Created by Vladyslav Filipov on 29.01.2024.
//

import Foundation

public protocol StorageService {
    func save(route: StorageRoute)
    func remove(route: StorageRoute)
    func getRoute(with id: UUID) -> StorageRoute?
    func getRoutes() -> [StorageRoute]
}
