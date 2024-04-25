import Foundation
import SwiftData

@Model final class MLEmbedding: Decodable {
    @Attribute(.unique) let ingredientId: Int
    let embedding: [Double]
    
    enum CodingKeys: String, CodingKey {
        case ingredient_id, embedding
    }
    
    init(embedding: [Double]=[], ingredientId: Int=0) {
        self.embedding = embedding
        self.ingredientId = ingredientId
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.embedding = try container.decode([Double].self, forKey: .embedding)
        self.ingredientId = try container.decode(Int.self, forKey: .ingredient_id)
    }
}
