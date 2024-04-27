import Foundation
import SwiftData
import XCTest
@testable import ThePerfectPair

final class PairModelServiceTests: XCTestCase {
    var pairModelService: PairModelService!
    var container: ModelContainer?
    let numIngredients = 568

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        pairModelService = PairModelService()
        container = pairModelService.embeddingContainer
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        pairModelService = nil
        container = nil
        super.tearDown()
    }

    // Test Pair Model init
    func testPairModelInitialization() throws {
        XCTAssertNotNil(pairModelService, "PairModel was not initialized, is nil.")
    }
    
    // Test model container init
    func testModelContainerInitialization() throws {
        XCTAssertNotNil(container, "ModelContainer was not initialized, is nil.")
    }
    
    // Confirm embeddings populate from JSON
    func testPopulateFromJSON() async throws {
        try await pairModelService.populateFromJSON(embeddingsFilename: "test_embedding_data")
        if let count = pairModelService.mlEmbeddings?.count {
            XCTAssertTrue(count == numIngredients)
        }
    }
}
