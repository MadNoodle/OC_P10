//
//  RecipeApiManagerTests.swift
//  RecipleaseTests
//
//  Created by Mathieu Janneau on 02/02/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import XCTest
@testable import Reciplease

class RecipeApiManagerTests: XCTestCase {
  
  /// Test function splitIngredients()
  func testGivenListOfIngredient_whenUserPressSearch_thenAnEncodedStrinIsCreated() {
    let ingredients = ["onion", "ham"]
    let encodedEndPoint = RecipeApiManager.splitIngredients(list: ingredients)
    XCTAssertEqual(encodedEndPoint, "onion&allowedIngredient[]=ham")
    
  }
  
  /// Test function searchRecipe()
  func testGivenAnEncodedListIsEntered_whenUserSearch_thenListOfIdisReturned() {
    let ex = expectation(description: "returns a list of strings")
    let ingredients = ["onion", "ham"]
    let encodedEndPoint = RecipeApiManager.splitIngredients(list: ingredients)
    var resultArray: [String]?
    RecipeApiManager.searchRecipe(with: encodedEndPoint, completion: {(result, error) in
      if error != nil {
        print(error!.localizedDescription)
      }
      resultArray = result
      
    })
    XCTAssert(resultArray?.count != 0)
    ex.fulfill()
    waitForExpectations(timeout: 10) { (error) in
      if let error = error {
        XCTFail("error: \(error)")
      }
    }
  }

  /// Test function searchRecipe() Error
  func testGivenAnInvalidListIsEntered_whenUserSearch_thenErrorIsReturned() {
    let ex = expectation(description: "returns an error")
    let ingredients = ["onioefvqsvcqvfds   n", "hadfsqfdsqfqsm"]
    let encodedEndPoint = RecipeApiManager.splitIngredients(list: ingredients)
    RecipeApiManager.searchRecipe(with: encodedEndPoint, completion: {(_, error) in
      XCTAssert(error != nil)
      ex.fulfill()}
    )
    
    waitForExpectations(timeout: 10) { (error) in
      if let error = error {
        XCTFail("error: \(error)")
      }
    }
  }
  
  /// test getRecipe()
  func testGivenAlistOfIds_whenGettingRecipes_thenRecipesAreReturned() {
    let ex = expectation(description: "returns a RecipeObject")
    let ingredients = ["onion", "ham"]
    let encodedEndPoint = RecipeApiManager.splitIngredients(list: ingredients)
    var recipes: [RecipeObject]?
    RecipeApiManager.searchRecipe(with: encodedEndPoint, completion: {(result, _) in
      RecipeApiManager.getRecipe(result, completion: {(results, _) in
        recipes = results
        XCTAssert(recipes != nil)
        ex.fulfill()})
      })
    
    waitForExpectations(timeout: 10) { (error) in
      if let error = error {
        XCTFail("error: \(error)")
      }
    }
  }
  
}
