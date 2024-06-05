//
//  ViewShadow.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 02/05/24.
//

import Foundation
import UIKit

var cornerRadius: CGFloat = 15

//Add a rounded shadow
func AddShadow(contentView: UIView, layer: CALayer){
    contentView.layer.cornerRadius = cornerRadius
    contentView.layer.masksToBounds = true
    
    layer.cornerRadius = cornerRadius
    layer.masksToBounds = false
    
    layer.shadowRadius = 4.0
    layer.shadowOpacity = 0.20
    layer.shadowColor = UIColor(named: "customPurple")?.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 0)
}
