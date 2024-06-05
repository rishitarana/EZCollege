//
//  SelectCategoryCollectionViewCell.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 30/04/24.
//

import UIKit

class SelectCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productsLikeLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    var cornerRadius: CGFloat = 15.0

    override func awakeFromNib() {
        super.awakeFromNib()
        AddShadow(contentView: contentView, layer: layer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        AddRadius(layer: layer)
    }

}
