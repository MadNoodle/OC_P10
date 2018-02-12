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
class UserManager {
  
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
  func checkExistingUsers(email:String) -> Bool{
    let users : [User] = loadUsers()
    var existingUsers : [String] = []
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
  func logInUser(email:String, password:String) -> Bool {
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
  func fetchUser(email:String) -> User {
    var userLogged : User?
    let users = loadUsers()
    for user in users {
      if user.email == email {
        userLogged = user
      }
    }
    return userLogged!
  }

  /// Store logged user in User defaults to retrieve it when calling new rootViewController
  ///
  /// - Parameter email: String
  func setLoggedUser(email:String){
    
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
}


