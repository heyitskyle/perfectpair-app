import Foundation
import CoreML

class IngredientPairingModel: PairModel {
    func prediction(embeddings: MLMultiArray, ingredient_id: Int) throws -> PairModelOutput {
        
        let input_ = PairModelInput(embeddings: embeddings, selected_embeddings: selected_embeddings)
        return try self.prediction(input: input_)
    }
}
