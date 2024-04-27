import SwiftUI
import SwiftData

@main
struct ThePerfectPairApp: App {
    @StateObject private var ingredientModelContainer = IngredientModelService()
    
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
