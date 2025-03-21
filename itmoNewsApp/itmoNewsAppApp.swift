//
//  itmoNewsAppApp.swift
//  itmoNewsApp
//
//  Created by Уля on 21.03.2025.
//

import SwiftUI
import SwiftData

@main
struct itmoNewsAppApp: App {
    private let modelContainer = try! ModelContainer(for: NewsItem.self)
    let newsService = NewsService()

    var body: some Scene {
        WindowGroup {
            MainView(viewModel: .init(newsService, modelContainer: modelContainer))
        }
//        .modelContainer(sharedModelContainer)
    }
}
