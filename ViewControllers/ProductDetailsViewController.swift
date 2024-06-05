//
//  ProductDetailsViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 30/04/24.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    var dispCategory: Category?
    init?(coder: NSCoder, category: Category){
        self.dispCategory = category
        super.init(coder: coder)
    }
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var showCategory: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AddRadius(layer: showCategory.layer)
        categoryLabel.text = "Selected category: \(dispCategory!.title)"
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

