import Foundation
import SwiftData

class IngredientModelService: ObservableObject {
    @Published var container: ModelContainer!
    
    var ingredients: [Ingredient]?
    var categories: [IngredientCategory]
    
    // Initializer
    init(isStoredInMemoryOnly: Bool = true) {
        let config = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        let schema = Schema([Ingredient.self, IngredientCategory.self])
        
        // Load the ModelContainer instance
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            print("Unhandled error initializing model container: \(error)")
        }
        
        // Add category models to container
        self.categories = [IngredientCategory]()
        for (id, _) in id2IngredientCategory {
            do {
                let category = try IngredientCategory(categoryId: id)
                self.categories.append(category)
            } catch {
                print("Error adding category: \(error)")
            }
        }
    }
    
    @MainActor
    func populateFromJSON(ingredientsFilename: String="ingredient_data") {
        // Load ingredient_data.json
        do {
            self.ingredients = try JSONParser.parse(fromFile: ingredientsFilename)
            print("Ingredients loaded successfully.")
        } catch {
            print("Failed to parse ingredients: \(error)")
        }
        
        // Add ingredients to container
        if let unwrappedIngredients = ingredients {
            for ingredient in unwrappedIngredients {
                container.mainContext.insert(ingredient)
            }
        }
    }
}

