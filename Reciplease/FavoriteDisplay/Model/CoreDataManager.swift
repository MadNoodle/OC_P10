//
//  CoreDataManager.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 25/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import CoreData
import UIKit // imported to access UIApllication

/**
 This manager handles all the actions concerning FavRecipes
 such as Creation, deletion, fetching in controllers,
 passing Favorites object between controllers
 */
struct CoreDataManager {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
  /// Shortcut to appDelegate to access to core data context
  static let delegate = UIApplication.shared.delegate as? AppDelegate
  /// Persistent Container context
  static let context = delegate?.persistentContainer.viewContext
  
  
  // ///////////////////////// //
  // MARK: - GET & SET METHODS //
  // //////////////////////// //
  
  
  /// This function returns all the ids from recipe stored in
  /// core data
  /// - Returns: Array of ids
  static func loadData() -> [String] {
    // array to store the recipe Objects from core data
    var recipes: [Recipe] = []
    // array to strore extracted ids
    var recipesIds : [String] = []
    // Perform fetch request
    let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
    do {
      recipes = (
        try context?.fetch(request))!
    } catch {
      print("loading error")
    }
    // append ids to the store array
    for recipe in recipes {
      recipesIds.append(recipe.id!)
    }
    return recipesIds
  }
  
  
  /// Save  an object in Core Data stack
  ///
  /// - Parameters:
  ///   - id: String id of the recipe
  ///   - isFavorite: Boolean true if favorite
  ///   - recipeName: String
  ///   - totalTime: String duration of the recipe preparation
  ///   - yield: String number of servings
  ///   - ingredients: [String] list of ingredients and quantity
  ///   - image: String url for image thumbnail
  static func save(id: String, isFavorite: Bool, recipeName: String, totalTime: String, yield: String, ingredients: [String], image: String) {
    // summons entity
    let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: context!)
    // create new entity instance
    let recipeItem = NSManagedObject(entity: entity!, insertInto: context)
    
    // sets value
    recipeItem.setValue(id, forKeyPath: "id")
    recipeItem.setValue(isFavorite, forKeyPath: "isFavorite")
    recipeItem.setValue(recipeName, forKeyPath: "recipeName")
    recipeItem.setValue(totalTime, forKeyPath: "totalTime")
    recipeItem.setValue(yield, forKeyPath: "yield")
    recipeItem.setValue(ingredients, forKeyPath: "ingredients")
    recipeItem.setValue(image, forKeyPath: "image")
    
    // save Context
    do {
      try context?.save()
    } catch {
      print("saving error")
      
    }
  }
  
  /// Converts a Core Data recipe Instance to RecipeObject in order to display it in detail view
  ///
  /// - Parameter recipe: Recipe you want to convert
  /// - Returns: RecipeObject
  static func convertRecipeToObject(recipe: Recipe) -> RecipeObject {
    // Create a dictionnary from recipe value
    let favRecipeDictionnary:[String: Any] = [
      "id": recipe.id!,
      "isFavorite": recipe.isFavorite,
      "name": recipe.recipeName!,
      "images": [["hostedLargeUrl": recipe.image!]],
      "ingredientLines": recipe.ingredients!,
      "totalTime": recipe.totalTime!,
      "yield": recipe.yield!
    ]
    // Instantiate recipe object from dictionnary
    let convertedRecipe = RecipeObject(recipeDictionnary: favRecipeDictionnary)
    return convertedRecipe
  }
  
  // ////////////////////// //
  // MARK: - STATUS METHODS //
  // ////////////////////// //
  
  
  /// Check if an id matches a core data instance id
  ///
  /// - Parameter id: String id from object you want to check
  /// - Returns: Bool
  static func checkIfRecipeObjectIsStored(id: String) -> Bool{
    let datas:[String] = loadData()
    var checkAnswer = false
    if datas.contains(id){
      checkAnswer = true
    }
    return checkAnswer
  }
  

  
  // ////////////////////// //
  // MARK: - PURGING METHODS//
  // ////////////////////// //
  
  /// Delete an item from stack
  ///
  /// - Parameter object: RecipeObject to Delete
  static func deleteItem(_ object: RecipeObject) {
    let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", object.id!)
    do {
      let results = try context?.fetch(request)
      
      for result in results! {
        context?.delete(result)
      }
    } catch {
      print("deleting error")
    }
  }
 
  /// Purge the stack. Can be invoked in AppDelegate to purge Core data
  static func deleteAllItems() {
    let datas = loadRecipe()
    for data in datas {
      context?.delete(data)
    }
    do {
      try context?.save()
    } catch {
      print("purging error")
    }
  }
  
  /// Gather all items from stack and delete them
  static func loadRecipe() -> [Recipe] {
    var recipeItems: [Recipe] = []
    let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
    do {
      recipeItems = (try context?.fetch(request))!
    } catch {
      print("loading error")
    }
    return recipeItems
  }
}

