import Foundation
import SwiftData
import CoreML

class IngredientModelService: ObservableObject {
    @Published var container: ModelContainer!
    
    var ingredientModelActor: IngredientModelActor?
    var errors: [AppConfig.ErrorLog]?
    
    
    // MODEL TYPES
    enum ModelTypes {
        case ingredients, embeddings, categories
    }
    
    // Initializer
    init(isStoredInMemoryOnly: Bool = true) {
        let config = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        let schema = Schema([Ingredient.self, IngredientCategory.self, MLEmbedding.self])
        
        // Load the ModelContainer instance
        do {
            let modelContainer = try ModelContainer(for: schema, configurations: config)
            self.container = modelContainer
            let actor = IngredientModelActor(modelContainer: modelContainer)
            self.ingredientModelActor = actor
            // Add category models to container
            var categories = [IngredientCategory]()
            for (id, _) in id2IngredientCategory {
                do {
                    let category = try IngredientCategory(categoryId: id)
                    categories.append(category)
                } catch {
                    errors?.append(AppConfig.ErrorLog(error: error, code: 100))
                }
            }
        } catch {
            errors?.append(AppConfig.ErrorLog(error: error, code: 100))
        }
    }
    
    // Fill the ingredient and embedding models based on filename input
    func populateFromJSON(model: ModelTypes!, buildMode: AppConfig.BuildMode = .production) async throws {
        // Determine filepaths
        var ingredientFileName: String, embeddingsFileName: String = ""
        switch buildMode {
        case .production:
            ingredientFileName = AppConfig.JSONFileNames.Production.ingredientFileName.rawValue
            embeddingsFileName = AppConfig.JSONFileNames.Production.ingredientFileName.rawValue
        case .debug:
            ingredientFileName = AppConfig.JSONFileNames.Debug.ingredientFileName.rawValue
            embeddingsFileName = AppConfig.JSONFileNames.Debug.ingredientFileName.rawValue
        }
        
        // Read JSON to models
        switch model {
        case .ingredients:
            // Load ingredient_data.json
            var ingredients: [Ingredient]
            ingredients = try await JSONParser.parse(fileName: ingredientFileName)
            for ingredient in ingredients {
                try await ingredientModelActor?.insert(ingredient)
            }
        case .embeddings:
            // Load embedding_data.json
            var embeddings: [MLEmbedding]
            let featureKeys = (1...300).map { String($0) }
            embeddings = try await JSONParser.parse(fileName: embeddingsFileName, dynamicKeys: featureKeys)
            for embedding in embeddings {
                try await ingredientModelActor?.insert(embedding)
            }
        case .categories:
            throw NSError(domain: "IngredientModelService", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Categories are pre-defined, nothing to import from JSON."])
        case .none:
            throw NSError(domain: "IngredientModelService", code: 1002, userInfo: [NSLocalizedDescriptionKey: "No ModelType has been specified to populate from JSON."])
        }
    }
}

@ModelActor
actor IngredientModelActor {
    // Insert a new model instance into the container
    func insert<T: PersistentModel>(_ model: T) throws {
        modelContext.insert(model)
        try modelContext.save()
    }
    
    func unwrapModel<T>(_ modelArray: [T]) throws -> T {
        let count = modelArray.count
        if count > 1 {
            throw NSError(domain: "IngredientModelActor", code: 1001, userInfo: [NSLocalizedDescriptionKey: "More than one value to unpack in fetched model array."])
        } else if count < 1 {
            throw NSError(domain: "IngredientModelActor", code: 1002, userInfo: [NSLocalizedDescriptionKey: "No models were in the array provided."])
        } else {
            let model = modelArray[0]
            return model
        }
    }

}
