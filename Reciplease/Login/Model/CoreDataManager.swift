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
 This manager handles all the actions concerning Users
 such as Creation, deletion, fetching in controllers,
 */
class CoreDataManager {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
  /// Shortcut to appDelegate to access to core data context
  let delegate = UIApplication.shared.delegate as? AppDelegate
  
  /// Persistent Container context
  func managedObjectContext() -> NSManagedObjectContext {
    return (delegate?.persistentContainer.viewContext)!
  }
  
  let defaults = UserDefaults.standard
  
  // ////////////////////// //
  // MARK: - USERS STORING //
  // ////////////////////// //
  
  /// Check if user is already registered in Core Data
  ///
  /// - Parameter email: String. Email
  /// - Returns: Bool. true is already registered
  func checkExistingUsers(email: String) -> Bool {
    let users: [User] = loadUsers()
    var existingUsers: [String] = []
    for user in users {
      existingUsers.append(user.email!)
    }
    if existingUsers.contains(email) {
      return true
    } else {
      return false
    }
  }
  
  /// This method create a new User in Managed Context
  ///
  /// - Parameters:
  ///   - name: String name of the user
  ///   - email: String email of the user
  ///   - password: String password
  func createUser(name: String, email: String, password: String) {
      // summons entity
      let entity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext())
      // create new entity instance
      let newUser = NSManagedObject(entity: entity!, insertInto: managedObjectContext())
      // sets value
      newUser.setValue(name, forKeyPath: "name")
      newUser.setValue(email, forKeyPath: "email")
      newUser.setValue(password, forKeyPath: "password")
      // save Context
      do {
        try managedObjectContext().save()
      } catch {
        print("saving error")
      }
    setLoggedUser(email: email)
  }
  
  /// Retrieve users from Core Data context
  ///
  /// - Returns: [User] all the user in database
  func loadUsers() -> [User] {
    // array to store the recipe Objects from core data
    var users: [User] = []
    // Perform fetch request
    let request: NSFetchRequest<User> = User.fetchRequest()
    do {
      users = (
        try managedObjectContext().fetch(request))
    } catch {
      print("loading error")
    }
    return users
  }
  
  /// Purge User database
  func clearUsers () {
    let users =  loadUsers()
    for user in users {
      managedObjectContext().delete(user)
    }
    do {
      try managedObjectContext().save()
    } catch {
      print("purging error")
    }
  }
  
  /// Validation method for login a userin
  ///
  /// - Parameters:
  ///   - email: String user's email
  ///   - password: String user's password
  /// - Returns: Bool. true if granted
  func logInUser(email: String, password: String) -> Bool {
    let users = loadUsers()
    var answer = false
    for user in users {
      if email == user.email && password == user.password {
          answer = true
      }
    }
    return answer
  }
  
  /// Find user with the entered email in User Database
  ///
  /// - Parameter email: String email to search
  /// - Returns: User. user stored in Core Data
  func fetchUser(email: String) -> User {
    var userLogged: User?
    let users = loadUsers()
    for user in users where user.email == email {
        userLogged = user
    }
    return userLogged!
  }

  /// Store logged user in User defaults to retrieve it when calling new rootViewController
  ///
  /// - Parameter email: String
  func setLoggedUser(email: String) {
    defaults.set(email, forKey: "currentUser")
  }
  
  func getCurrentUser() -> User {
    var userLogged: User?
    // grab user's email
    let user = defaults.string(forKey: "currentUser")
    if user != nil {
      print("LOGGED :\(user!)")
      // fetch user from Core Data
      userLogged = fetchUser(email: user!)
    }
    return userLogged!
  }
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
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
    var recipesIds: [String] = []
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
    let favRecipeDictionnary: [String: Any] = [
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
  func checkIfRecipeObjectIsStored(id: String) -> Bool {
    let datas: [String] = loadData()
    var checkAnswer = false
    if datas.contains(id) {
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
