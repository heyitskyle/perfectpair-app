import SwiftUI
import SwiftData

struct IngredientSelectionView: View {
//    @EnvironmentObject var ingredientModelContainer: IngredientModelContainer
    @Query(sort: \Ingredient.formattedName) var ingredients: [Ingredient]
    
    let searchablePrompt = "Search over 6,000 ingredients…"
    
    @State private var searchbarText = ""
    @State private var displayWelcomeView = false
    
    var body: some View {
        NavigationSplitView {
            if displayWelcomeView {
                WelcomeView()
            } else {
                List {
                    ForEach(ingredients) { ingredient in
                        VStack(alignment: .leading, content: {
                            Text(ingredient.name)
                        })
                    }
                }
            }
        } detail: {
            Text("detail")
        }
        .searchable(text: $searchbarText, placement: .sidebar, prompt: searchablePrompt)
    }
}

#Preview {
    let ingredientModelService = IngredientModelService()
    ingredientModelService.populateFromJSON(ingredientsFilename: "test_ingredient_data")
    return IngredientSelectionView()
        .modelContainer(ingredientModelService.container)
}
