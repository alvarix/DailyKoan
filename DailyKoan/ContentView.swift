import SwiftUI

struct ContentView: View {
    @State private var dailyKoan: String?
    @State private var isLoading = true
    @State private var showSettings = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationView {
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
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .toolbarBackground(.clear, for: .bottomBar) // Transparent bottom bar
        }
    }

    /**
     The main content of the app, displayed after loading.
     */
    private var mainContent: some View {
        GeometryReader { geometry in
            let isIpad = UIDevice.current.userInterfaceIdiom == .pad
            let maxWidth = isIpad ? geometry.size.width * 2 / 3 : geometry.size.width * 0.9

            VStack {
                Spacer()

                Text("Daily Koan")
                    .font(isIpad ? .system(size: 48, weight: .bold) : .largeTitle)
                    .padding(.top, 20)

                Text("swipe down to refresh")
                    .font(isIpad ? .title2.italic() : .footnote.italic())
                    .padding(.bottom, 10)

                if let koan = dailyKoan {
                    Text(koan)
                        .font(isIpad ? .system(size: 32) : .title2)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: maxWidth)
                        .padding()
                } else {
                    Text("No Koan Available")
                        .font(isIpad ? .system(size: 32) : .title2)
                        .padding()
                }

                Spacer()
            }
            .frame(maxWidth: maxWidth)
            .frame(maxHeight: .infinity)
            .multilineTextAlignment(.center)
            .padding(.horizontal, isIpad ? 20 : 0)
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
