//
//  UserLoggedDelegate.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 12/02/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation

/// Protocol to pass CurrentUser throught Controllers
protocol userLoggedDelegate: class {
  ///
  /// Current User
  ///
  /// - Returns: User
  func CurrentUser() -> User
}
