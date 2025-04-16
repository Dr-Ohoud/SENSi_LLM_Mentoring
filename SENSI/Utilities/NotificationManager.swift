//
//  NotificationManager.swift
//  SENSI
//
//  Created by Shahad Bagarish on 13/04/2025.
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    // ✅ Request permission
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ Notification permission error: \(error.localizedDescription)")
            } else {
                print(granted ? "✅ Notification permission granted" : "❌ Notification permission denied")
            }
        }
    }
    
    // ✅ Schedule a simple local notification
    func scheduleNotification(title: String, body: String, after seconds: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("✅ Notification scheduled in \(Int(seconds)) seconds")
            }
        }
    }
}
