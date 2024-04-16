import Foundation
import SwiftData

@Model
final class IngredientCategory: Decodable, PersistentModel {
    let name: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case name, id
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(Int.self, forKey: .id)
    }
}
