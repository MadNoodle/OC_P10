//
//  RecipeDisplayController+tableView.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 25/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

extension RecipeDisplayController: UITableViewDelegate, UITableViewDataSource, DisplayRecipeDelegate {
  

  // ////////////////////////// //
  // MARK: - TABLEVIEW DELEGATE //
  // ////////////////////////// //
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recipeResults.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = Bundle.main.loadNibNamed("RecipeCell", owner: self, options: nil)?.first as! RecipeCell

    cell.recipeName.text = recipeResults[indexPath.row].recipeName!
    cell.duration.text = recipeResults[indexPath.row].totalTime!

    let url = URL(string:recipeResults[indexPath.row].image!)
    let imageData:NSData = NSData(contentsOf: url!)!
    
    // sent on background queue to leave the time for the image to load
    // without slowing UI
    DispatchQueue.main.async {
      let image = UIImage(data: imageData as Data)
      cell.recipeImage.image = image
    }

    if let servings = recipeResults[indexPath.row].yield {
      cell.servings.text = servings
    }
    return cell
  }

  // Cell heigth
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 235
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // inject values
    // Send data to detail controller
    self.recipe = recipeResults[indexPath.row]
    let detailVc = Detail()
    detailVc.delegate = self
    // show detail controller
    navigationController?.pushViewController(detailVc, animated: true)
  }

  func didSelectARecipe() -> RecipeObject {
    return recipe!
  }
}

