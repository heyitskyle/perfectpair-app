import XCTest
@testable import ThePerfectPair

final class PairModelServiceTests: XCTestCase {
    var pairModelService: PairModelService!
    
    var testIds = [917,1170,1225,1238,1460,1466,1561,2200,2359,3410,4329,4438,4804,5954,6368,6422]
    var testSelectedId = 4438
    var numResults = 5
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        pairModelService = PairModelService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        pairModelService = nil
        super.tearDown()
    }

    func testInit() throws {
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.

        // Check if the PairModelService was initialized
        XCTAssertNotNil(pairModelService, "pairModelService initializer returns nil.")
    }
    
    func testLoadEmbeddings() throws {
        // Testing load embeddings
//        pairModelService.loadEmbeddings(embeddingsArray: testEmbeddings, idsArray: testIds)
//        XCTAssertNil(pairModelService.lastSystemError, "An error occured while running loadEmbeddings")
    }
}
