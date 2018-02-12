//
//  RecipeCell.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 21/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
@IBDesignable // to have a real time feedback in preview

/// Custom cell for Result Display tableViews
class RecipeCell: UITableViewCell {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  @IBInspectable var cornerRadius: CGFloat = 20
  
  // /////////////// //
  // MARK: - OUTLETS //
  // /////////////// //
  
  /// Container for informations. Used to create a separate background color
  @IBOutlet weak var container: UIView!
  /// Recipe thumbnail
  @IBOutlet weak var recipeImage: UIImageView!
  /// Recipe Name
  @IBOutlet weak var recipeName: UILabel!
  /// Recipe preparation time
  @IBOutlet weak var duration: UILabel!
  /// Number of servings
  @IBOutlet weak var servings: UILabel!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.container.layer.cornerRadius = cornerRadius
    self.container.layer.masksToBounds = true
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
