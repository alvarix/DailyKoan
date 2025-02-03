import SwiftUI

struct ContentView: View {
    @State private var notificationsEnabled = false
    @State private var dailyKoan: String?

    var body: some View {
        VStack {
            Text("Daily Koan")
                .font(.largeTitle)
                .padding()

            if let koan = dailyKoan {
                Text(koan)
                    .font(.title2)
                    .padding()
            } else {
                Text("Loading Koan...")
                    .font(.title2)
                    .padding()
            }

            if !notificationsEnabled {
                Button("Enable Notification at 9AM") {
                    requestNotificationPermission()
                }
                .padding()
            }
        }
        .onAppear {
            checkNotificationStatus()
            loadDailyKoan()
        }
    }

    private func loadDailyKoan() {
        dailyKoan = NotificationManager.shared.getRandomKoanForMainScreen()
    }

    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    notificationsEnabled = true
                    NotificationManager.shared.scheduleDailyNotification()
                    print("✅ Notifications enabled and scheduled")
                } else {
                    print("❌ Notifications denied")
                }
            }
        }
    }

    private func checkNotificationStatus() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                notificationsEnabled = (settings.authorizationStatus == .authorized)
            }
        }
    }
}
