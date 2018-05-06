//
//  LoginCoordinator.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 09/02/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import ILLoginKit
import UIKit

class LoginCoordinator: ILLoginKit.LoginCoordinator {
 
  // /////////////////// //
  // MARK: - PROPERTIES  //
  // /////////////////// //
  
  /// instance of User Manager to connect to the model
  let userManager = CoreDataManager()

  override func start(animated: Bool = true) {
    super.start()
    configureAppearance()
  }
  
  override func finish(animated: Bool = true) {
    super.finish()
  }
  
  /// Customize LoginKit. All properties have defaults, only set the ones you want.
  func configureAppearance() {
    // Customize the look with background & logo images
    configuration.backgroundImage = UIImage(named: Config.loginBackground)!
      // Change colors
    configuration.tintColor = Config.loginColor
   configuration.errorTintColor =
    Config.errorColor
    // Change placeholder & button texts, useful for different marketing style or language.
    configuration.loginButtonText = Config.signInString
    configuration.signupButtonText =  Config.signUpString
    configuration.facebookButtonText = Config.facebookLoginString
    configuration.forgotPasswordButtonText = Config.forgotPassworwordString
    configuration.recoverPasswordButtonText = Config.recoverString
    configuration.namePlaceholder = Config.nameString
    configuration.emailPlaceholder = Config.emailString
    configuration.passwordPlaceholder = Config.passwordString
    configuration.repeatPasswordPlaceholder =  Config.confirmString
  }
  
  // ////////////////////////// //
  // MARK: - LOGIN POST ACTIONS //
  // ////////////////////////// //
  
  /// Handle login
  override func login(email: String, password: String) {
    //print("Login with: email =\(email) password = \(password)")
    if userManager.logInUser(email: email, password: password) {
      userManager.setLoggedUser(email: email)
    }
  }
  
  /// Handle signup 
 override func signup(name: String, email: String, password: String) {

    if userManager.checkExistingUsers(email: email) {
      print("This user already exists")
    } else {
      userManager.createUser(name: name, email: email, password: password)
    }
  }
  
  /// Handle Facebook login/signup
  override func enterWithFacebook(profile: FacebookProfile) {
   // print("Login/Signup via Facebook with: FB profile =\(profile)")
    let name = "\(profile.fullName)"
    let email = profile.email
    let password = profile.facebookId
    if userManager.checkExistingUsers(email: email) {
      userManager.setLoggedUser(email: profile.email)
      presentTabBarController()
    } else {
      userManager.createUser(name: name, email: email, password: password)
      presentTabBarController()
    }
  }
  
  /// Handle password recovery
  override func recoverPassword(email: String) {
    print("Recover password with: email =\(email)")
  }
  
  /// Present Tab Bar Controller by re assigning RootViewController.
  /// This prevent from separate hierarchy
  func presentTabBarController() {
    let tabVc = MainTabBarController()
    let appDelegate = UIApplication.shared.delegate
    appDelegate?.window!?.rootViewController = tabVc
  }

}
