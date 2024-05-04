import Foundation
import SwiftData
import CoreML

@Model
final class MLEmbedding: Decodable {
    let features: [Float]
    @Relationship(inverse: \Ingredient.ingredientID)
    let ingredientID: Int
    
    enum CodingKeys: String, CodingKey {
        case ingredient_id
    }
    
    private struct FeatureKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = Int(stringValue)
        }
        
        init?(intValue: Int) {
            self.stringValue = String(intValue)
            self.intValue = intValue
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Add ingredient id
        self.ingredientID = try container.decode(Int.self, forKey: .ingredient_id)
        
        // Check for feature keys
        guard let featureKeys = decoder.userInfo[CodingUserInfoKey(rawValue: "dynamicKeys")!] as? [String] else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Feature keys are missing in decoder userInfo"))
        }

        // Add features (dimensionality of the features is determined by passing dynamic keys to the JSONParser)
        let featureContainer = try decoder.container(keyedBy: FeatureKeys.self)
        self.features = try featureKeys.map { keyString in
            guard let key = FeatureKeys(stringValue: keyString) else {
                throw DecodingError.keyNotFound(FeatureKeys(stringValue: keyString)!,
                                               DecodingError.Context(codingPath: [], debugDescription: "Key not found: \(keyString)"))
            }
            return try featureContainer.decode(Float.self, forKey: key)
        }
    }
}

//        guard let multiArray = try? MLMultiArray(shape: [300], dataType: .float32) else { return nil }
