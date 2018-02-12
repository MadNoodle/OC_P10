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
 
  
  let mainVc = MainTabBarController()
  let cdManager = CoreDataManager()

  override func start(){
    super.start()
    configureAppearance()
  }
  
  override func finish() {
    super.finish()
    
  }
  
  // Customize LoginKit. All properties have defaults, only set the ones you want.
  func configureAppearance() {
    // Customize the look with background & logo images
    backgroundImage =  #imageLiteral(resourceName: "splash")
//      mainLogoImage =
//      secondaryLogoImage =
    
      // Change colors
    tintColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1)
    errorTintColor = UIColor(red: 253.0/255.0, green: 227.0/255.0, blue: 167.0/255.0, alpha: 1)
    
    // Change placeholder & button texts, useful for different marketing style or language.
    loginButtonText = "Sign In"
    signupButtonText = "Create Account"
    facebookButtonText = "Login with Facebook"
    forgotPasswordButtonText = "Forgot password?"
    recoverPasswordButtonText = "Recover"
    namePlaceholder = "Name"
    emailPlaceholder = "E-Mail"
    passwordPlaceholder = "Password!"
    repeatPasswordPlaceholder = "Confirm password!"
  }
  // Handle login via your API
  override func login(email: String, password: String) {
    print("Login with: email =\(email) password = \(password)")
    if cdManager.logInUser(email: email, password: password){
      setLoggedUser(email: email)
      presentTabBarController()
    }
  }
  
  // Handle signup via your API
  override func signup(name: String, email: String, password: String) {
   // print("Signup with: name = \(name) email =\(email) password = \(password)")
    if cdManager.checkExistingUsers(email: email){
      print("This user already exists")
    } else {
      cdManager.createUser(name: name, email: email, password: password)
      setLoggedUser(email: email)
      presentTabBarController()
      
    }
  }
  
  // Handle Facebook login/signup via your API
  override func enterWithFacebook(profile: FacebookProfile) {
    print("Login/Signup via Facebook with: FB profile =\(profile)")
    // a refactor
    let name = "\(profile.fullName)"
    setLoggedUser(email: profile.email)
    let email = profile.email
    let id = profile.facebookId
    if cdManager.checkExistingUsers(email: email){print("user exists") }
    else {
      cdManager.createUser(name: name, email: email, password: id)}
    setLoggedUser(email: email)
    presentTabBarController()
  }
  
  // Handle password recovery via your API
  override func recoverPassword(email: String) {
    print("Recover password with: email =\(email)")
  }
  
  func presentTabBarController(){
    
    let tabVc = MainTabBarController()
    let appDelegate = UIApplication.shared.delegate
    appDelegate?.window!?.rootViewController = tabVc
  }
  
  func setLoggedUser(email:String){
    let defaults = UserDefaults.standard
   
    defaults.set(email, forKey: "currentUser")
    
  }


}
