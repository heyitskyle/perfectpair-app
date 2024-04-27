import Foundation
import SwiftData
import CoreML

class PairModelService: ObservableObject {
    @Published var pairModel: PairModel!
    
    @Published var embeddingContainer: ModelContainer!
    @Published var mlEmbeddings: [MLEmbedding]?
    
    init(isStoredInMemoryOnly: Bool = true) {
        let config = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        let schema = Schema([MLEmbedding.self])
        
        do {
            self.pairModel = try PairModel()
        } catch {
            print("Failure to load PairModel instance in PairModelService: \(error)")
        }
        do {
            self.embeddingContainer = try ModelContainer(for: schema, configurations: config)
        } catch {
            print("Failure to load ModelContainer in PairModelService: \(error)")
        }
    }
    
    func populateFromJSON(embeddingsFilename: String="embedding_data") async throws {
        // Load embedding_data.json
        do {
            self.mlEmbeddings = try JSONParser.parse(fromFile: embeddingsFilename)
            print("Embeddings loaded successfully.")
        } catch {
            print("Failed to parse embeddings: \(error)")
        }
        
        // Add ingredients to container
        let embeddingHandler = EmbeddingHandler(modelContainer: embeddingContainer)
        if let unwrappedMLEmbeddings = mlEmbeddings {
            for mlEmbedding in unwrappedMLEmbeddings {
                try await embeddingHandler.insert(mlEmbedding: mlEmbedding)
            }
        }
    }
    
    private func fetchAllEmbeddings() async throws -> MLMultiArray {
        // Get all embeddings
        if let countMLEmbeddings = mlEmbeddings?.count {
            // Initialize MultiArray
            guard let embeddingsMultiArray = try? MLMultiArray(shape: [NSNumber(value: countMLEmbeddings), 300], dataType: .float) else {
                throw NSError(domain: "PairModelService", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Failed to initialize embeddings MultiArray."])
            }
            // Unwrap optional MLEmbeddings
            guard let unwrappedMLEmbeddings = mlEmbeddings else {
                throw NSError(domain: "PairModelService", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Failed to unwrap optional MLEmbeddings array."])
            }
            // Iterate through features of each MLEmbedding
            for (mlEmbeddingIndex, embedding) in unwrappedMLEmbeddings.enumerated() {
                guard let embeddingsArray = embedding.embeddingsToMultiArray() else {
                    throw NSError(domain: "PairModelService", code: 1003, userInfo: [NSLocalizedDescriptionKey: "Failed to call embeddingsToMultiArray()."])
                }
                // Add features to MultiArray
                for featureIndex in 0..<300 {
                    embeddingsMultiArray[mlEmbeddingIndex * 300 + featureIndex] = embeddingsArray[featureIndex]
                }
            }
            return embeddingsMultiArray
        } else {
            throw NSError(domain: "PairModelService", code: 1004, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch count of MLEmbeddings."])
        }
    }
    
//    private func processPairModelOuput(results: PairModelOutput) throws -> [Int: Float] {
//        let embeddings = results./*embeddings_by_similarity*/
//        let totalDimensions = 301
//        
//        for index in stride(from: 0, to: embeddings.count, by: totalDimensions) {
//                let similarityScore = embeddings[index + 300].floatValue
//                var featureArray = [Float]()
//
//                for featureIndex in 0..<300 {
//                    featureArray.append(embeddings[index + featureIndex].floatValue)
//                }
//
//                // Find ingredient ID that matches the features
////                if let ingredientId = findIngredientIdMatchingFeatures(featureArray) {
//                    outputDictionary[ingredientId] = similarityScore
//                }
//            }
//
//            return outputDictionary
//    }
//    
    func prediction(ingredientId: Int) async throws -> PairModelOutput {
        let embeddingHandler = EmbeddingHandler(modelContainer: embeddingContainer)
        
        // Get selected embedding as MultiArray with chosen ID
        let selectedEmbedding = try await embeddingHandler.fetchEmbedding(ingredientId: ingredientId)
        
        // Fetch all embeddings as MultiArray
        let embeddings = try await fetchAllEmbeddings()
        
        let results = try pairModel.prediction(embeddings: embeddings, selected_embeddings: selectedEmbedding)
        
        return results
    }
    
}

@ModelActor
actor EmbeddingHandler {
    func insert(mlEmbedding: MLEmbedding) throws {
        modelContext.insert(mlEmbedding)
        try modelContext.save()
    }
    func fetchEmbedding(ingredientId: Int) throws -> MLMultiArray {
        let fetchDescriptor = FetchDescriptor<MLEmbedding>(predicate: #Predicate { $0.ingredientId == ingredientId })
        let embeddingArray = try modelContext.fetch(fetchDescriptor)
        guard let embedding = embeddingArray.first else {
            throw NSError(domain: "PairModelService", code: 1006, userInfo: [NSLocalizedDescriptionKey: "Failed to unwrap MLEmbedding from [MLEmbedding]."])
        }
        guard let multiArray = embedding.embeddingsToMultiArray() else {
            throw NSError(domain: "PairModelService", code: 1007, userInfo: [NSLocalizedDescriptionKey: "Could not convert selected embedding to MultiArray"])
        }
        return multiArray
    }
//    func fetchIngredientID(features: [Float]) throws -> Int? {
////        let predicate = Predicate<MLEmbedding
//    }
}
