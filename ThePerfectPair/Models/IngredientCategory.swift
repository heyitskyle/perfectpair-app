import Foundation
import SwiftData

@Model final class IngredientCategory: Decodable {
    @Attribute(.unique) let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name, id
    }
    
    init(name: String="", id: Int=0) {
        self.name = name
        self.id = id
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(Int.self, forKey: .id)
    }
}
