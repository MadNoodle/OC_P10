//
//  RecipeDisplayController+tableView.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 25/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

/// extensions that handles tableView behavior and delegations, Display Recipe Delegations
extension RecipeDisplayController: UITableViewDelegate, UITableViewDataSource, DisplayRecipeDelegate {
  
  // ////////////////////////// //
  // MARK: - TABLEVIEW DELEGATE //
  // ////////////////////////// //
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recipeResults.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = Bundle.main.loadNibNamed("RecipeCell", owner: self, options: nil)?.first as? RecipeCell

    if let recipeTitle = recipeResults[indexPath.row].recipeName {
      cell?.recipeName.text = recipeTitle
      
    }
    if let duration = recipeResults[indexPath.row].totalTime {
      cell?.duration.text = duration
    }

    if let url = URL(string: recipeResults[indexPath.row].image!) {
      let imageData: NSData = NSData(contentsOf: url)!
    
    // sent on background queue to leave the time for the image to load
    // without slowing UI
    DispatchQueue.main.async {
      let image = UIImage(data: imageData as Data)
      cell?.recipeImage.image = image
    }}

    if let servings = recipeResults[indexPath.row].yield {
      cell?.servings.text = servings
    }
    return cell!
  }

  /// Cell heigth defining Methods
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 235
  }
  
  /// Defines behavior when cell is selected
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // inject values
    self.recipe = recipeResults[indexPath.row]
    // instantiate target controller
    let detailVc = Detail()
    // send recipe delegation
    detailVc.delegate = self
    // send logged user delegation
    detailVc.userDelegate = self
    // show detail controller
    navigationController?.pushViewController(detailVc, animated: true)
  }

  // //////////////////////////// //
  // MARK: - DELEGATION METHODS   //
  // //////////////////////////// //
  
  /// Sends recipe to detail View
  ///
  /// - Returns: Recipe
  func didSelectARecipe() -> RecipeObject {
    return recipe!
  }
}
