//
//  EditListingTableViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 08/05/24.
//

import UIKit

class EditListingTableViewController: UITableViewController {
    @IBOutlet weak var productTitle: UITextField!
    
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var productCategory: UITextField!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var conditionBtn: UIButton!
    @IBOutlet weak var productCondition: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productDesc: UITextField!
    
    private var condition: Condition?{
        didSet{
            productPrice.resignFirstResponder()
            productCondition.text = condition?.rawValue
            isValidText(productCondition)
        }
    }
    
    private var category: Category?{
        didSet{
            productCategory.text = category?.rawValue
            isValidText(productCategory)
        }
    }
    
    @IBAction func isValidText(_ sender: UITextField){
        guard let name = productTitle.text,
              let description = productDesc.text,
              let price = productPrice.text else {
            nextBtn.isEnabled = false
            return
        }
        
        let priceInt: Int? = Int(price)
        let isPriceValid: Bool = (priceInt != nil && priceInt! > 0)
        
        let isValid: Bool = !name.isEmpty && !description.isEmpty && isPriceValid
        nextBtn.isEnabled = isValid
    }
    
    var listing: Product?
    
    func updateText(){
        if let listing = listing{
            productDesc.text = listing.description
            productPrice.text = "\(listing.price)"
            productCategory.text = listing.category.rawValue
            productCondition.text = listing.condition.rawValue
            productTitle.text = listing.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        conditionBtn.showsMenuAsPrimaryAction = true
        categoryBtn.showsMenuAsPrimaryAction = true
        conditionBtn.menu = generateConditionMenu()
        categoryBtn.menu = generateCategoryMenu()
        
        updateText()

        let inputBox:[UITextField] = [productTitle,productDesc,productPrice,productCondition,productCategory]
        
        for input in inputBox
        {
            addBottomBorder(outlet: input)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resign))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func resign()
    {
        view.endEditing(true)
    }
    
    func generateCategoryMenu() -> UIMenu{
        return UIMenu(title: "", options: .displayInline, children: Category.allCases.map{ cat in
            return UIAction(title: cat.rawValue, handler: {(_) in
                self.category = cat
            })
        })
    }

    
    func generateConditionMenu() -> UIMenu{
        return UIMenu(title: "", options: .displayInline, children:
                        Condition.allCases.map{ cat in
                            return UIAction(title: cat.rawValue, handler: {(_) in
                                self.condition = cat
                            })
                        }
)
    }


    @IBAction func submit(_ sender: Any) {
        user.editListing(productID: listing!.id, category: Category(rawValue: productCategory.text!)!, name: productTitle.text!, description: productDesc.text!, price: Int(productPrice.text!)!, condition: Condition(rawValue: productCondition.text!)!)
        
        
        NotificationCenter.default.post(name: Notification.Name("userPreferenceChanged"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("productAdded"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("dataChanged"), object: nil)
        dismiss(animated: true)
    }
    func addBottomBorder(outlet:UITextField)
    {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.placeholderText.cgColor
        borderLayer.frame = CGRect(x: 0, y: outlet.frame.size.height - 0.5, width: outlet.frame.width, height: 0.5)
            
            outlet.layer.addSublayer(borderLayer)
            
            outlet.borderStyle = .none
            outlet.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
