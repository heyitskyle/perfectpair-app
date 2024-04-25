import Foundation
import SwiftData

@Model final class Ingredient: Decodable {
    @Attribute(.unique) let id: Int
    let name: String
    let categoryId: Int
    let formattedName: String

    enum CodingKeys: String, CodingKey {
        case id, name, category_id, formatted_name
    }

    init(id: Int=0, name: String="", categoryId: Int=0, formattedName: String="") {
        self.id = id
        self.name = name
        self.categoryId = categoryId
        self.formattedName = formattedName
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.categoryId = try container.decode(Int.self, forKey: .category_id)
        self.formattedName = try container.decode(String.self, forKey: .formatted_name)
    }
}
