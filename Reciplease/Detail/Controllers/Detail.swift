//
//  Detail.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 23/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import CoreData

/// This controller handles the display of detailed recipes
class Detail: UIViewController {

  
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  /// delegate optionnal and should be check when called
  var delegate: DisplayRecipeDelegate?
  /// DetailRecipeDelegate property to receive data from display Controller
  var recipe : RecipeObject?
  /// Array to store ingredients
  var ingredients: [String] = []
  let cdManager = CoreDataManager()
  
  
  
  // /////////////// //
  // MARK: - OUTLETS //
  // /////////////// //
  
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var imageRecipe: UIImageView!
  @IBOutlet weak var ingredientsTableView: UITableView!
  @IBOutlet weak var servings: UILabel!
  @IBOutlet weak var duration: UILabel!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    receiveValueFromSearchResult()
    setNavBarFavImage()
    setupTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setNavBarFavImage()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    (UIApplication.shared.delegate as? AppDelegate)?.saveContext ()
    resetNavBar()
  }
  
  // ///////////////////////// //
  // MARK: - UPDATE UI METHODS //
  // ///////////////////////// //
  
  /// Instantiate nav Bar and customize appearance
  ///
  /// - Parameter imgName: favorite icon image
  private func setupNavBar(imgName: String){
    // sets background image to transparent by removing image and shadow
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    // sets tint color to white
    //self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9750739932, green: 0.9750967622, blue: 0.9750844836, alpha: 1)
    // favorite icon image. Uses .alwaysOriginal rendering to override tint color if favorite is true
    let rightButtonImage = UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal)
    //  create button whith callback function
    let shareImage = UIImage(named: "export.png")

    let item = UIBarButtonItem(image: rightButtonImage, style: .plain, target: self, action: #selector(self.setFavorite(sender:)))
    let shareItem = UIBarButtonItem(image: shareImage, style: .plain, target: self, action: #selector(self.share(sender:)))
    //instantiate right barButton in navBar
    self.navigationItem.rightBarButtonItems = [item,shareItem]
  }
  
  /// Check if the recipe is stored in core Data stack and display the right icon
  private func setNavBarFavImage() {
    if (cdManager.checkIfRecipeObjectIsStored(id: (recipe?.id!)!)) {
      setupNavBar(imgName: "ic_favorites_orange")
    } else {
      setupNavBar(imgName: "ic_notification")
    }
  }
  
  /// Methods that resets the navbar to initial paraameters when leaving controller
  private func resetNavBar(){
    //Set fonts for navbar title
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Montserrat-Bold", size: 22)!]
    //Set fonts for back Button
    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Montserrat-Bold", size: 15)!], for: UIControlState.normal)
    //Set font Color
    self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.5490196078, blue: 0.168627451, alpha: 1)
    // Remove shadow
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    
  }
  
  
  /// TableView instantiation methods
  private func setupTableView() {
    ingredientsTableView.delegate = self
    ingredientsTableView.register(IngredientCell.self, forCellReuseIdentifier: "ingredientCell")
    ingredientsTableView.reloadData()
  }
  
  
  /// Populate the view with reived data from delegate
  func receiveValueFromSearchResult() {
    // check if the delegate exists
    if delegate != nil {
      // inject values in recipes
      recipe = delegate?.didSelectARecipe()
      name.text = recipe?.recipeName
      duration.text = recipe?.totalTime
      servings.text = recipe?.yield
      // get ingredients and load them in tableView
      self.ingredients = (self.recipe?.ingredients)!
      // task to be done on background queue to do not slow UI display
      DispatchQueue.main.async {
      // get image Url from String
        if let url = URL(string:(self.recipe?.image)!)
      {
        //Get data from Url
        let imageData:NSData = NSData(contentsOf: url)!
          let image = UIImage(data: imageData as Data)
          self.imageRecipe.image = image
        
        }
      }
    }
  }
  
  // ////////////////////////////////////////////// //
  // MARK: - CALLBACK FUNCTION FOR FAVORITES BUTTON //
  // ////////////////////////////////////////////// //
  
  /// CallBack function for RigthButtonItem in Navbar
  ///
  /// - Parameter sender: Right NavBar item
  @objc func setFavorite(sender:UIBarButtonItem){
    // Checks if the unique id from Yummly appears in Stack
    if (cdManager.checkIfRecipeObjectIsStored(id: (recipe?.id!)!)) {
      recipe?.isFavorite = false
      cdManager.deleteItem(recipe!)
      sender.image = UIImage(named: "ic_notification")
    } else {
      recipe?.isFavorite = true
      cdManager.save(id: (recipe?.id)!, isFavorite: (recipe?.isFavorite)!, recipeName: (recipe?.recipeName)!, totalTime: recipe?.totalTime, yield: recipe?.yield, ingredients: (recipe?.ingredients)!, image: (recipe?.image)!, url: recipe?.url)
      sender.image = UIImage(named: "ic_favorites_orange")?.withRenderingMode(.alwaysOriginal)
    }
    do {
      try cdManager.managedObjectContext().save()
    } catch let error {
      print(error)
    }
  }
  
  /// Callback function for sharing a recipe
  ///
  /// - Parameter sender: shareButton
  @objc func share(sender:UIBarButtonItem){
    if recipe?.url != nil {
      let recipeUrl = recipe?.url
      let activityController = UIActivityViewController(activityItems: [recipeUrl!], applicationActivities: nil)
    present( activityController, animated: true, completion: nil )}
    else {
      showAlert(message: "Sorry you cannot share this recipe")
    }
  }
  
  /**
   Show alert when user try to do an invalid operation
   */
  func showAlert(message: String) {
    let alertVC = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    self.present(alertVC, animated: true, completion: nil)
  }
  
}
