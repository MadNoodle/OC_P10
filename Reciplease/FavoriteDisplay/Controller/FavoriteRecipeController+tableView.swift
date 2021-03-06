//
//  FavoriteRecipeController+extensions.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 02/02/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

/// This extensions handles tableView Delegation and send recipe to another controller
extension FavoriteRecipeController: DisplayRecipeDelegate {

// ////////////////////////////// //
// MARK: - Table view data source //
// ////////////////////////////// //
  
override func numberOfSections(in tableView: UITableView) -> Int {
  return 1
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  guard let count = fetchedResultController.sections?[0].numberOfObjects else { return 0}

    return count
  
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cell = Bundle.main.loadNibNamed("RecipeCell", owner: self, options: nil)?.first as? RecipeCell
  
     // fetch data from fetchResultController to autoUpdate
    let favorite = self.fetchedResultController.object(at: indexPath) 
   
    // populate cells
  cell?.recipeName?.text =  favorite.recipeName
    cell?.duration?.text = favorite.totalTime
    cell?.servings?.text = favorite.yield
    if let url = URL(string: favorite.image!) {
      let imageData: NSData = NSData(contentsOf: url)!
      
      DispatchQueue.main.async {
        let image = UIImage(data: imageData as Data)
        cell?.recipeImage?.image = image
      }}
  return cell!
}
  
override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  return 235
}
  
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  // Send data to detail controller
  let favoriteRecipe = self.fetchedResultController.object(at: indexPath)
  //Convert Recipe to recipeObject
  recipe = userManager.convertRecipeToObject(recipe: favoriteRecipe)
  
  // pass data thorught delegation
  let favoriteDetailVc = Detail()
  favoriteDetailVc.delegate = self
  // show detail controller
  navigationController?.pushViewController(favoriteDetailVc, animated: true)
}
  
  // /////////////////////////////////////// //
  // MARK: - SEND RECIPE TO DETAIL DELEGATION//
  // /////////////////////////////////////// //
  
  func didSelectARecipe() -> RecipeObject {
    return recipe!
  }
}
