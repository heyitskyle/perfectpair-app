//
//  IngredientDataServiceTests.swift
//  ThePerfectPairTests
//
//  Created by Kyle Lehmann on 4/17/24.
//

import XCTest
@testable import ThePerfectPair

final class IngredientDataServiceTests: XCTestCase {
    var ingredientService: IngredientDataService!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        ingredientService = IngredientDataService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ingredientService = nil
        super.tearDown()
    }

    func testInit() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        XCTAssertNotNil(ingredientService, "IngredientDataService not initialized")
    }

}
