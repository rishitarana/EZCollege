//
//  HomeStandartProductCollectionViewCell.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 30/04/24.
//

import UIKit

class HomeStandartProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var likedButton: UIButton!
    @IBOutlet weak var prodCondition: UILabel!
    @IBOutlet weak var prodPrice: UILabel!
    @IBOutlet weak var prodTitle: UILabel!
    @IBOutlet weak var prodImg: UIImageView!
    
    static let reuseIdentifier = "standardCell"
    
    /// product variable - used to fire the configureCell method on setting
    var product: Product? {
        didSet{
            configureCell()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        prodImg.image = nil
        prodPrice.text = nil
        prodCondition.text = nil
        prodTitle.text = nil
        likedButton.setImage(nil, for: .normal)
    }
    
    
    
    /// configureCell() method to update th cell ui
    func configureCell(){
        if let product = product{
            Task{
                do{
                    let capturedProduct = product // Capture the product locally
                    let image = try await renderImageFromUrl(from: URL(string: product.productImages[0])!)
                    DispatchQueue.main.async{
                        if self.product == capturedProduct {
                            self.prodImg.image = image
                        }
                    }
                }catch{}
            }
            prodPrice.text = "\u{20B9}\(product.price)"
            prodCondition.text = product.condition.rawValue
            prodTitle.text = product.name
            
            AddRadius(layer: prodImg.layer)
            
            let isLiked = user.isLikedProduct(with: product)
            
            
            
            likedButton.layer.borderColor = UIColor.systemRed.cgColor
            likedButton.layer.borderWidth = 1
            likedButton.layer.cornerRadius = likedButton.frame.width/2
            
            if isLiked {
                likedButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }else{
                likedButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
        
    }
    
    
    /// function to implement the liking and disliking of the product
    @IBAction func likedBtnPressed(_ sender: UIButton) {
        if let product = product{
            let isLiked = user.isLikedProduct(with: product)
            
            if isLiked {
                likedButton.setImage(UIImage(systemName: "heart"), for: .normal)
                user.deleteProductFromLiked(for: product)
            }else{
                likedButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                user.addProductToLiked(with: product)
            }
            
            /// posting notifications to the ViewControllers to refresh their data after some modification has been done
            NotificationCenter.default.post(name: NSNotification.Name("dataChanged"), object: nil)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        AddRadius(layer: layer)
    }
}
