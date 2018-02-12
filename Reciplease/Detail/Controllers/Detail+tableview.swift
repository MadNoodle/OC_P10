//
//  Detail+tableveiw.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 25/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

/// Handles tableView Delegation
extension Detail : UITableViewDelegate, UITableViewDataSource{
  
  // ////////////////////////////////// //
  // MARK: - TABLEVIEW PROTOCOL METHODS //
  // ////////////////////////////////// //
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ingredients.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = Bundle.main.loadNibNamed("IngredientCell", owner: self, options: nil)?.first as! IngredientCell
    cell.ingredientLabel.text = ingredients[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}
