//
//  FavoriteRecipeController.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 27/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import CoreData

/// This ccontroller handles Communication and display for user's favorites recipes
class FavoriteRecipeController: UITableViewController, userLoggedDelegate {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
  /// Core Data persistent container context
  let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
  /// DetailRecipeDelegate property
  var recipe: RecipeObject?
  /// Delegate to pass User Data from Login Controller
  weak var delegate: userLoggedDelegate?
  /// User logged Account
  var user: User?
  /// Instantiate user and recipe management functionnalities
  let userManager = CoreDataManager()

  // ////////////////////////////// //
  // MARK: FETCH RESULTS CONTROLLER //
  // ////////////////////////////// //
  
  ///  call the Core Data to fetch favorite recipes
  lazy var fetchedResultController: NSFetchedResultsController<Recipe> = {
    // Create a request to look for all Recipes
    let request = NSFetchRequest<Recipe>(entityName: "Recipe")
    // order them by id ### do not remove, it s mandatory for frc to work ###
    let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
    // assign descriptor to the request
    request.sortDescriptors = [sortDescriptor]
    // filter results to onlly fetch results from logged user
    request.predicate = NSPredicate(format: "user == %@", user!)
    // instantiate the fetchResultsController
    let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
    // assign delegation method to autUpdate tableView when content is changed cf. FavoriteRecipeController+fetchResultController to modify behavior
    frc.delegate = self
    return frc
  }()
 
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
  fileprivate func loadRecipes() {
    // receive logged user from MainTabBarController
    if delegate != nil {
      user = delegate?.CurrentUser()
    }
    // fetchDataFromStack(email:(user?.email)!)
    do {
      // fetch data from CoreData
      try fetchedResultController.performFetch()
    } catch let error as NSError {
      print("Fetching error: \(error), \(error.userInfo)")
    }
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
      self.title = "FAVORITES"
      loadRecipes()
      // Register custom Cell
      tableView.register(RecipeCell.self, forCellReuseIdentifier: "myCell")
      tableView.reloadData()
    }

  override func viewWillAppear(_ animated: Bool) {
    
    //tableView.reloadData()
  }
  
  // ///////////////////////// //
  // MARK: - PASSING USER      //
  // ///////////////////////// //
  
  func CurrentUser() -> User {
    return user!
  }
}
