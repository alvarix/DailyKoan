import SwiftUI

struct ContentView: View {
    @State private var dailyKoan: String?
    @State private var showSettings = false  // Track settings screen visibility
    @Environment(\.scenePhase) private var scenePhase  // Monitor app lifecycle changes

    var body: some View {
        ScrollView {  // Enables pull-to-refresh gesture
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
                
                Spacer()  // Pushes the settings button to the bottom
                
                // Settings button at the bottom
                Button(action: {
                    showSettings = true
                }) {
                    Image(systemName: "gearshape")  // Settings icon
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding()
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView()
                }
            }
        }
        .refreshable {
            await refreshKoan()
        }
        .onAppear {
            loadDailyKoan()
            SoundManager.shared.playSound(named: "bell")  // Play bell sound on open
        }
        // When the app becomes active (e.g., after a notification tap), reload the koan
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                loadDailyKoan()
            }
        }
    }
    
    /**
     Loads the stored daily koan using the KoanManager.
     */
    private func loadDailyKoan() {
        dailyKoan = KoanManager.shared.getDailyKoan()
    }
    
    /**
     Refreshes the daily koan using a pull-to-refresh gesture.
     
     This method forces a new koan for the current day and updates the UI accordingly.
     */
    private func refreshKoan() async {
        let newKoan = KoanManager.shared.refreshDailyKoan()
        await MainActor.run {
            dailyKoan = newKoan
        }
    }
}
