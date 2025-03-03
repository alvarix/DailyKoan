import Foundation

class KoanManager {
    static let shared = KoanManager()
    
    /**
     Returns the daily koan based on the current calendar day.
     
     If a koan has already been set for today's date (based on the user's locale),
     this method returns the stored koan. Otherwise, it selects a new random koan,
     saves it along with today’s date, and then returns it.
     
     - Returns: A daily koan string.
     */
    func getDailyKoan() -> String {
        let defaults = UserDefaults.standard
        let today = Date()
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: today)
        
        // Format the date to a string ("yyyy-MM-dd") for localization purposes.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: startOfToday)
        
        // Return the stored koan if it exists for today.
        if let storedDate = defaults.string(forKey: "dailyKoanDate"),
           let storedKoan = defaults.string(forKey: "dailyKoan"),
           storedDate == todayString {
            return storedKoan
        }
        
        // Generate a new koan, store it along with today's date, and return it.
        let newKoan = koans.randomElement() ?? "⚠️ No koan found!"
        defaults.set(todayString, forKey: "dailyKoanDate")
        defaults.set(newKoan, forKey: "dailyKoan")
        print("🔄 New koan selected for \(todayString): \(newKoan)")
        return newKoan
    }
}
