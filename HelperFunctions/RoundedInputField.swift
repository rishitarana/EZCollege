//
//  RoundedInputField.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 01/05/24.
//

import Foundation
import UIKit

/// function to round an array of text fields
///
/// Parameter outlet: an array of text fields
func roundedInputField(outlet:[UITextField])
{
    for outletX in outlet
    {
        outletX.borderStyle = .none
        outletX.layer.cornerRadius = 12
        outletX.layer.masksToBounds = true
        outletX.layer.borderWidth = 0.5
        outletX.layer.borderColor = UIColor.purpleCardBackground.cgColor
        
        outletX.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: outletX.frame.height))
        outletX.leftViewMode = .always
    }
    
}
