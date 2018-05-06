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

/// Tests all CoreDataManager Functions
class CoreDataManagerTests: XCTestCase {
  
  /// override persistent container to make the tests
  let mockData = MockDataManager()
  
  /// Create 3 recipes
  func setupMultipleItems() {
    // Create user
    mockData.createUser(name: "id", email: "mail", password: "pass")
    // Grab user from coreData
    let user = mockData.fetchUser(email: "mail")
    // Save recipes
    mockData.saveRecipe(user: user, id: "recipe-1", isFavorite: true, recipeName: "recipe", totalTime: "1h15", yield: "4 persons", ingredients: ["onion", "ham"], image: "image.jpg", url: "http://test.com")
    mockData.saveRecipe(user: user, id: "recipe-2", isFavorite: true, recipeName: "recipe", totalTime: "1h15", yield: "4 persons", ingredients: ["onion", "ham"], image: "image.jpg", url: "http://test.com")
    mockData.saveRecipe(user: user, id: "recipe-3", isFavorite: true, recipeName: "recipe", totalTime: "1h15", yield: "4 persons", ingredients: ["onion", "ham"], image: "image.jpg", url: "http://test.com")
  }
  
  /// Create 1 recipe
  func setupSingleItem() {
    // Create user
    mockData.createUser(name: "id", email: "mail", password: "pass")
     // Grab user from coreData
    let user = mockData.fetchUser(email: "mail")
    // Save recipes
    mockData.saveRecipe(user: user, id: "recipe-1", isFavorite: true, recipeName: "recipe", totalTime: "1h15", yield: "4 persons", ingredients: ["onion", "ham"], image: "image.jpg", url: "http://test.com")
  }
  
  /// Test saveRecipe() function
  func testGivenAnEmptyCoreDataStack_whenUserSaveAnRecipe_thenCoredataIsAdded() {
    var data: [Recipe]?
    // create recipe
    setupSingleItem()
    // reload data from CoreData
    data = mockData.loadRecipe()
    // if saved data is not nil
    XCTAssert(data != nil)
  }
  
  /// Test LoadRecipe()
  func testGivenCoreDataIsPopulated_whenUserLoadData_thenCoreDataManagerReturnsIds() {
    // create recipe
    setupSingleItem()
     // reload ids from CoreData
    let returnedId = mockData.loadData()
    // ids is equal to recipe.id
    XCTAssertEqual(returnedId, ["recipe-1"])
  }
  
  /// test Conversion between Recipe and RecipeObject
  func testGivenARecipeObject_whenUserConverts_thenCDMReturnsARecipeObject() {
    // create recipe
    setupSingleItem()
    // Load first recipe
    let recipe = mockData.loadRecipe()[0]
    // Convert to recipe object and store it
    let result = mockData.convertRecipeToObject(recipe: recipe)
    // resilt have to be of type RecipeObject
    XCTAssert((result as Any) is RecipeObject)
  }
  
  /// test if recipe is favorite
  func testGivenRecipeId_whenRecipeIsStored_thenReturnsIsFavoriteTrue() {
    // create recipe
    setupSingleItem()
    //check if it is stored
    let checkResult = mockData.checkIfRecipeObjectIsStored(id: "recipe-1")
    // if stored should be true
    XCTAssert(checkResult)
    
  }
  
  /// Test loadRecipe()
  func testGivenCDMIsNotEmpty_whenUSerLoadsRecipes_thenItReturnsRecipes() {
    var stack: [Recipe]?
    // create recipes
    setupMultipleItems()
    // load all recipes from core data
    stack = mockData.loadRecipe()
    // Stack is populated
    XCTAssert(stack != nil)
  }
  
  /// Test deleteItem
  func testGivenitemStoredInCDM_whenUserDeletes_thenitemsisRemoved() {
    var stack: [Recipe]?
    // create recipes
    setupSingleItem()
    // load recipes in array
    let recipe = mockData.loadRecipe()[0]
    // convert in recipe object
    let result = mockData.convertRecipeToObject(recipe: recipe)
    // delete recipe according to recipeOBject
    mockData.deleteItem(result)
    // load all recipes
    stack = mockData.loadRecipe()
    // stack is purged
    XCTAssertEqual(stack!, [])
  }
  
  /// Test deleteAll()
  func testGivenitemsStoredInCDM_whenUserDeletesAll_thenCDMIsEmpty() {
    var stack: [Recipe]?
    // create recipes
    setupMultipleItems()
    // delete recipe items all
    mockData.deleteAllItems()
    // reload data
    stack = mockData.loadRecipe()
    // stack is purged
    XCTAssertEqual(stack!, [])
  }
  
  /// Test if user already exist in CoreData
  func testGivenAUser_whenUserExist_thenReturnsTrue() {
    // Create user
    mockData.createUser(name: "id", email: "mail", password: "pass")
    // test if it exists in coreData
    let test = mockData.checkExistingUsers(email: "mail")
    // test should be true
    XCTAssert(test)
  }
  
  /// Test that user is not stored
  func testGivenAUser_whenUserDoesNotExist_thenReturnsFalse() {
    // Create user
    mockData.createUser(name: "id", email: "mail", password: "pass")
    // test if it exists in coreData
    let test = mockData.checkExistingUsers(email: "test")
    // should return false
    XCTAssertFalse(test)
  }
  
  /// Test purging users entities
  func testGivenUserStackPopulated_whenClearStack_thenStackIsEmpty() {
    // Create users and recipes
    setupMultipleItems()
    // purge users
    mockData.clearUsers()
    // Load users
    let data: [User] = mockData.loadUsers()
    // count must be 0
    XCTAssert(data.count == 0)
  }
  
  /// Test login()
  func testGivenAnExistingUser_whenLogging_thenReturnsTrue() {
    // Create user and recipe
    setupSingleItem()
    // login and verify returns true if user is signed up
    let test = mockData.logInUser(email: "mail", password: "pass")
    // should be true
    XCTAssert(test)
  }
  
  /// Test fetchUser()
  func testWhenAUserIsLogged_whenWefetchHimFromUSerDefaults_thenHisEmailIsReturned() {
    // userDefaults
    let defaults = UserDefaults.standard
    // inject value in userDefaults
    defaults.set("test", forKey: "currentUser")
    // create a user
    mockData.createUser(name: "test", email: "test", password: "test")
    // fetchUser
    let fetchedUser = mockData.getCurrentUser()
    // validate user infos
    XCTAssert(fetchedUser.email! == "test")
    XCTAssert(fetchedUser.name! == "test")
    XCTAssert(fetchedUser.password! == "test")
    
  }
}
