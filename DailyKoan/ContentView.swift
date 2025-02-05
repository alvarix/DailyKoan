import SwiftUI

struct ContentView: View {
    @State private var notificationsEnabled = false
    @State private var dailyKoan: String?
    @State private var showNotificationAlert = false
    @State private var selectedTime = Date()
    
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

            DatePicker("Notification Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .padding()

            Button("Save Time & Enable Notifications") {
                print("🛠 Button pressed - saving time")
                NotificationManager.shared.saveNotificationTime(selectedTime)
            }
            .padding()

            if !notificationsEnabled {
                Button("Enable Notification at 7AM") {
                    requestNotificationPermission()
                }
                .padding()
            }
        }
        .onAppear {
            checkNotificationStatus()
            loadDailyKoan()
        }

        .alert(isPresented: $showNotificationAlert) {  // 🔥 FIX: Attach to VStack
            Alert(
                title: Text("Notifications Disabled"),
                message: Text("To receive your daily koan notification, enable notifications in Settings."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func loadDailyKoan() {
        dailyKoan = KoanManager.shared.getDailyKoan()
    }

    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    notificationsEnabled = true
                    NotificationManager.shared.scheduleDailyNotification()
                } else {
                    notificationsEnabled = false
                    showNotificationAlert = true // Show alert if denied
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
