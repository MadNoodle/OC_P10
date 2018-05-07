//
//  RecipeApiManager.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 20/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

/**
 Handles all communication with Yummly REST API.
 Constants such as API Key, urls, API id are stored in Constants.
 You can find the documentation here : https://developer.yummly.com/documentation
 */
class RecipeApiManager {
  
  /// Takes the ingredient list array and create the end point string fro FetchRequest
  ///
  /// - Parameter list: [String]
  /// - Returns: String encoded urlFriendly
  static func splitIngredients(list: [String]) -> String {
    var ingredients: String = ""
    ingredients = list.joined(separator: Constants.ADD_INGREDIENTS)
    return ingredients
  }
  
  /**
   This method fetch a list of # recipe # id on Yummly according to ingredients it contains.
   - parameters:
   - ingredients: String. Ingredients the user which to search for
   */
  static func searchRecipe(with ingredients: String, completion: @escaping(_ results: [String], _ error: Error?) -> Void) {
    print(ingredients)
    // transcode parameters to url
    
    let url = Constants.SEARCH_RECIPE_BASE_URL + ingredients
    
    // send request on background queue
    DispatchQueue.main.async {
      //Connect to the REST API
      Alamofire.request(url).validate().responseJSON(completionHandler: { response in
        // Array to store results and send them back on main queue to be displayed
        var recipeIds: [String] = []
        
        // Connexion succesful
        switch response.result {
        case .success:
          //print("Validation Successful")
          // Parse Results
          Alamofire.request(url).responseJSON { (response) in
            
            if let result = response.result.value as? [String: Any] {
              if let matches = result["matches"] as? [[String: Any]] {
                for match in matches {
                  // Parsed ids
                  let recipeId = match["id"] as? String
                  // store them in container
                  recipeIds.append(recipeId!)
                  // get recipe for all ids matching the search
                  
                }
                completion(recipeIds, nil)
              }
            }
            
          }
        // Connexion error
        case .failure(let error):

          print("error: \(error.localizedDescription)")
          // send back an error to trigger an alert
          completion( [], error)
        }
      })
    }
    
  }
  
  /**
   This method take a recipe id and returns a recipe object that can be displayed in table view or in details
   */
  static func getRecipe(_ ids: [String], completion: @escaping(_ result: [RecipeObject]?, _ error: Error?) -> Void) {
    
    /// Create container for object to return
    var recipes: [RecipeObject] = []
    
    for id in ids {
      /// Create url to fetch recipe from id on Yummly API
      let url = Constants.GET_RECIPE_BASE_URL + id + Constants.API_KEYS
      
      // send tack on background
      DispatchQueue.main.async {
        //Connect to the REST API
        Alamofire.request(url).validate().responseJSON(completionHandler: { response in
          // Connexion succesful
          switch response.result {
          case .success:
            //print("Validation Successful")
            // Parse Results
            Alamofire.request(url).responseJSON { (response) in
              if let result = response.result.value as? [String: Any] {
                
                let recipe = RecipeObject(recipeDictionnary: result)
                recipes.append(recipe)
                
              }
              // return recipe + no error
              completion(recipes, nil)
            }
          // Connexion error
          case .failure(let error):
            print("error: \(error.localizedDescription)")
            // send back an error to trigger an alert
            completion([], error)
          }
        })
      }
      
    }
  }
  
}
