//
//  CoreDataManagerTests.swift
//  RecipleaseTests
//
//  Created by Mathieu Janneau on 02/02/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import XCTest
import CoreData
@testable import Reciplease

class CoreDataManagerTests: XCTestCase {
    let mockData = MockCoreDataManager()
  
    override func setUp() {
        super.setUp()
     
    }
  
  fileprivate func setupMultipleItems() {
    mockData.save(id: "recipe-1", isFavorite: true, recipeName: "recipe", totalTime: "1h15", yield: "4 persons", ingredients: ["onion","ham"], image: "image.jpg")
    mockData.save(id: "recipe-2", isFavorite: true, recipeName: "recipe", totalTime: "1h15", yield: "4 persons", ingredients: ["onion","ham"], image: "image.jpg")
    mockData.save(id: "recipe-3", isFavorite: true, recipeName: "recipe", totalTime: "1h15", yield: "4 persons", ingredients: ["onion","ham"], image: "image.jpg")
  }
  fileprivate func setupSingleItem() {
    mockData.save(id: "recipe-1", isFavorite: true, recipeName: "recipe", totalTime: "1h15", yield: "4 persons", ingredients: ["onion","ham"], image: "image.jpg")
  }
  
  func testGivenAnEmptyCoreDataStack_whenUserSaveAnRecipe_thenCoredataIsAdded(){
    var data: [Recipe]?
    setupSingleItem()
     data = mockData.loadRecipe()
    XCTAssert(data != nil)
  }
  
  func testGivenCoreDataIsPopulated_whenUserLoadData_thenCoreDataManagerReturnsIds() {
  setupSingleItem()
    
    let returnedId = mockData.loadData()
    XCTAssertEqual(returnedId, ["recipe-1"])
  }
  
  func testGivenARecipeObject_whenUserConverts_thenCDMReturnsARecipeObject(){
    setupSingleItem()
    let recipe = mockData.loadRecipe()[0]
    let result = mockData.convertRecipeToObject(recipe: recipe)
    XCTAssert((result as Any) is RecipeObject)
  }
  
  func testGivenRecipeId_whenRecipeIsStored_thenReturnsIsFavoriteTrue(){
    setupSingleItem()
    let checkResult = mockData.checkIfRecipeObjectIsStored(id: "recipe-1")
    XCTAssert(checkResult)
    
  }
  
  func testGivenCDMIsNotEmpty_whenUSerLoadsRecipes_thenItReturnsRecipes(){
    var stack: [Recipe]?
    setupMultipleItems()
    stack = mockData.loadRecipe()
    XCTAssert(stack != nil)
    
    
  }
  func testGivenitemStoredInCDM_whenUserDeletes_thenitemsisRemoved(){
    var stack : [Recipe]?
    setupSingleItem()
    
    let recipe = mockData.loadRecipe()[0]
    let result = mockData.convertRecipeToObject(recipe: recipe)
    
    mockData.deleteItem(result)
    stack = mockData.loadRecipe()
    XCTAssertEqual(stack!,[])
  }
  

  
  func testGivenitemsStoredInCDM_whenUserDeletesAll_thenCDMIsEmpty(){
    var stack : [Recipe]?
    setupMultipleItems()
    
    mockData.deleteAllItems()
    stack = mockData.loadRecipe()
    XCTAssertEqual(stack!,[])
  }
    
}
