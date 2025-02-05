import Foundation

let koans: [String] = {
    if let url = Bundle.main.url(forResource: "koans", withExtension: "json"),
       let data = try? Data(contentsOf: url),
       let decoded = try? JSONDecoder().decode([String].self, from: data) {
        return decoded
    }
    return ["Reflect on nothingness."] // Fallback koan
}()