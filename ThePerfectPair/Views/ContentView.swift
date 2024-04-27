import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var ingredientModelContainer: IngredientModelService
    
    var body: some View {
        IngredientSelectionView()
    }
}

//#Preview {
//    let ingredientModelService = IngredientModelService()
//    ingredientModelService.populateFromJSON(ingredientsFilename: "test_ingredient_data")
//    return ContentView()
//        .modelContainer(ingredientModelService.container)
//}
