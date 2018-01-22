//
//  Extensions.swift
//  Reciplease
//
//  Created by Mathieu Janneau on 22/01/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarItem {
  /// This methods allows to hide title from tab Bar items
  func tabBarItemShowingOnlyImage()  {
    // offset to center
    self.imageInsets = UIEdgeInsets(top:6,left:0,bottom:-6,right:0)
    // displace to hide
    self.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 30000)
    
  }
}

extension UIImage {
  /// Creates an colored underline under TabBar item image
  ///
  /// - Parameters:
  ///   - color: UIColor of the line
  ///   - size: CGSize thickness of the line
  ///   - lineWidth: CGFloat width of the line
  /// - Returns: UIImage of the line
  func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(CGRect(origin: CGPoint(x: 0,y :size.height - lineWidth), size: CGSize(width: size.width, height: lineWidth)))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
}

