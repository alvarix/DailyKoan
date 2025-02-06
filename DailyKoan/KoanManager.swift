import Foundation

func resetStoredKoan() {
    UserDefaults.standard.removeObject(forKey: "dailyKoan")
    UserDefaults.standard.removeObject(forKey: "lastUpdated")
    print("🗑 Cleared stored koan from UserDefaults.")
}

class KoanManager {
    static let shared = KoanManager()
    
    private let koanKey = "dailyKoan"
    private let lastUpdatedKey = "lastUpdated"



    func getDailyKoan() -> String {
        let today = Calendar.current.startOfDay(for: Date())
        let lastUpdated = UserDefaults.standard.object(forKey: lastUpdatedKey) as? Date ?? Date.distantPast

        if lastUpdated < today {
            let newKoan = koans.randomElement() ?? "⚠️ No koan found!"
            
            // Store the new koan for today
            UserDefaults.standard.set(newKoan, forKey: koanKey)
            UserDefaults.standard.set(today, forKey: lastUpdatedKey)
            
            print("🔄 New koan selected: \(newKoan)")
            return newKoan
        }

        let savedKoan = UserDefaults.standard.string(forKey: koanKey) ?? "⚠️ No saved koan!"
        print("📌 Using saved koan: \(savedKoan)")
        return savedKoan
    }
}
