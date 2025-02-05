import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func scheduleDailyNotification() {
        let center = UNUserNotificationCenter.current()

        // Remove existing notifications to avoid duplicates
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Daily Koan"
        content.body = KoanManager.shared.getDailyKoan()
        
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 7
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyKoan", content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error)")
            } else {
                print("✅ Daily notification scheduled at 7 AM")
            }
        }
    }

    /// Returns a random koan for notifications
    func getRandomKoanForNotifications() -> String {
        return koans.randomElement() ?? "Reflect on nothingness."
    }

    /// Returns a random koan for the main screen
    func getRandomKoanForMainScreen() -> String {
        return koans.randomElement() ?? "Reflect on nothingness."
    }
}
