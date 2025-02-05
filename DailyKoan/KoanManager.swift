import Foundation

class KoanManager {
    static let shared = KoanManager()
    
    private let koanKey = "dailyKoan"
    private let lastUpdatedKey = "lastUpdated"

    /// Returns the same koan for the entire day
    func getDailyKoan() -> String {
        let today = Calendar.current.startOfDay(for: Date())
        let lastUpdated = UserDefaults.standard.object(forKey: lastUpdatedKey) as? Date ?? Date.distantPast

        if lastUpdated < today {
            let newKoan = koans.randomElement() ?? "Reflect on nothingness."
            UserDefaults.standard.set(newKoan, forKey: koanKey)
            UserDefaults.standard.set(today, forKey: lastUpdatedKey)
            return newKoan
        }

        return UserDefaults.standard.string(forKey: koanKey) ?? "Reflect on nothingness."
    }
}