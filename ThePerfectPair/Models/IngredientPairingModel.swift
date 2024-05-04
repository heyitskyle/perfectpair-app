import Foundation
import CoreML

class IngredientPairingModel: ObservableObject {
    @Published var pairModel: PairModel?
    @Published var ingredientEmbeddings: MLMultiArray?
    @Published var ingredientIDs: [Int]?
    
    var errors: [AppConfig.ErrorLog]?
    
    init() {
        do {
            pairModel = try PairModel()
        } catch {
            errors?.append(AppConfig.ErrorLog(error: error, code: 100))
        }
    }
    
    func loadEmbeddings(ingredientEmbeddings: [[Float]], ingredientIDs: [Int]) async throws {
        // Pass IDs on init
        self.ingredientIDs = ingredientIDs
        
        // Define multiarray size
        let count = ingredientEmbeddings.count
        let multiArray = try MLMultiArray(shape: [count, 300] as [NSNumber], dataType: .float32)
        // Fill multi array with embedding values
        for (index, embedding) in ingredientEmbeddings.enumerated() {
            let baseIndex = index * 300
            for (offset, value) in embedding.enumerated() {
                multiArray[baseIndex + offset] = NSNumber(value: value)
            }
        }
        self.ingredientEmbeddings = multiArray
    }
    
    func prediction(selectedEmbeddings: [Float]) throws -> [Float] {
        // Define selectedMultiArray size
        let selectedMultiArray = try MLMultiArray(shape: [300], dataType: .float32)
        
        // Fill selectedMultiArray with selectedEmbeddings
        for (index, value) in selectedEmbeddings.enumerated() {
            selectedMultiArray[index] = NSNumber(value: value)
        }
        
        // Call parent class's prediction, get result values for similarity scores
        guard let safeIngredientEmbeddings = ingredientEmbeddings else {
            throw NSError(domain: "IngredientPairingModel", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Encountered nil value in ingredient embeddings."])
        }
        guard let safePairModel = pairModel else {
            throw NSError(domain: "IngredientPairingModel", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Encountered nil pairModel instance."])
        }
        let similarityScores = try safePairModel.prediction(embeddings: safeIngredientEmbeddings, selected_embeddings: selectedMultiArray).similarity_scores
        
        // Convert scores from MLMultiArray to [Float]
        var similarityScoresArray = [Float]()
        for i in 0..<similarityScores.count {
            similarityScoresArray.append(Float(truncating: similarityScores[i]))
        }
        
        return similarityScoresArray
    }
}
