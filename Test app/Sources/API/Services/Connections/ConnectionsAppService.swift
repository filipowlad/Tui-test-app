//
//  LocationsAppService.swift
//  Test app
//
//  Created by Vladyslav Filipov on 28.01.2024.
//

import API
import Foundation

final class ConnectionsAppService: ConnectionsService {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let url: URL
    
    init(
        session: URLSession,
        decoder: JSONDecoder,
        url: URL
    ) {
        self.session = session
        self.decoder = decoder
        self.url = url
    }
    
    func fetchConnections() async throws -> [Connection] {
        let request = URLRequest(url: url)
        let data = try await session.data(for: request)
        
        return try decoder.decode(Connections.self, from: data.0).connections
    }
}
