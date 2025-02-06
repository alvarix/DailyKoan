import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func scheduleDailyNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Daily Koan"
        content.body = KoanManager.shared.getDailyKoan()
        content.sound = .default

        // Get stored notification time, default to 7 AM
        let hour = UserDefaults.standard.integer(forKey: "notificationHour")
        let minute = UserDefaults.standard.integer(forKey: "notificationMinute")

        var dateComponents = DateComponents()
        dateComponents.hour = (hour > 0 || minute > 0) ? hour : 7  // ✅ Default to 7 AM
        dateComponents.minute = (hour > 0 || minute > 0) ? minute : 0  // ✅ Default to 0 minutes

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyKoan", content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error)")
            } else {
                print("✅ Notification scheduled at \(dateComponents.hour ?? 7):\(dateComponents.minute ?? 0)")
            }
        }
    }

    /// ✅ Save the user's preferred notification time and reschedule
    func saveNotificationTime(_ date: Date) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        UserDefaults.standard.set(components.hour, forKey: "notificationHour")
        UserDefaults.standard.set(components.minute, forKey: "notificationMinute")
        UserDefaults.standard.set(true, forKey: "hasSetNotificationTime")
        UserDefaults.standard.synchronize()

        print("✅ Notification time saved: \(components.hour ?? 7):\(components.minute ?? 0)")

        scheduleDailyNotification()  // ✅ Reschedule with new time
    }
}
