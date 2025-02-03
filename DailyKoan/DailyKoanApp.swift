import SwiftUI

@main
struct DailyKoanApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // Handle notifications
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
