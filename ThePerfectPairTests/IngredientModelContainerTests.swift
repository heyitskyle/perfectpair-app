import Foundation
import SwiftData
import XCTest
@testable import ThePerfectPair



final class IngredientModelContainerTests: XCTestCase {
    var ingredientModelContainer: IngredientModelContainer!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        ingredientModelContainer = IngredientModelContainer()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ingredientModelContainer = nil
        super.tearDown()
    }

    func testModelContainerInitialization() throws {
        XCTAssertNotNil(ingredientModelContainer.container, "ModelContainer was not initialized properly.")
    }
}
