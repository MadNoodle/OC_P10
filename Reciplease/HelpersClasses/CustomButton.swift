//
//  CustomButton.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 22/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

@IBDesignable

/// Custom button
class CustomButton: UIButton {
  
  /// Button fill color
  @IBInspectable var fillColor: UIColor = #colorLiteral(red: 1, green: 0.5490196078, blue: 0.168627451, alpha: 1)
  
  /// Button cornerRadius
  @IBInspectable var cornerRadius: CGFloat = 0
  
  /// Button contour stroke color
  @IBInspectable var lineColor: UIColor = #colorLiteral(red: 0.08862503618, green: 0.08862821013, blue: 0.08862651139, alpha: 1)
  /// Button contour stroke weight
  @IBInspectable var lineWeigth: CGFloat = 1
  
  override func draw(_ rect: CGRect) {
    layer.cornerRadius = cornerRadius
    layer.backgroundColor = fillColor.cgColor
    layer.borderColor = lineColor.cgColor
    layer.borderWidth = lineWeigth
  }
  
}
