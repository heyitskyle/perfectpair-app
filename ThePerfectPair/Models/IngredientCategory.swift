import Foundation
import SwiftData

let id2IngredientCategory = [
    0:   "uncategorized",
    101: "bakery_and_desserts",
    102: "beverages",
    103: "grains_and_legumes",
    104: "dairy",
    105: "fruits",
    106: "meat_and_seafood",
    107: "vegetables",
    108: "spices_and_seasonings",
    109: "fats_and_oils",
    999: "miscellaneous"
]

@Model
final class IngredientCategory {
    @Attribute(.unique)
    let categoryId: Int
    let name: String
    let ingredients: [Ingredient]?
    
    enum CodingKeys: String, CodingKey {
        case name, categoryId
    }
    
    init(categoryId: Int) throws {
        if let unwrappedName = id2IngredientCategory[categoryId] {
            self.categoryId = categoryId
            self.name = unwrappedName
        } else {
            throw InitializationError.invalidCategoryId
        }
    }
}
