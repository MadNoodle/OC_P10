//
//  IngredientCell.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 23/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

/// Custom Cell to display Ingredients in detailed Controller
class IngredientCell: UITableViewCell {
  
  @IBOutlet weak var ingredientLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
