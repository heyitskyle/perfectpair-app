import Foundation
import SwiftData

class IngredientModelContainer {
    private var container: ModelContainer?
    let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: false, allowsSave: true)

    init() {
        let schema = Schema([Ingredient.self, IngredientCategory.self, MLEmbedding.self])
        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
                print("Error creating model container: \(error)")
        }
    }

    private func readJsonData<T: Decodable>(from filename: String, modelType: T.Type) async -> [T] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
            print("Error loading data from file: \(filename)")
            return []
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([T].self, from: data)
        } catch {
            print("Error decoding data: \(error)")
            return []
        }
    }

    func createIngredientModels() async {
        let ingredients = await readJsonData(from: "ingredient_data", modelType: Ingredient.self)
        let categories = await readJsonData(from: "category2id", modelType: IngredientCategory.self)
        let embeddings = await readJsonData(from: "embedding_data", modelType: MLEmbedding.self)
        
        await MainActor.run {
            if let context = container?.mainContext {
                for ingredient in ingredients {
                    context.insert(ingredient)
                }
                for category in categories {
                    context.insert(category)
                }
                for embedding in embeddings {
                    context.insert(embedding)
                }
                
                do {
                    try context.save()
                } catch {
                    print("Error saving context: \(error)")
                }
            }
        }
    }
}
