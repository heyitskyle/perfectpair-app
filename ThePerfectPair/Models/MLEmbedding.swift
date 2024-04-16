import Foundation
import SwiftData

@Model
final class MLEmbedding: Decodable, PersistentModel {
    let embedding: [Double]
    let ingredientId: Int
    
    enum CodingKeys: String, CodingKey {
        case ingredient_id, embedding
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.embedding = try container.decode([Double].self, forKey: .embedding)
        self.ingredientId = try container.decode(Int.self, forKey: .ingredient_id)
    }
}
