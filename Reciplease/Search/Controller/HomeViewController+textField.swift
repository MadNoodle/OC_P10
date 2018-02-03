//
//  HomeViewController+textField.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 23/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import UIKit

// /////////////////////////// //
// MARK: - UITextFieldDelegate //
// /////////////////////////// //

extension HomeViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    loadTextFromTextField()
    return (true)
  }
}
