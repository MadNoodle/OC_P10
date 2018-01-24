//
//  SearchResultController.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 22/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

class SearchResultController: UITableViewController, DetailRecipeDelegate {
  
  // Data Communication properties
  let homeVc = HomeViewController()
  var delegate: RecipeFetcherDelegate?
  
  // Protocol properties
  var recipeName: String = ""
  var recipeImage: String = ""
  var ingredientsList: [String] = []
  var totalTime: String = ""
  var servings: String = ""
  
  // properties
  var recipeResults: [RecipeObject] = []
  var recipeStrings: [String] = []
  var recipeIds: [String] = []
  

  // MARK: - LIFECYCLE METHODS
  override func viewDidLoad() {
    super.viewDidLoad()
    // receive data
    if delegate != nil {
      recipeStrings = (delegate?.list)!
    }
    // load and display data
    loadTableView()
  }
  
   // MARK: - Load Data Methods
  
  func loadTableView() {
    tableView.register(RecipeCell.self, forCellReuseIdentifier: "recipeCell")
    getRecipes()
  }
  
  func getRecipes() {
    let url = RecipeApiManager.splitIngredients(list: recipeStrings)
    DispatchQueue.main.async {
      RecipeApiManager.searchRecipe(with: url, completion: {(results,error) in
        if error != nil {
          print("error")
        }
        self.recipeIds = results
        self.parseResults()
      })
    }
  }
  
  func parseResults() {
    RecipeApiManager.getRecipe(self.recipeIds, completion: {(recipes,error) in
      self.recipeResults = recipes
      self.tableView.reloadData()
    })
  }
  
  
  // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return recipeResults.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = Bundle.main.loadNibNamed("RecipeCell", owner: self, options: nil)?.first as! RecipeCell
    
    cell.recipeName.text = recipeResults[indexPath.row].recipeName!
    cell.duration.text = recipeResults[indexPath.row].totalTime!
    
    let url = URL(string:recipeResults[indexPath.row].image!)
    let imageData:NSData = NSData(contentsOf: url!)!
    
    DispatchQueue.main.async {
      let image = UIImage(data: imageData as Data)
      cell.recipeImage.image = image
    }
    
    if let servings = recipeResults[indexPath.row].yield {
      cell.servings.text = servings
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 235
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    // inject values
    // optional binding to prevent nil bug when tapping before loading is finished
    if let result = recipeResults[indexPath.row].recipeName{
      recipeName = result
    }
    if let result = recipeResults[indexPath.row].image{
      recipeImage = result
    }
    if let result = recipeResults[indexPath.row].ingredients{
      ingredientsList = result
    }
    if let result = recipeResults[indexPath.row].totalTime{
      totalTime = result
    }
    if let result = recipeResults[indexPath.row].yield{
      servings = result
    }

    // Send data to detail controller
    let detailVc = Detail()
    detailVc.delegate = self
    // show detail controller
    navigationController?.pushViewController(detailVc, animated: true)
  }
  
  
  
}
