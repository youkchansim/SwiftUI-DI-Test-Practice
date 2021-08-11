//
//  DI_Test_PracticeApp.swift
//  DI-Test-Practice
//
//  Created by 육찬심 on 2021/08/10.
//

import SwiftUI
import Swinject

@main
struct DI_Test_PracticeApp: App {
    
    private let container = Container()
    
    init() {
        prepareContainer()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.container, container)
        }
    }
    
    private func prepareContainer() {
        container.register(Networking.self, factory: { _ in
            HTTPNetwork()
        })
        container.register(GitFetchable.self, factory: { r in
            GitFetcher(networking: r.resolve(Networking.self)!)
        })
    }
}

private struct ContainerKey: EnvironmentKey {

    static let defaultValue: Container = Container()
}

extension EnvironmentValues {
    
    var container: Container {
        get { self[ContainerKey.self] }
        set { self[ContainerKey.self] = newValue }
    }
}
