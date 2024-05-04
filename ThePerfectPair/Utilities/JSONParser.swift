import Foundation

struct JSONParser {
    static func parse<T: Decodable>(fileName path: String, bundle: Bundle = .main, dynamicKeys: [String]? = nil, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> [T] {
        guard let jsonURL = bundle.url(forResource: path, withExtension: "json") else {
            throw NSError(domain: "JSONParserError", code: 404, userInfo: [NSLocalizedDescriptionKey: "File not found at \(path)."])
        }

        let data = try Data(contentsOf: jsonURL)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
        if let keys = dynamicKeys {
            decoder.userInfo[CodingUserInfoKey(rawValue: "dynamicKeys")!] = keys
        }

        return try decoder.decode([T].self, from: data)
    }    
}

