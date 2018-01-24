//
//  DetailRecipeDelegate.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 23/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation

protocol DetailRecipeDelegate {
  var recipeName: String {get}
  var recipeImage: String {get}
  var ingredientsList: [String] {get}
  var totalTime: String {get}
  var servings: String {get}
}
