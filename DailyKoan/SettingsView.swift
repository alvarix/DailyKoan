import SwiftUI

struct SettingsView: View {
    @State private var selectedTime = Date()
    @Environment(\.presentationMode) var presentationMode  // ✅ Used to close settings screen

    var body: some View {
        NavigationView {
            VStack {
                Text("Notification Settings")
                    .font(.largeTitle)
                    .padding()

                // ✅ Show current notification time
                Text("Current Notification Time:")
                    .font(.headline)
                    .padding(.top)

                Text(getFormattedNotificationTime())
                    .font(.title)
                    .bold()
                    .padding(.bottom)

                // ✅ Allow user to select a new time
                DatePicker("Change Notification Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .padding()

                Button("Save New Time") {
                    NotificationManager.shared.saveNotificationTime(selectedTime)
                    presentationMode.wrappedValue.dismiss()  // ✅ Close settings screen
                }
                .padding()
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
        }
    }

    /// ✅ Get formatted notification time from UserDefaults
    private func getFormattedNotificationTime() -> String {
        let hour = UserDefaults.standard.integer(forKey: "notificationHour")
        let minute = UserDefaults.standard.integer(forKey: "notificationMinute")

        // Default to 7:00 AM if no time is set
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"

        var dateComponents = DateComponents()
        dateComponents.hour = (hour > 0 || minute > 0) ? hour : 7
        dateComponents.minute = (hour > 0 || minute > 0) ? minute : 0

        let calendar = Calendar.current
        if let date = calendar.date(from: dateComponents) {
            return dateFormatter.string(from: date)
        }

        return "7:00 AM"  // Default fallback
    }
}
