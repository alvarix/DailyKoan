import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func scheduleDailyNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests() // Avoid duplicate notifications

        let content = UNMutableNotificationContent()
        content.title = "Daily Koan"
        content.body = KoanManager.shared.getDailyKoan()
        content.sound = .default

        // Get stored notification time
        let hour = UserDefaults.standard.integer(forKey: "notificationHour")
        let minute = UserDefaults.standard.integer(forKey: "notificationMinute")

        // Ensure default fallback time
        var dateComponents = DateComponents()
        dateComponents.hour = hour > 0 ? hour : 7
        dateComponents.minute = minute > 0 ? minute : 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyKoan", content: content, trigger: trigger)

        center.getPendingNotificationRequests { requests in
            for request in requests {
                print("⏰ Scheduled Notification: \(request.identifier), Trigger: \(request.trigger.debugDescription)")
            }
        }

        center.add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error)")
            } else {
                print("✅ Daily notification scheduled at \(dateComponents.hour ?? 7):\(dateComponents.minute ?? 0)")
            }
        }
    }

    /// Saves the user's preferred notification time and reschedules the notification.
    func saveNotificationTime(_ date: Date) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        // Ensure values are stored properly
        UserDefaults.standard.set(components.hour, forKey: "notificationHour")
        UserDefaults.standard.set(components.minute, forKey: "notificationMinute")
        UserDefaults.standard.synchronize()

        print("✅ Notification time saved: \(components.hour ?? 7):\(components.minute ?? 0)")

        // Reschedule the daily notification with the new time
        scheduleDailyNotification()
    }
}