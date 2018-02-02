//
//  SearchResultController.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 22/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import CoreData

/// This Controller handles the display of
/// results fetched from web search on Yummly API
class RecipeDisplayController: UIViewController, DetailRecipeDelegate {
  
  // /////////////////// //
  // MARK: - PROPERTIES //
  // /////////////////// //
  
  /// DetailRecipeDelegate property
  var recipe: RecipeObject?
  
  /// Array that contains ids fetch ingredient list
  var recipeIds : [String] = []
  /// Array that stores objects fetch from API
  var recipeResults: [RecipeObject] = []
 
  // /////////////////// //
  // MARK: - CUSTOM INIT //
  // /////////////////// //
  
  init(title: String, ids: [String]){
    super.init(nibName: nil, bundle: nil)
    self.title = title
    self.recipeIds = ids
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // setup Delegations
    tableview.delegate = self
    tableview.dataSource = self
    parseResults()
    showLoader()
  }
  
  // ////////////////////////////// //
  // MARK: - UI CREATION PROPERTIES //
  // ////////////////////////////// //
  
  
  /// Instantiate the background image for loader
  private var loadingBg : UIImageView = {
    let bgImage = UIImageView()
    bgImage.image = UIImage(named:"Background_Image")
    bgImage.frame = UIScreen.main.bounds
    return bgImage
  }()
  
  /// Create table View
  var tableview: UITableView = {
    let table = UITableView()
    table.frame = UIScreen.main.bounds
    table.register(RecipeCell.self, forCellReuseIdentifier: "recipeCell")
    return table
  }()
  
  /// Create spinning loader
  lazy var activityIndicatorView: UIActivityIndicatorView = {
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    activityIndicatorView.hidesWhenStopped = true
    // Set Center
    var center = self.view.center
    if let navigationBarFrame = self.navigationController?.navigationBar.frame {
      center.y -= (navigationBarFrame.origin.y + navigationBarFrame.size.height)
    }
    activityIndicatorView.center = center
    return activityIndicatorView
  }()
  
  
  // /////////////////////// //
  // MARK: - DISPLAY METHODS //
  // /////////////////////// //
  
  
  /// Instantiate Loader
  func showLoader(){
    tableview.isHidden = true
    self.view.addSubview(loadingBg)
    self.view.addSubview(activityIndicatorView)
    activityIndicatorView.startAnimating()
  }
  
  /// Get complete datas from list of ids sent by API
  /// parse them, and display them in tableView
  func parseResults() {
    RecipeApiManager.getRecipe(self.recipeIds, completion: {(recipes,error) in
      self.recipeResults = recipes!
      self.tableview.reloadData()
      self.view.addSubview(self.tableview)
      self.tableview.isHidden = false
      self.loadingBg.removeFromSuperview()
    })
  }
    
  /// Show aler pop up
  ///
  /// - Parameter message: String that will be displayed to alert user
  func showAlert(message: String) {
    let alertVC = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    self.present(alertVC, animated: true, completion: nil)
  }
}
