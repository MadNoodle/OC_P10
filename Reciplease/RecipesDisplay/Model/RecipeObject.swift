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
  var isFavorite: Bool = false
  let id: String?
  let recipeName: String?
  let image: String?
  let ingredients: [String]?
  let totalTime: String?
  let yield: String?
  let url: String?

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


