//
//  BaseCollectionViewCell.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 26/04/24.
//

import UIKit

/// Listing view controller cell
class BaseCollectionViewCell: UICollectionViewCell {

    // property outlets
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var prodCategory: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var askPriceLabel: UILabel!
    
    /// 'product' variable - set to configure the cell
    var product: Product?{
        didSet{
            configureCell()
        }
    }

    var isExpired: Bool?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productImg.image = nil
        productNameLabel.text = nil
        prodCategory.text = nil
        conditionLabel.text = nil
        askPriceLabel.text = nil
        menuBtn.setImage(nil, for: .normal)
    }

    
    /// Configures the cell with product data
    func configureCell(){
        if let product = product{
            productNameLabel.text = product.name
            conditionLabel.text = product.condition.rawValue
            askPriceLabel.text = "\u{20B9} \(String(product.price))"
            Task{
                do{
                    let capturedProduct = product
                    let image = try await renderImageFromUrl(from: URL(string: product.productImages[0])!)
                    DispatchQueue.main.async{
                        if product == capturedProduct{
                            self.productImg.image = image
                        }
                    }
                }catch{}
            }
            prodCategory.text = product.category.title
        }
    }
    
    /// Adds a UIMenu to the menu button
    ///
    /// Provides the menu for performing varioud functions on the Listings done by the user
    func AddMenu() -> UIMenu{
        var menuItems: UIMenu?
        if let isExpired = isExpired, isExpired{
            menuItems = UIMenu(title: "", options: .displayInline, children: [
               UIAction(title: "Re-list",image: UIImage(systemName: "gobackward"), handler: {(_) in
                   user.relist(with: self.product!.id)
                   NotificationCenter.default.post(name: Notification.Name("productAdded"), object: nil)
                   NotificationCenter.default.post(name: Notification.Name("userPreferenceChanged"), object: nil)
                   NotificationCenter.default.post(name: Notification.Name("dataChanged"), object: nil)
               }),UIAction(title: "Delete",image: UIImage(systemName: "trash"),attributes: .destructive, handler: {(_) in
                   user.deleteListing(with: self.product!)
                   NotificationCenter.default.post(name: Notification.Name("productAdded"), object: nil)
                   NotificationCenter.default.post(name: Notification.Name("userPreferenceChanged"), object: nil)
                   NotificationCenter.default.post(name: Notification.Name("dataChanged"), object: nil)
               })
           ])
        }else{
            menuItems = UIMenu(title: "", options: .displayInline, children: [
                UIAction(title: "Delete",image: UIImage(systemName: "trash"),attributes: .destructive, handler: {(_) in
                    user.deleteListing(with: self.product!)
                    NotificationCenter.default.post(name: Notification.Name("productAdded"), object: nil)
                    NotificationCenter.default.post(name: Notification.Name("userPreferenceChanged"), object: nil)
                    NotificationCenter.default.post(name: Notification.Name("dataChanged"), object: nil)
                })
            ])
        }
        
        return menuItems!
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        /// Modifying the cell layer

        AddRadius(layer: layer)
        AddRadius(layer: productImg.layer)
        menuBtn.menu = AddMenu()
        menuBtn.showsMenuAsPrimaryAction = true
    }
}

