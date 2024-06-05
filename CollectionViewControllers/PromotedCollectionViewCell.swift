//
//  PromotedCollectionViewCell.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 06/05/24.
//

import UIKit

class PromotedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var promotedImage: UIImageView!
    
    /// product variable to fire the configureCell funtion wehenver it is set
    var product: Product? {
        didSet{
           configureCell()
        }
    }
    
    var width: CGFloat = 0
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        promotedImage.image = nil
        categoryBtn.setImage(nil, for: .normal)
    }


    /// configureCell() function used to update the cell contents
    func configureCell(){
        if let product = product{
            Task{
                do{
                    let capturedProduct = product // Capture the product locally
                    let image = try await renderImageFromUrl(from: URL(string: product.productImages[0])!)
                    DispatchQueue.main.async{
                        if self.product == capturedProduct {
                            self.promotedImage.image = image
                        }
                    }
                }catch{}
            }
            
            AddRadius(layer: promotedImage.layer)
            
            let config = UIImage.SymbolConfiguration(scale: .medium)
            
            roundedBorder(layer: categoryBtn.layer, height: categoryBtn.frame.height)
            categoryBtn.setImage(UIImage(systemName: product.category.icon, withConfiguration: config), for: .normal)
        }
        
    }
    
    override func layoutSubviews() {
    }
}

