//
//  CapstoneMDIApp.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/6/26.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct CapstoneMDIApp: App {
    
    private let notificationDelegate = NotificationDelegate()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            ExerciseLog.self,
            Routine.self,
            Exercise.self,
            Coach.self
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
    
    init() {
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
        .modelContainer(sharedModelContainer)
    }
}

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
