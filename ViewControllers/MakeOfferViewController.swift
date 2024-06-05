//
//  MakeOfferViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 02/05/24.
//

import UIKit

class MakeOfferViewController: UIViewController {

    
//    var product: Product
//    var images: [String]
//    
//    init?(coder: NSCoder, product: Product) {
//        self.product = product
//        self.images = self.product.productImages
//        super.init(coder: coder)
//    }
    var product: Product
    
    init?(coder: NSCoder, product: Product){
        self.product = product
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //
    @IBSegueAction func tableRender(_ coder: NSCoder, sender: Any?) -> MakeOfferTableViewController? {
        return MakeOfferTableViewController(coder: coder, product: product)
    }
    //    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
