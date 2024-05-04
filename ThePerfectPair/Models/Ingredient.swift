import Foundation
import SwiftData

@Model
final class Ingredient: Decodable {
    let name: String
    let formattedName: String
    @Attribute(.unique)
    let ingredientID: Int
    @Relationship(inverse: \IngredientCategory.categoryID)
    let categoryID: Int
    
    enum CodingKeys: String, CodingKey {
        case ingredient_id, name, category_id, formatted_name
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.ingredientID = try container.decode(Int.self, forKey: .ingredient_id)
        self.name = try container.decode(String.self, forKey: .name)
        self.formattedName = try container.decode(String.self, forKey: .formatted_name)
        self.categoryID = try container.decode(Int.self, forKey: .category_id)
    }
    
}
