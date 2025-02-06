import SwiftUI

struct ContentView: View {
    @State private var notificationsEnabled = false
    @State private var dailyKoan: String?
    @State private var showNotificationAlert = false
    @State private var selectedTime: Date = {
        // Default to 7 AM
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }()
    @State private var showConfirmationAlert = false
    @State private var showToast = false

    var body: some View {
        VStack {
            Text("Daily Koan")
                .font(.largeTitle)
                .padding()

            if let koan = dailyKoan {
                Text(koan)
                    .font(.title2)
                    .padding()
                    .multilineTextAlignment(.center)
            } else {
                Text("Loading Koan...")
                    .font(.title2)
                    .padding()
            }

            DatePicker("Notification Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .padding()

            Button("Save Time & Enable Notifications") {
                NotificationManager.shared.saveNotificationTime(selectedTime)
                showConfirmationAlert = true
                showToast = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showToast = false
                }
            }
            .padding()
            .alert(isPresented: $showConfirmationAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text("Notification time saved for \(formattedTime(selectedTime))"),
                    dismissButton: .default(Text("OK"))
                )
            }

            if !notificationsEnabled {
                Button("Enable Notification at 7 AM") {
                    requestNotificationPermission()
                }
                .padding()
            }
        }
        .onAppear {
            checkNotificationStatus()
            loadDailyKoan()
            //resetStoredKoan()
        }
        .overlay(
            showToast ? toastMessage() : nil,
            alignment: .bottom
        )
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
                    showNotificationAlert = true
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

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func toastMessage() -> some View {
        Text("✅ Notification time updated!")
            .padding()
            .background(Color.green.opacity(0.8))
            .cornerRadius(10)
            .foregroundColor(.white)
            .transition(.opacity)
            .padding(.bottom, 50)
    }
}
