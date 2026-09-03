//
//  Untitled.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 9/1/26.
//

import Foundation
import UserNotifications

enum Reminder {
    private static let identifier = "workoutReminder.daily"
    private static let lastReminderDateKey = "workoutReminder.lastDate"
    private static let dashboardBanner = "workoutReminder.dashboardBanner"
    
    static func scheduleLoginReminderIfNeeded() {
        let defaults = UserDefaults.standard
        
        if let lastDate = defaults.object(forKey: lastReminderDateKey) as? Date,
           Calendar.current.isDateInToday(lastDate) {
            return
        }
        defaults.set(Date(), forKey: lastReminderDateKey)
        scheduleReminder()
    }
    
    private static func scheduleReminder() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted,_ in
            guard granted else { return }
            
            let content = UNMutableNotificationContent()
            content.title = "Workout Reminder"
            content.body = "Time to go to the gym!"
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 60 * 4, repeats: false)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            center.removePendingNotificationRequests(withIdentifiers: [identifier])
            center.add(request)
        }
    }
    
    static func shouldShowBanner() -> Bool {
        let defaults = UserDefaults.standard
        
        if let lastShown = defaults.object(forKey: dashboardBanner) as? Date,
           Calendar.current.isDateInToday(lastShown) {
            return false
        }
        defaults.set(Date(), forKey: dashboardBanner)
        return true
    }
}
