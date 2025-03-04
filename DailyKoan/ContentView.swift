import SwiftUI

struct ContentView: View {
    @State private var dailyKoan: String?
    @State private var showSettings = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Main scrollable content with pull-to-refresh.
                ScrollView {
                    VStack {
                        Text("Daily Koan")
                            .font(.largeTitle)
                            .padding(.top, 20)
                        
                        Text("swipe down to refresh")
                            .font(.footnote)
                            .italic()
                        
                        Spacer()
                        
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
                        
                        Spacer()
                    }
                    .frame(minHeight: geometry.size.height)
                }
                .refreshable {
                    await refreshKoan()
                }
                
                // Gear icon button pinned at the bottom.
                Button(action: {
                    showSettings = true
                }) {
                    Image(systemName: "gearshape")
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
                SoundManager.shared.playSound(named: "bell")
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    loadDailyKoan()
                }
            }
        }
    }
    
    /**
     Loads the stored daily koan from KoanManager.
     */
    private func loadDailyKoan() {
        dailyKoan = KoanManager.shared.getDailyKoan()
    }
    
    /**
     Refreshes the daily koan and updates the UI.
     */
    private func refreshKoan() async {
        let newKoan = KoanManager.shared.refreshDailyKoan()
        await MainActor.run {
            dailyKoan = newKoan
        }
    }
}
