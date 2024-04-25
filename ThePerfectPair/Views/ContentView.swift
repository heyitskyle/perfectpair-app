import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var ingredientModelContainer: IngredientModelContainer
    @State private var searchbarText = ""
    @State private var displayWelcomeView = true
    
    let searchablePrompt = "Search over 6,000 ingredients…"
    
    var body: some View {
        NavigationSplitView {
            if displayWelcomeView {
                WelcomeView()
            } else {
                IngredientListView()
            }
        } detail: {
            Text("detail")
        }
        .searchable(text: $searchbarText, placement: .sidebar, prompt: searchablePrompt)
    }
}

#Preview {
    let ingredientModelContainer = IngredientModelContainer()
    return ContentView()
        .modelContainer(ingredientModelContainer.container)
}
