import Foundation

struct AppConfig {
    enum BuildMode {
        case debug
        case production
    }
    
    enum States {
        case none, partial, running, blocked, complete
    }

    struct ErrorLog {
        let error: Error
        let code: Int
    }
    
    enum JSONFileNames {
        enum Production: String {
            case ingredientFileName = "ingredient_data"
            case embeddingFileName = "embedding_data"
        }
        enum Debug: String {
            case ingredientFileName = "test_ingredient_data"
            case embeddingFileName = "test_embedding_data"
        }
    }
}
