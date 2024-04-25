import SwiftUI
import SwiftData

@main
struct ThePerfectPairApp: App {
    @StateObject private var ingredientModelContainer = IngredientModelContainer()
    
    init() {
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ingredientModelContainer)
                .task {}
        }
    }
}
