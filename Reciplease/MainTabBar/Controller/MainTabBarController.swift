//
//  MainTabBarController.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 22/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import CoreData


/// Protocol to pass CurrentUser throught Controllers
protocol userLoggedDelegate {
  /// Current User
  func CurrentUser() -> User
}






/**
 This class handles the main tab bar inititailization and behaviours
 */
class MainTabBarController: UITabBarController, userLoggedDelegate {
  
  
  /// Delegation Method
  func CurrentUser() -> User {
    return userLogged!
  }
 
  // ///////////////////// //
  // MARK: - PROPERTIES    //
  // ///////////////////// //
  
  
 /// Instantiate CoreDataManager
  let cdManager = CoreDataManager()
  /// Array to store recipes
  var favRecipes : [String] = []
  ///  Current logged user fetched from User Defaults
  var userLogged : User?
  
  // //////////////////////////// //
  // MARK: - LIFECYCLE METHODS    //
  // //////////////////////////// //
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabBar()
    // set tabBar Selected color
    UITabBar.appearance().tintColor = #colorLiteral(red: 1, green: 0.5490196078, blue: 0.168627451, alpha: 1)
    // Set tabBar background Color
    UITabBar.appearance().barTintColor = UIColor.white
    // Create highligth line under icon when selected
    tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: #colorLiteral(red: 1, green: 0.5490196078, blue: 0.168627451, alpha: 1), size: CGSize(width: (tabBar.frame.width/CGFloat(tabBar.items!.count)) / 3, height: tabBar.frame.height), lineWidth: 4.0)
  }
  
  
  
  /// Todo: A Refactor dans model
  private func getCurrentUser() {
    // initialize userDefaults
    let defaults = UserDefaults.standard
    // grab user's email
    let user = defaults.string(forKey: "currentUser")
    
    if user != nil {
      print("LOGGED :\(user!)")
      // fetch user from Core Data
      userLogged = cdManager.fetchUser(email: user!)
      cdManager.printRecipesFor(userLogged!)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setupTabBar()
    getCurrentUser()
   
  }
  
  // //////////////////////////// //
  // MARK: - TABBAR INSTANTIATION //
  // //////////////////////////// //
  
  /**
   Create programatically tab bar.
   */
  private func setupTabBar() {
    //Initialization of controllers
    let homeVc = HomeViewController()
    favRecipes = cdManager.loadData()
    let favoriteVc = FavoriteRecipeController()
    favoriteVc.delegate = self
    homeVc.delegate = self
    // Assign controllers to tab bar
    viewControllers = [
      createTabBarItem("Home", imageName: "ic_home", for: homeVc),
      createTabBarItem("Favorite", imageName: "ic_favorites_grey", for: favoriteVc),
    ]
  }
  

  /// This method initialize tabBar item and insert them in a navigationController
  ///
  /// - Parameters:
  ///   - title: String title of item
  ///   - imageName: String name of the image in xcassets
  ///   - controller: UIViewController Controller targeted by item
  /// - Returns: NavigationController that encapsulate the Controllers
  func createTabBarItem(_ title: String, imageName: String, for controller : UIViewController) -> UINavigationController{
    let navController = UINavigationController(rootViewController: controller)
    // Set title
    navController.tabBarItem.title = title
    //Set fonts for navbar title
    navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Montserrat-Bold", size: 22)!]
    //Set fonts for back Button
     UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Montserrat-Bold", size: 15)!], for: UIControlState.normal)
    navController.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.5490196078, blue: 0.168627451, alpha: 1)
    // Hide titles in tab bar
    navController.tabBarItem.tabBarItemShowingOnlyImage()
    //Set icon for tab bar
    navController.tabBarItem.image = UIImage(named: imageName)
    return navController
  }
}

