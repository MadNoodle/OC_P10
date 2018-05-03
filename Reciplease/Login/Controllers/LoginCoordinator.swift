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

  override func start(animated: Bool = true){
    super.start()
    configureAppearance()
  }
  
  override func finish(animated: Bool = true) {
    super.finish()
  }
  
  /// Customize LoginKit. All properties have defaults, only set the ones you want.
  func configureAppearance() {
    // Customize the look with background & logo images
    configuration.backgroundImage =  #imageLiteral(resourceName: "splash")
      // Change colors
    configuration.tintColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1)
   configuration.errorTintColor = UIColor(red: 253.0/255.0, green: 227.0/255.0, blue: 167.0/255.0, alpha: 1)
    
    // Change placeholder & button texts, useful for different marketing style or language.
    configuration.loginButtonText = "Sign In"
    configuration.signupButtonText = "Create Account"
    configuration.facebookButtonText = "Login with Facebook"
    configuration.forgotPasswordButtonText = "Forgot password?"
    configuration.recoverPasswordButtonText = "Recover"
    configuration.namePlaceholder = "Name"
    configuration.emailPlaceholder = "E-Mail"
    configuration.passwordPlaceholder = "Password!"
    configuration.repeatPasswordPlaceholder = "Confirm password!"
  }
  
  // ////////////////////////// //
  // MARK: - LOGIN POST ACTIONS //
  // ////////////////////////// //
  
  /// Handle login
  override func login(email: String, password: String) {
    //print("Login with: email =\(email) password = \(password)")
    if userManager.logInUser(email: email, password: password){
      userManager.setLoggedUser(email: email)
    }
  }
  
  /// Handle signup 
 override func signup(name: String, email: String, password: String) {
   // print("Signup with: name = \(name) email =\(email) password = \(password)")
    if userManager.checkExistingUsers(email: email){
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
    if userManager.checkExistingUsers(email: email){
      print("user exists")
      userManager.setLoggedUser(email: profile.email)
      presentTabBarController()
    }
    else {
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
  func presentTabBarController(){
    let tabVc = MainTabBarController()
    let appDelegate = UIApplication.shared.delegate
    appDelegate?.window!?.rootViewController = tabVc
  }

}
