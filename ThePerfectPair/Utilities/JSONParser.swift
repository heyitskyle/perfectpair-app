import Foundation

struct JSONParser {
    static func parse<T: Decodable>(fromFile path: String, bundle: Bundle = .main) throws -> T {
        guard let jsonURL = bundle.url(forResource: path, withExtension: "json") else {
            throw NSError(domain: "JSONParserError", code: 404, userInfo: [NSLocalizedDescriptionKey: "File not found at \(path)."])
        }
        
        let data = try Data(contentsOf: jsonURL)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}
