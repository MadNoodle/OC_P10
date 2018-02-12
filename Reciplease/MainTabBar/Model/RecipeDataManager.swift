//
//  RecipeDataManager.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 12/02/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/// This class handles all interaction with Core Data Recipe Entity such CRUD, fetching, checking
class RecipeDataManager {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
  /// Shortcut to appDelegate to access to core data context
  let delegate = UIApplication.shared.delegate as? AppDelegate
  
  /// Persistent Container context
  func managedObjectContext() -> NSManagedObjectContext {
    return (delegate?.persistentContainer.viewContext)!
  }
  
  // /////////////// //
  // MARK: - CREATE //
  // ////////////// //
  
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
  func saveRecipe(user: User, id: String, isFavorite: Bool, recipeName: String, totalTime: String?, yield: String?, ingredients: [String], image: String, url: String?) {
    // summons entity
    let recipe = NSEntityDescription.entity(forEntityName: "Recipe", in: managedObjectContext())
    // create new entity instance
    let recipeItem = Recipe(entity: recipe!, insertInto: managedObjectContext())
    // Assign Values
    recipeItem.id = id
    recipeItem.isFavorite = isFavorite
    recipeItem.recipeName = recipeName
    recipeItem.ingredients = ingredients
    recipeItem.image = image
    if totalTime != nil { recipeItem.totalTime = totalTime } else { recipeItem.totalTime = ""}
    if yield != nil { recipeItem.yield = yield } else {recipeItem.yield = ""}
    if url != nil { recipeItem.url = url} else {recipeItem.url = ""}
    recipeItem.user = user
    
        //------CONTROL PRINT-------//
    printRecipesFor(user)

    
    // save Context
    do {
      try managedObjectContext().save()
    } catch {
      print("saving error")
      
    }
  }
  

  // //////////// //
  // MARK: - READ //
  // //////////// //
  
  /// This function returns all the ids from recipe stored in
  /// core data
  /// - Returns: Array of ids
  func loadData() -> [String] {
    // array to store the recipe Objects from core data
    var recipes: [Recipe] = []
    // array to strore extracted ids
    var recipesIds : [String] = []
    // Perform fetch request
    let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
    do {
      recipes = (
        try managedObjectContext().fetch(request))
    } catch {
      print("loading error")
    }
    // append ids to the store array
    for recipe in recipes {
      recipesIds.append(recipe.id!)
    }
    return recipesIds
  }
  
  /// This function returns all the Recipe Objects stored in
  /// core data
  /// - Returns: Array of Recipes
  func loadRecipe() -> [Recipe] {
    var recipeItems: [Recipe] = []
    let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
    do {
      recipeItems = (try managedObjectContext().fetch(request))
    } catch {
      print("loading error")
    }
    return recipeItems
  }
  
  /// Converts a Core Data recipe Instance to RecipeObject in order to display it in detail view
  ///
  /// - Parameter recipe: Recipe you want to convert
  /// - Returns: RecipeObject
  func convertRecipeToObject(recipe: Recipe) -> RecipeObject {
    // Create a dictionnary from recipe value
    let favRecipeDictionnary:[String: Any] = [
      "id": recipe.id!,
      "isFavorite": recipe.isFavorite,
      "name": recipe.recipeName!,
      "images": [["hostedLargeUrl": recipe.image!]],
      "ingredientLines": recipe.ingredients!,
      "totalTime": recipe.totalTime  as Any,
      "yield": recipe.yield as Any ,
      "url": recipe.url as Any
    ]
    // Instantiate recipe object from dictionnary
    let convertedRecipe = RecipeObject(recipeDictionnary: favRecipeDictionnary)
    return convertedRecipe
  }
  
  // ////////////// //
  // MARK: - DELETE //
  // ////////////// //
  
  /// Delete an item from stack
  ///
  /// - Parameter object: RecipeObject to Delete
  func deleteItem(_ object: RecipeObject) {
    let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", object.id!)
    do {
      let results = try managedObjectContext().fetch(request)
      
      for result in results {
        managedObjectContext().delete(result)
      }
    } catch {
      print("deleting error")
    }
  }
  
  /// Purge the stack. Can be invoked in AppDelegate to purge Core data
  func deleteAllItems() {
    let datas = loadRecipe()
    for data in datas {
      managedObjectContext().delete(data)
    }
    do {
      try managedObjectContext().save()
    } catch {
      print("purging error")
    }
  }
  
  // ////////////////////// //
  // MARK: - CONTROL METHODS //
  // ////////////////////// //
  
  
  /// Check if an id matches a core data instance id
  ///
  /// - Parameter id: String id from object you want to check
  /// - Returns: Bool
  func checkIfRecipeObjectIsStored(id: String) -> Bool{
    let datas:[String] = loadData()
    var checkAnswer = false
    if datas.contains(id){
      checkAnswer = true
    }
    return checkAnswer
  }

  /// Prints all stored recipes for a User
  ///
  /// - Parameter user: User User wich you want to display recipes
  func printRecipesFor(_ user: User) {
    //------CONTROL PRINT-------//
    let records = (user.recipes?.allObjects)! as? [Recipe]
    var index = 0
    for record in records! {
      index += 1
      print("recette \(index) : \(record.recipeName!)")
    }
  }
}
