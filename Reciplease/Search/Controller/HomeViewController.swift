//
//  HomeViewController.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 22/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit



/// This class takes care of showing the homeViewController nested in UITabBarController
/// It handles the ingredient list and searcch functionnalities
class HomeViewController: UIViewController, userLoggedDelegate {

  /// Array to store ingredients entered by user
  var list : [String] = []
  /// Array that stores list of fetch ids for ingredient's search
  var ids : [String] = []
  /// Delegate to receive user from MainTabBar Controller
  var delegate: userLoggedDelegate?
  /// Property that stores and the logged user
  var user: User?
  
  // //////////////// //
  // MARK: - OUTLETS //
  // //////////////// //
  
  /// tableView to display ingredient picked by user
  @IBOutlet weak var ingredientTable: UITableView!
  /// textField where user type ingredients to add to the list
  @IBOutlet weak var inputTextField: UITextField!
  
  
  // ////////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "HOME"
    if delegate != nil {user = delegate?.CurrentUser()}
    setupDelegations()
    // Register cell
    ingredientTable.register(UITableViewCell.self, forCellReuseIdentifier: "ingredientCell")
    ingredientTable.reloadData()
  }
  
  // //////////////////////// //
  // MARK: - ACTIONS METHODS //
  // /////////////////////// //
  
  
  /// Add ingredient un ingredient Array and update tableView
  ///
  /// - Parameter sender: UIButton
  @IBAction func addIngredient(_ sender: UIButton) {
    loadTextFromTextField()
  }
  
  /// Reset ingredient List to empty and clear table view
  ///
  /// - Parameter sender: UIButton
  @IBAction func clearList(_ sender: UIButton) {
    if list != []
    {
      // Clear ingredient list
      list = []
      // update tableView
      ingredientTable.reloadData()
    } else {
      showAlert(message: "Your list is already empty")
    }
  }
  
  /// Search Corresponding recipe Id's
  ///
  /// - Parameter sender: UIButton
  @IBAction func searchRecipes(_ sender: UIButton) {
    // instantiate controller
    if list != []{
      loadDataInTable()
      } else {
      showAlert(message: "Sorry i can't help you if your fridge is empty")
    }
  }
  
  /// Perform a fetch request with ingredient List and present resultController
  func loadDataInTable() {
    let encoded = RecipeApiManager.splitIngredients(list: list)
    RecipeApiManager.searchRecipe(with: encoded , completion: {(recipeNames, error) in
      if error != nil {
        print("error")
      }
      self.ids = recipeNames
      let searchResultVc = RecipeDisplayController(title: "RESULTS", ids: self.ids)
      searchResultVc.userDelegate = self
      self.navigationController?.pushViewController(searchResultVc, animated: true)
    })
  }
  
  // ////////////////////////// //
  // MARK: - DELEGATION METHODS //
  // ///////////////////////// //
  
  
  /// Sets up delegation fro textField and tableView
  func setupDelegations() {
    // Set delegation for textField
    inputTextField.delegate = self
    // set delegation for Ingredients tableView
    ingredientTable.delegate = self
    ingredientTable.dataSource = self
  }
  
  /// userLoggedDelegate delegation method
  ///
  /// - Returns: User. logged user
  func CurrentUser() -> User {
    return user!
  }
  
  // /////////////////////// //
  // MARK: - DISPLAY METHODS //
  // /////////////////////// //
  
  /**
   Show alert when user try to do an invalid operation
   */
  func showAlert(message: String) {
    let alertVC = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    self.present(alertVC, animated: true, completion: nil)
  }
  
  /// Takes input from texfield and load it in tableView for ingredient List
  func loadTextFromTextField() {
    let text = inputTextField.text
    if text != "" {
      list.append(text!)
      ingredientTable.reloadData()
      inputTextField.text = ""
    }
    else {
      showAlert(message: "nothing is not an ingredient")
    }
  }


  
}

