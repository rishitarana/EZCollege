//
//  ListingDoneViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 01/05/24.
//

import UIKit

class ListingDoneViewController: UIViewController {
    var product: Product?
    
    init?(coder: NSCoder, product: Product){
        self.product = product
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    @IBSegueAction func showTable(_ coder: NSCoder) -> ListingDoneTableViewController? {
        return ListingDoneTableViewController(coder: coder, product: product!)
    }
}
