//
//  CapstoneMDIApp.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/6/26.
//

import SwiftUI
import SwiftData

@main
struct CapstoneMDIApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            ExerciseLog.self,
            Routine.self,
            Exercise.self
        ])
        do {
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            let context = container.mainContext
            
            return container
        }
        catch {
            fatalError("Error setting up database: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
        .modelContainer(sharedModelContainer)
    }
}
