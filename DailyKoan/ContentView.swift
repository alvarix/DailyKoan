import SwiftUI

struct ContentView: View {
    @State private var dailyKoan: String?
    @State private var showSettings = false  // ✅ Track settings screen visibility

    var body: some View {
        VStack {
            Text("Daily Koan")
                .font(.largeTitle)
                .padding()

            if let koan = dailyKoan {
                Text(koan)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                Text("Loading Koan...")
                    .font(.title2)
                    .padding()
            }

            Spacer()  // ✅ Pushes the settings button to the bottom

            // ✅ Settings button at the bottom
            Button(action: {
                showSettings = true
            }) {
                Image(systemName: "gearshape")  // ⚙️ Settings icon
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
        .onAppear {
            loadDailyKoan()
            SoundManager.shared.playSound(named: "bell")  // ✅ Play bell sound on open
        }
    }

    private func loadDailyKoan() {
        dailyKoan = KoanManager.shared.getDailyKoan()
    }
}
