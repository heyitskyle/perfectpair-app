import Foundation
import SwiftData

class IngredientModelContainer: ObservableObject {
    @Published var container: ModelContainer!
    
    var ingredients: [Ingredient]?
    var categories: [IngredientCategory]?
    var embeddings: [MLEmbedding]?
    
    // Initilizer
    //   - isPersistent: True if instance is storage bound (production), or false if memory only (testing)
    init(isStoredInMemoryOnly: Bool = true, allowsSave: Bool = true) {
        let config = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly, allowsSave: allowsSave)
        let schema = Schema([Ingredient.self, IngredientCategory.self, MLEmbedding.self])
        // Load the ModelContainer instance
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            print("Unhandled error initializing model container: \(error)")
        }
    }
    
    func populateFromJSON(ingredientsFilename: String="ingredient_data", categoriesFilename: String="category2id", embeddingsFilename: String="embedding_data") async {
        // Load ingredient_data.json
        do {
            self.ingredients = try JSONParser.parse(fromFile: ingredientsFilename)
            print("Ingredients loaded successfully.")
        } catch {
            print("Failed to parse ingredients: \(error)")
        }
        
        // Load category2id.json
        do {
            self.categories = try JSONParser.parse(fromFile: categoriesFilename)
            print("Categories loaded successfully.")
        } catch {
            print("Failed to parse categories: \(error)")
        }
        
        
        // Load embedding_data.json
        do {
            self.embeddings = try JSONParser.parse(fromFile: embeddingsFilename)
            print("Embeddings loaded successfully.")
        } catch {
            print("Failed to parse embeddings: \(error)")
        }
                                                                                                                                       
        // Add data to container
        await MainActor.run {
            // Add ingredients to container
            if let unwrappedIngredients = ingredients {
                for ingredient in unwrappedIngredients {
                    container.mainContext.insert(ingredient)
                }
            }
            // Add ingredient categories to container
            if let unwrappedCategories = categories {
                for category in unwrappedCategories {
                    container.mainContext.insert(category)
                }
            }
            // Add embeddings to container
            if let unwrappedEmbeddings = embeddings {
                for embedding in unwrappedEmbeddings {
                    container.mainContext.insert(embedding)
                }
            }
        }
        
    }
}

