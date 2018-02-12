//
//  FavoriteRecipeController.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 27/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import CoreData

class FavoriteRecipeController: UITableViewController{
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
  /// DetailRecipeDelegate property
  var recipe: RecipeObject?
  /// Delegate to pass User Data from Login Controller
  var delegate: userLoggedDelegate?
  /// User logged Account
  var user: User?
  /// Core Data persistent container context
  let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
  let cdManager = CoreDataManager()
  ///  call the Core Data to fetch favorite recipes
  lazy var fetchedResultController: NSFetchedResultsController<Recipe> = {
    let request = NSFetchRequest<Recipe>(entityName: "Recipe")
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
    request.sortDescriptors = [sortDescriptor]
    request.predicate = NSPredicate(format: "user == %@", user!)
    let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
    frc.delegate = self
    return frc
  }()
 
  
 
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
    override func viewDidLoad() {
      super.viewDidLoad()
      self.title = "FAVORITES"
      
      if delegate != nil {
        user = delegate?.CurrentUser()
      }
      // fetchDataFromStack(email:(user?.email)!)
      do{
        // fetch data from CoreData
        try fetchedResultController.performFetch()
      } catch let error as NSError {
        print("Fetching error: \(error), \(error.userInfo)")
      }
      //fetchDataFromStack(email:(user?.email)!)
      tableView.register(RecipeCell.self, forCellReuseIdentifier: "myCell")
      fetchedResultController.delegate = self
      
      tableView.reloadData()
      
   
    }

  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }


}


