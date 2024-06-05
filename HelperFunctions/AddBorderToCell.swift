//
//  AddBorderToCell.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 07/05/24.
//

import Foundation
import UIKit

/// function to set the top border of a TableViewCell
///
/// - Parameter cell: an array of tableView cells a user wants to add a top border to
func addTopBorder(to cell: [UITableViewCell])
{
    for item in cell{
        var topBorderLayer = CALayer()
        topBorderLayer.backgroundColor = UIColor.placeholderText.cgColor // Set your desired color
        
        let cellWidth = item.contentView.frame.width
        let lineWidth = cellWidth * 0.9 // Set line width to 75% of cell width
        let xOffset = (cellWidth - lineWidth) / 2 // Center the line horizontally
        
        topBorderLayer.frame = CGRect(x: xOffset, y: 0, width: lineWidth, height: 0.5)
        item.contentView.layer.addSublayer(topBorderLayer)
    }
    
}

/// function to set the bottom border of a TableViewCell
///
/// - Parameter cell: an array of tableView cells a user wants to add a bottom border to
func addBottomBorder(to cell: [UITableViewCell])
{
    for item in cell
    {
        var bottomBorderLayer = CALayer()
        bottomBorderLayer.backgroundColor = UIColor.placeholderText.cgColor // Set your desired color

        let cellWidth = item.contentView.frame.width
        let lineWidth = cellWidth * 0.9 // Set line width to 75% of cell width
        let xOffset = (cellWidth - lineWidth) / 2 // Center the line horizontally
        
        bottomBorderLayer.frame = CGRect(x: xOffset, y: item.contentView.frame.height - 1, width: lineWidth, height: 0.5)
        item.contentView.layer.addSublayer(bottomBorderLayer)
    }
}
