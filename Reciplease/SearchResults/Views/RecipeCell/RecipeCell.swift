//
//  RecipeCell.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 21/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

  // MARK: - OUTLETS
  @IBOutlet weak var view: UIView!
  @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var duration: UILabel!
  @IBOutlet weak var servings: UILabel!

  // MARK: - LIFECYCLE METHODS
  override func awakeFromNib() {
        super.awakeFromNib()
    self.view.layer.cornerRadius = 10
    self.view.layer.shadowRadius = 5
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
