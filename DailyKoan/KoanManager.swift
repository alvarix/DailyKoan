import Foundation

class KoanManager {
    static let shared = KoanManager()
    
    /**
     Returns a new random koan.
     
     - Returns: A random koan string from the available list.
     */
    func getDailyKoan() -> String {
        let newKoan = koans.randomElement() ?? "⚠️ No koan found!"
        print("🔄 New koan selected: \(newKoan)")
        return newKoan
    }
}
