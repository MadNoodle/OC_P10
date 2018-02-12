//
//  LoginViewController.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 09/02/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import ILLoginKit

class LoginViewController: UIViewController {
  
  // /////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
  /// Initialization login coordinator cf ILLoginKit
  lazy var loginCoordinator: LoginCoordinator = {
    return LoginCoordinator(rootViewController: self)
  }()
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
  override func viewDidAppear(_ animated: Bool) {
    showLogin()
  }
  
  // /////////////////// //
  // MARK: - METHODS //
  // ////////////////// //
  
  func showLogin() {
    loginCoordinator.start()
  }

 
}
