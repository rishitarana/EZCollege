//
//  RoundedBorder.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 07/05/24.
//

import Foundation
import UIKit

/// function to round a layer
///
/// Parameter layer: CALayer, the layer of the component generally component.layer
/// Paramter height: CGFloat, the height of the component
func roundedBorder(layer: CALayer, height: CGFloat){
    layer.cornerRadius = height / 2
    layer.borderWidth = 0.5
    layer.borderColor = UIColor.systemGray3.cgColor
}
