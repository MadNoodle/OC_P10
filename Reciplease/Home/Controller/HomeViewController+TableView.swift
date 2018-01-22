//
//  HomeViewController+TableView.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 23/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import UIKit

// MARK: -  TableView Delegate methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ingredientList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Declare cell type
    let cell = ingrdientTable.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
    //load text from Array
    cell.textLabel?.text = " - \(ingredientList[indexPath.row])"
    cell.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    cell.textLabel?.font = UIFont(name: "Montserrat-Light.otf", size: 16.0)
    return cell
  }
}
