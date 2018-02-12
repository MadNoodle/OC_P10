//
//  RecipeObject.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 20/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation


/// Class tha create an object from data fetched from RecipeAPIManager
class RecipeObject {
  /// set if the recipe is a user's favorite
  var isFavorite: Bool = false
  /// Recipe id String used to fetch recipe via Yummluy API
  let id: String?
  /// Recipe Name
  let recipeName: String?
  /// Recipe thumbnail image url
  let image: String?
  /// List of ingredietns and portions
  let ingredients: [String]?
  /// Duration of recipe preparation
  let totalTime: String?
  /// number of servings
  let yield: String?
  /// url for the original recipe
  let url: String?

  /// initialization method
  ///
  /// - Parameter recipeDictionnary: [String : Any]
  init(recipeDictionnary: [String:Any]){
    self.id = recipeDictionnary["id"] as? String
    self.recipeName = recipeDictionnary["name"] as? String
    var smallImage = ""
    if let imagesUrl = recipeDictionnary["images"] as? [[String:Any]]{
      smallImage = (imagesUrl[0]["hostedLargeUrl"] as? String)!}
    self.image = smallImage
    self.ingredients = recipeDictionnary["ingredientLines"] as? [String]
    self.totalTime = recipeDictionnary["totalTime"] as? String
    self.yield = recipeDictionnary["yield"] as? String
    let source = recipeDictionnary["source"] as? [String:Any]
    self.url = source?["sourceRecipeUrl"] as? String
  }

}


