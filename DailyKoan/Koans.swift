import Foundation

let koans: [String] = {
    if let resourcePath = Bundle.main.resourcePath {
        print("📂 App Bundle Path: \(resourcePath)")
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
            print("📁 Bundle Contents: \(files)")
        } catch {
            print("❌ Error listing bundle contents: \(error)")
        }
    }

    guard let url = Bundle.main.url(forResource: "koans", withExtension: "json") else {
        print("❌ Could not find koans.json in bundle.")
        return ["Reflect on nothingness."] // Fallback koan
    }

    do {
        let data = try Data(contentsOf: url)
        let decodedKoans = try JSONDecoder().decode([String].self, from: data)
        return decodedKoans
    } catch {
        print("❌ Error loading koans.json: \(error)")
        return ["Reflect on nothingness."] // Fallback koan
    }
}()
