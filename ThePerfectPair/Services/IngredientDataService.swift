import Foundation
import SwiftData

class IngredientDataService {
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

    private func readJsonData<T: Decodable>(from filename: String, modelType: T.Type) async throws -> [T] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw NSError(domain: "DataLoadError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Failed to load data from file: \(filename)"])
        }
        let decoder = JSONDecoder()
        return try decoder.decode([T].self, from: data)
    }

    func createIngredientModels(ingredientsFilename: String, categoriesFilename: String, embeddingsFilename: String) async throws {
        let ingredients = try await readJsonData(from: ingredientsFilename, modelType: Ingredient.self)
        let categories = try await readJsonData(from: categoriesFilename, modelType: IngredientCategory.self)
        let embeddings = try await readJsonData(from: embeddingsFilename, modelType: MLEmbedding.self)
        
        try await MainActor.run {
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
                    throw error
                }
            }
        }
    }
}
