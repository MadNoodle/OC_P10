//
//  Constants.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 20/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation

struct Constants {
  
  
  // ///////////////////////////////// //
  // MARK: - Yummly REST API constants //
  // ///////////////////////////////// //

  /// Api key
  static let API_KEY = "909390fe0f7adcebf60f4dd394e6efd2"
  /// App id registered by Yummly
  static let APP_ID = "f3f41542"
  /// API identification String included in url request
  static let API_KEYS = "?_app_id=\(APP_ID)&_app_key=\(API_KEY)"
  /// Number of results
  static let NB_RESULT = "3"
  /// Base which you need to add your request parameters
  static let SEARCH_RECIPE_BASE_URL = "http://api.yummly.com/v1/api/recipes\(API_KEYS)&maxResult=\(NB_RESULT)&allowedIngredient[]="
  /// Base url to retrieve detailed recipe from yummli id
  static let GET_RECIPE_BASE_URL = "http://api.yummly.com/v1/api/recipe/"
}
