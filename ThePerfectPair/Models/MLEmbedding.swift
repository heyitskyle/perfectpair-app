import Foundation
import SwiftData
import CoreML

@Model
final class MLEmbedding: Decodable {
    @Attribute(.unique)
    let ingredientId: Int
    @Attribute(.unique)
    let features: [Float]
    
    enum CodingKeys: String, CodingKey {
        case ingredient_id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Add ingredient id
        self.ingredientId = try container.decode(Int.self, forKey: .ingredient_id)
        
        // Decode embeddings
        var tempEmbeddings = [Float]()
        for i in 1...300 {
            // Generate keys embedding_1 to embedding_300
            let keyString = "embedding_\(i)"
            if let key = CodingKeys(stringValue: keyString) {
                let value = try container.decode(Float.self, forKey: key)
                tempEmbeddings.append(value)
            } else {
                throw DecodingError.keyNotFound(CodingKeys(stringValue: keyString)!, DecodingError.Context(codingPath: [CodingKeys.ingredient_id], debugDescription: "Key \(keyString) not found."))
            }
        }
        self.features = tempEmbeddings
    }
    
    func embeddingsToMultiArray() -> MLMultiArray? {
        guard let multiArray = try? MLMultiArray(shape: [300], dataType: .float32) else { return nil }
        for (index, value) in features.enumerated() {
            multiArray[index] = NSNumber(value: value)
        }
        return multiArray
    }
}
