//
//  HomeViewController.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 22/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

protocol RecipeFetcher {
  func getIngredients() -> [String]
}
class HomeViewController: UIViewController {
  
  /// Array to store ingredients entered by user
  var ingredientList : [String] = []
  
  // MARK: - OUTLETS
  @IBOutlet weak var ingrdientTable: UITableView!
  @IBOutlet weak var inputTextField: UITextField!

  
  // MARK: - LIFECYCLE METHODS
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "HOME"
    inputTextField.delegate = self
    // set delegation for Ingredients tableView
    ingrdientTable.delegate = self
    ingrdientTable.dataSource = self
    // Register cell
    ingrdientTable.register(UITableViewCell.self, forCellReuseIdentifier: "ingredientCell")
    ingrdientTable.reloadData()
    
  }
  // MARK: - ACTIONS
  @IBAction func addIngredient(_ sender: UIButton) {
    loadTextFromTextField()
  }
  
  @IBAction func clearList(_ sender: UIButton) {
    // faire une fonction show alert pour confirmation
    ingredientList = []
    ingrdientTable.reloadData()
  }
  
  @IBAction func searchRecipes(_ sender: UIButton) {
    let searchResultVc = SearchResultController()
    navigationController?.pushViewController(searchResultVc, animated: true)
  }
  
  // MARK: - Display Methods
  
  /**
   Show alert when user try to do an invalid operation
   */
  func showAlert() {
    let alertVC = UIAlertController(title: "Warning", message: "Empty is not an ingredient!", preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    self.present(alertVC, animated: true, completion: nil)
  }
  
  /// Takes input from texfield and load it in tableView for ingredient List
  func loadTextFromTextField() {
    let text = inputTextField.text
    if text != "" {
      ingredientList.append(text!)
      ingrdientTable.reloadData()
      inputTextField.text = ""
    }
    else {
      showAlert()
    }
  }
}

