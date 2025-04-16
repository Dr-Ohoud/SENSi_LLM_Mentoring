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
    
    // Request permission
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ Notification permission error: \(error.localizedDescription)")
            } else {
                print(granted ? "Notification permission granted" : "Notification permission denied")
            }
        }
    }
    
    func scheduleNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
        //Time
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 45.0, repeats: false)
        
//        //Calender
//        var dateComponents = DateComponents()
//        dateComponents.hour = 16
//        dateComponents.minute = 10
//        dateComponents.weekday = 5
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled in seconds")
            }
        }
    }
}
