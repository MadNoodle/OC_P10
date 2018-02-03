//
//  FavoriteRecipeController.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 27/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import CoreData

class FavoriteRecipeController: UITableViewController {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
  /// DetailRecipeDelegate property
  var recipe: RecipeObject?
  
  /// Core Data persistent container context
  let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

  /// fetchResultController to autoupdate table view from coreData
  var fetchedResultController:NSFetchedResultsController<Recipe>!
  
  let cdManager = CoreDataManager()
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
    override func viewDidLoad() {
      super.viewDidLoad()
      self.title = "FAVORITES"
      fetchedResultController?.delegate = self
      fetchDataFromStack()
      tableView.register(RecipeCell.self, forCellReuseIdentifier: "myCell")
      tableView.reloadData()
    }

  override func viewWillAppear(_ animated: Bool) {
    fetchDataFromStack()
    tableView.reloadData()
  }

  // /////////////// //
  // MARK: - METHODS //
  // ////////////// //
  
  
  /// This methods call the Core Data to fetch favorite recipes
  func fetchDataFromStack() {
    // parameters for fetch request
    let fetchRequest : NSFetchRequest<Recipe> = Recipe.fetchRequest()
    let sort = NSSortDescriptor(key: "id", ascending: true)
    fetchRequest.sortDescriptors = [sort]
    
    // autoupdate without caching
    fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
    do{
        // fetch data from CoreData
      try fetchedResultController.performFetch()
    } catch let error as NSError {
      print("Fetching error: \(error), \(error.userInfo)")
    }
  }    
}


