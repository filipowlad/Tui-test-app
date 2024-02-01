//
//  ServicesProvider.swift
//  Test app
//
//  Created by Vladyslav Filipov on 28.01.2024.
//

import API
import Facade
import Foundation

final class ServicesProvider<Provider: Providing>: ServicesProviding {
    private let provider: Provider
    
    private let encoder: JSONEncoder = .init()
    private let decoder: JSONDecoder = .init()
    private let session: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.default

        sessionConfiguration.requestCachePolicy = .reloadRevalidatingCacheData
        sessionConfiguration.urlCache = .init(memoryCapacity: 0, diskCapacity: 10 * 1024)

        return URLSession(configuration: sessionConfiguration)
    }()
    
    let config: Config
    lazy var connections: some ConnectionsService = ConnectionsAppService(session: session, decoder: decoder, url: config.connectionsUrl)
    lazy var storage: some StorageService = StorageAppService(encoder: encoder, decoder: decoder)
    
    init(provider: Provider) {
        self.provider = provider
        
        do {
            self.config = try .decodeJSON(
                for: Bundle.main.infoDictionary?["STATIC_CONFIG_TITLE"] as? String,
                in: .main
            )
        } catch {
            fatalError("Can not decode config with error: \(error)")
        }
    }
}

extension Config {
    static func decodeJSON(
        for resource: String?,
        in bundle: Bundle
    ) throws -> Config {
        guard let resource, let path = bundle.path(forResource: resource, ofType: "json") else {
            throw ConfigError.noResource
        }
        let jsonString = try String(contentsOfFile: path)
        guard let data = jsonString.data(using: .utf8) else {
            throw ConfigError.dataInvalid
        }

        return try JSONDecoder().decode(Config.self, from: data)
    }
    
    enum ConfigError: Error {
        case noResource
        case dataInvalid
    }
}
