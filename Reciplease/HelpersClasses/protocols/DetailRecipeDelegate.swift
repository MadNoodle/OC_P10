//
//  DetailRecipeDelegate.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 23/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation

/// Passes Recipe data to another controller
protocol  DisplayRecipeDelegate {
  
  /// passes recipe
  ///
  /// - Returns: RecipeObject
  func didSelectARecipe() -> RecipeObject
}




