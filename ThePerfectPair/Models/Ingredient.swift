import Foundation
import SwiftData

@Model
final class Ingredient: Decodable {
    @Attribute(.unique)
    let ingredientId: Int
    let name: String
    let formattedName: String
    
    let ingredientCategory: IngredientCategory
//    let embedding: MLEmbedding?
    
    enum CodingKeys: String, CodingKey {
        case ingredient_id, name, category_id, formatted_name
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.ingredientId = try container.decode(Int.self, forKey: .ingredient_id)
        self.name = try container.decode(String.self, forKey: .name)
        self.formattedName = try container.decode(String.self, forKey: .formatted_name)

        let categoryId = try container.decode(Int.self, forKey: .category_id)
        self.ingredientCategory = try IngredientCategory(categoryId: categoryId)
    }
}
