//
//  FavoriteRecipeController+fetchResultController.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 02/02/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import CoreData

/// This extension handles the autoUpdate of the tableView
extension FavoriteRecipeController: NSFetchedResultsControllerDelegate {
 
  ///
  func controllerWillChangeContent(_ controller:
    NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  ///
  func controllerDidChangeContent(_ controller:
    NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
}
