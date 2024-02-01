//
//  StorageAppService.swift
//  Test app
//
//  Created by Vladyslav Filipov on 29.01.2024.
//

import API
import Foundation

final class StorageAppService: StorageService {
    private let routesKey = "ALL_SAVED_ROUTES"
    
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(
        encoder: JSONEncoder,
        decoder: JSONDecoder
    ) {
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func save(route: StorageRoute) {
        var routes = getRoutes()
        routes.append(route)
        
        guard let data = try? encoder.encode(routes) else { return }
        
        UserDefaults.standard.set(data, forKey: routesKey)
    }
    
    func remove(route: StorageRoute) {
        var routes = getRoutes()
        routes.removeAll(where:  { $0 == route })
        
        guard let data = try? encoder.encode(routes) else { return }
        
        UserDefaults.standard.set(data, forKey: routesKey)
    }
    
    func getRoute(with id: UUID) -> StorageRoute? {
        let routes = getRoutes()
        return routes.first(where: { $0.id == id })
    }
    
    func getRoutes() -> [StorageRoute] {
        guard let data = UserDefaults.standard.data(forKey: routesKey) else { return [] }
        
        let routes = try? decoder.decode([StorageRoute].self, from: data)
        
        return routes ?? []
    }
}
