//
//  ListingDoneTableViewController.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 06/05/24.
//

import UIKit

class ListingDoneTableViewController: UITableViewController {
    var product: Product?
    @IBOutlet weak var prodImg: UIImageView!
    @IBOutlet weak var prodPrice: UILabel!
    @IBOutlet weak var prodDesc: UILabel!
    @IBOutlet weak var prodTitle: UILabel!
    init?(coder: NSCoder, product: Product){
        self.product = product
        super.init(coder: coder)
    }
    
    @IBOutlet weak var expirationLabel: UILabel!
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var myView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        AddShadow(contentView: myView, layer: myView.layer)
        prodImg.layer.cornerRadius = 15
        if let myImage = convertBase64StringToImage(base64String: product!.productImages[0]){
            prodImg.image = myImage
        }else{
            prodImg.image = UIImage(named: "userImage")
        }
        prodTitle.text = product!.name
        prodDesc.text = product!.description
        prodPrice.text = "\u{20B9}\(product!.price)"
        expirationLabel.text = "Listing expires on: \(dateOneMonthAhead(listingDate: product!.listedAt)!.formatted())"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
