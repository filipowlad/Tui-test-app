//
//  Test_appApp.swift
//  Test app
//
//  Created by Vladyslav Filipov on 27.01.2024.
//

import SwiftUI

@main
struct TestApp: App {
    @ObservedObject private var navigator: Navigator
    
    private let provider: Provider<Navigator>
    private let appCoordinnator: AppCoordinator<Provider<Navigator>>
    
    init() {
        let navigator: Navigator = .init()
        let provider: Provider<Navigator> = .init(navigator: navigator)
        self.navigator = navigator
        self.provider = provider
        self.appCoordinnator = .init(provider: provider)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigator.navigationPath) {
                rootView
            }
            .preferredColorScheme(.light)
        }
    }
}

private extension TestApp {
    var rootView: some View {
        appCoordinnator.view
    }
}
