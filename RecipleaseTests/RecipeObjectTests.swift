//
//  RecipeObjectTests.swift
//  RecipleaseTests
//
//  Created by Mathieu Janneau on 02/02/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import XCTest
@testable import Reciplease

/// Test for the RecipeObject class
class RecipeObjectTests: XCTestCase {
  
  /// test initializer
  func testGivenADictionnary_whenUserInitARecipeObject_thenARecipeObjecctIsIntantiated() {
    let recipeDictionnary: [String: Any] = [
      "id": "recette-1",
      "name": "recette",
      "ingredients": ["onion", "ham"],
      "images": [["hostedLargeUrl": "thumbnail"]],
      "totalTime": "1 hour",
      "yield": "4"
    ]
    let recipe = RecipeObject(recipeDictionnary: recipeDictionnary)
    XCTAssertEqual(recipe.id!, "recette-1")
    XCTAssertEqual(recipe.recipeName!, "recette")
    XCTAssertEqual(recipe.image!, "thumbnail")
    XCTAssertEqual(recipe.totalTime!, "1 hour")
    XCTAssertEqual(recipe.yield!, "4")
  }

}
