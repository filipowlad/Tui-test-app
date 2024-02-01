//
//  LocationsService.swift
//  Test app
//
//  Created by Vladyslav Filipov on 28.01.2024.
//

public protocol ConnectionsService {
    func fetchConnections() async throws -> [Connection]
}
