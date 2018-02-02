//
//  HomeViewController.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 22/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit



class HomeViewController: UIViewController {
  
  /// Array to store ingredients entered by user
  var list : [String] = []
  var ids : [String] = []
  
  
  // //////////////// //
  // MARK: - OUTLETS //
  // //////////////// //
  
  
  @IBOutlet weak var ingrdientTable: UITableView!
  @IBOutlet weak var inputTextField: UITextField!
  
  
  // ////////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "HOME"
    setupDelegations()
    // Register cell
    ingrdientTable.register(UITableViewCell.self, forCellReuseIdentifier: "ingredientCell")
    ingrdientTable.reloadData()
  }
  
  // //////////////////////// //
  // MARK: - ACTIONS METHODS //
  // /////////////////////// //
  @IBAction func addIngredient(_ sender: UIButton) {
    loadTextFromTextField()
  }
  
  @IBAction func clearList(_ sender: UIButton) {
    if list != []
    {
      list = []
      ingrdientTable.reloadData()
    } else {
      showAlert(message: "Your list is already empty")
    }
  }
  
  @IBAction func searchRecipes(_ sender: UIButton) {
    // instantiate controller
    if list != []{
      loadDataInTable()
      } else {
      showAlert(message: "Sorry i can't help you if your fridge is empty")
    }
  }
  
  func loadDataInTable() {
    let encoded = RecipeApiManager.splitIngredients(list: list)
    RecipeApiManager.searchRecipe(with: encoded , completion: {(recipeNames, error) in
      if error != nil {
        print("error")
      }
      self.ids = recipeNames
      let searchResultVc = RecipeDisplayController(title: "RESULTS", ids: self.ids)
      self.navigationController?.pushViewController(searchResultVc, animated: true)
    })
  }
  
  // ////////////////////////// //
  // MARK: - DELEGATION METHODS //
  // ///////////////////////// //
  
  
  func setupDelegations() {
    // Set delegation for textField
    inputTextField.delegate = self
    // set delegation for Ingredients tableView
    ingrdientTable.delegate = self
    ingrdientTable.dataSource = self
    
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
      ingrdientTable.reloadData()
      inputTextField.text = ""
    }
    else {
      showAlert(message: "nothing is not an ingredient")
    }
  }
}

