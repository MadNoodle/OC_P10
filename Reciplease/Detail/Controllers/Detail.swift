//
//  Detail.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 23/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

class Detail: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var ingredients: [String] = []
  var delegate: DetailRecipeDelegate?
  // MARK: - OUTLETS
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var imageRecipe: UIImageView!
  @IBOutlet weak var ingredientsTableView: UITableView!
  @IBOutlet weak var servings: UILabel!
  @IBOutlet weak var duration: UILabel!
  
  // MARK: - LIFECYCLE METHODS
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    ingredientsTableView.delegate = self
    setupNavBar()
    receiveValueFromSearchResult()
    ingredientsTableView.register(IngredientCell.self, forCellReuseIdentifier: "ingredientCell")
    ingredientsTableView.reloadData()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    resetNavBar()
  }
  
  // MARK: - UPDATE UI METHODS
  func setupNavBar(){
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9750739932, green: 0.9750967622, blue: 0.9750844836, alpha: 1)
    let rightButtonImage = UIImage(named: "ic_favorites_grey")
    let item = UIBarButtonItem(image: rightButtonImage, style: .plain, target: self, action: nil)
    // Todo Make a callback function rigthNavItem button
    self.navigationItem.setRightBarButton(item, animated: false)
  }
  func resetNavBar(){
    //Set fonts for navbar title
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Montserrat-Bold", size: 22)!]
    //Set fonts for back Button
    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Montserrat-Bold", size: 15)!], for: UIControlState.normal)
    self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.5490196078, blue: 0.168627451, alpha: 1)
  }
  
  func receiveValueFromSearchResult() {
    if delegate != nil {
      name.text = delegate?.recipeName
      // image
      let url = URL(string:(delegate?.recipeImage)!)
      let imageData:NSData = NSData(contentsOf: url!)!
      self.ingredients = (self.delegate?.ingredientsList)!
      DispatchQueue.main.async {
        let image = UIImage(data: imageData as Data)
        self.imageRecipe.image = image
        
      }
      duration.text = delegate?.totalTime
      servings.text = delegate?.servings
    }
    
  }
  
  // MARK: - TABLEVIEW PROTOCOL METHODS
  // a refactor dans une extension
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ingredients.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = Bundle.main.loadNibNamed("IngredientCell", owner: self, options: nil)?.first as! IngredientCell
    cell.ingredientLabel.text = ingredients[indexPath.row]
    return cell
  }
  
 func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}
