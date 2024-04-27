import Foundation
import SwiftData
import XCTest
@testable import ThePerfectPair

final class IngredientModelServiceTests: XCTestCase {
    var ingredientModelService: IngredientModelService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        ingredientModelService = IngredientModelService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ingredientModelService = nil
        super.tearDown()
    }
    
    // Test model container init and confirms categories are loaded from dict id2category
    func testModelContainerInitialization() throws {
        XCTAssertNotNil(ingredientModelService.container, "ModelContainer was not initialized, is nil.")
        let numCategories = 11
        let count = ingredientModelService.categories.count
        XCTAssertTrue(count == numCategories, "Incorrect number of IngredientCategory objects.")
    }
    
    // Confirms ingredients populate from test JSON
    @MainActor
    func testPopulateFromJSON() throws {
        let numIngredients = 568
        
        ingredientModelService.populateFromJSON(ingredientsFilename: "test_ingredient_data")
        if let count = ingredientModelService.ingredients?.count {
            XCTAssertTrue(count == numIngredients, "Incorrect number of Ingredient objects.")
        }
    }
}
