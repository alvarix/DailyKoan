import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    requestNotificationPermission()
    NotificationManager.shared.scheduleDailyNotification() // Ensure it's scheduled
    return true
}

    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting permission: \(error)")
            } else if granted {
                print("Notification permission granted ✅")
            } else {
                print("User denied notifications ❌")
            }
        }
    }
}
