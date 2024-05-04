import SwiftUI
import SwiftData

@main
struct ThePerfectPairApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(buildMode: .production)
                .environmentObject(IngredientModelService())
                .environmentObject(IngredientPairingModel())
        }
    }
}
