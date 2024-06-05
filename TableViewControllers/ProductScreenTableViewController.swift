//
//  ProductScreenTableViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 07/05/24.
//

import UIKit

class ProductScreenTableViewController: UITableViewController {
    var product: Product
    var images: [String]
    var isLiked: Bool
    
    init?(coder: NSCoder, product: Product){
        self.product = product
        self.images = self.product.productImages
        self.isLiked = user.isLikedProduct(with: self.product)
        super.init(coder: coder)
    }
    
    required  init?(coder: NSCoder){
        fatalError("Not implemented")
    }
    @IBSegueAction func makeOffer(_ coder: NSCoder, sender: Any?) -> MakeOfferViewController? {
        return MakeOfferViewController(coder: coder, product: product)
    }
    
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceCell: UITableViewCell!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var conditionCell: UITableViewCell!
    
    
    @IBOutlet weak var descriptionCell: UITableViewCell!
    
    var topBorderLayer: CALayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = product.name
        
        priceLabel.text = "\u{20B9}\(product.price)"
        conditionLabel.text = product.condition.rawValue
        descriptionLabel.text = product.description
        
        likeBtn.layer.cornerRadius = likeBtn.frame.width/2
        
        likeBtn.layer.borderColor = UIColor.customRed.cgColor
        likeBtn.layer.borderWidth = 1
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        if isLiked {
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        addTopBorder(to: [conditionCell,descriptionCell])
    }
    
    @IBAction func likedButtonTapped(_ sender: UIButton) {
        if isLiked {
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            user.deleteProductFromLiked(for: product)
            isLiked = false
        }else{
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            user.addProductToLiked(with: product)
            isLiked = true
        }
        NotificationCenter.default.post(name: Notification.Name("dataChanged"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("userPreferenceChanged"), object: nil)
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
        
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    @IBSegueAction func showImages(_ coder: NSCoder, sender: Any?) -> ProductScreenCollectionViewController? {
        return ProductScreenCollectionViewController(coder: coder, images: images)
    }
}

