//
//  HomeViewController+TableView.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 23/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import UIKit

/// this extension handles the tableView delegate methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Declare cell type
    let cell = ingredientTable.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
    //load text from Array
    cell.textLabel?.text = " - \(list[indexPath.row])"
    //Set background color
    cell.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    // Set font
    cell.textLabel?.font = UIFont(name: "Montserrat-Light.otf", size: 16.0)
    return cell
  }
}
