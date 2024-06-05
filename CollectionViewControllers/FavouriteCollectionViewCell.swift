//
//  FavouriteCollectionViewCell.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 28/04/24.
//

import UIKit

class FavouriteCollectionViewCell: UICollectionViewCell {
    /// Outlets for controller properties
    @IBOutlet weak var favImg: UIImageView!
    @IBOutlet weak var favProductPrice: UILabel!
    @IBOutlet weak var favProductName: UILabel!
    @IBOutlet weak var likeBtn: UIButton!

    /// product variable - on setting the configureCell() is fired
    var product: Product? {
        didSet{
            configureCell()
        }
    }
    
    /// functionality to implement the liking and disliking the current shown product
    @IBAction func likeBtnPressed(_ sender: UIButton) {
        if let prod = product {
            user.deleteProductFromLiked(for: prod)
        }
        NotificationCenter.default.post(name: NSNotification.Name("dataChanged"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("userPreferenceChanged"), object: nil)
    }
    
    var cornerRadius: CGFloat = 15.0

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        AddRadius(layer: layer)
        AddRadius(layer: favImg.layer)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        favImg.image = nil
        favProductName.text = nil
        favProductPrice.text = nil
        likeBtn.setImage(nil, for: .normal)
    }


    /// Function to configure the individual cell
    func configureCell(){
        if let product = product{
            favProductName.text = product.name
            favProductPrice.text = "\u{20B9} \(product.price)"
            Task{
                do{
                    let capturedProduct = product // Capture the product locally
                    let image = try await renderImageFromUrl(from: URL(string: product.productImages[0])!)
                    DispatchQueue.main.async{
                        if self.product == capturedProduct {
                            self.favImg.image = image
                        }
                    }
                }catch{}
            }
            favImg.layer.cornerRadius = 8
            
            let isLiked = user.isLikedProduct(with: product)
            
            if isLiked {
                likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
    }
}
