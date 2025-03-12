import SwiftUI

struct ContentView: View {
    @State private var dailyKoan: String?
    @State private var isLoading = true
    @State private var showSettings = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            if isLoading {
                LoadingScreen()
            } else {
                mainContent
            }
        }
        .onAppear {
            loadDailyKoan()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                loadDailyKoan()
            }
        }
    }

    /**
     The main content of the app, displayed after loading.
     */
    private var mainContent: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
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
                            Text("No Koan Available")
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
        }
    }

    /**
     Loads the stored daily koan with a loading state.
     */
    private func loadDailyKoan() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            dailyKoan = KoanManager.shared.getDailyKoan()
            isLoading = false
        }
    }

    /**
     Refreshes the daily koan with a loading state.
     */
    private func refreshKoan() async {
        isLoading = true
        let newKoan = KoanManager.shared.refreshDailyKoan()
        await MainActor.run {
            dailyKoan = newKoan
            isLoading = false
        }
    }
}
