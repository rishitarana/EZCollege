//
//  ProductDetailsTableViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 30/04/24.
//

import UIKit

class ProductDetailsTableViewController: UITableViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    var pick = UIPickerView()
    @IBOutlet weak var productTitleInput: UITextField!
    
    @IBOutlet weak var descriptionStack: UIStackView!
    
    @IBOutlet weak var textPick: UITextField!
    //    @IBOutlet weak var pickerViewOutlet: UIPickerView!
    
    @IBOutlet weak var askingPriceInput: UITextField!
    
    @IBOutlet weak var productDesriptionInput: UITextField!
    
    @IBOutlet weak var conditionButton: UIButton!
    private var condition: Condition?{
        didSet{
            askingPriceInput.resignFirstResponder()
            textPick.text = condition?.rawValue
            isValidText(textPick)
        }
    }
    
    var fieldArr:[UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conditionButton.showsMenuAsPrimaryAction = true
        conditionButton.menu = generateMenu()
        
        textPick.isEnabled = false
        
        nextButton.isEnabled = false
        fieldArr.append(productDesriptionInput)
        fieldArr.append(productTitleInput)
        fieldArr.append(textPick)
        fieldArr.append(askingPriceInput)
        
        
        
        for field in fieldArr
        {
            addBottomBorder(outlet: field)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resign))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func resign()
    {
        view.endEditing(true)
    }
    func generateMenu() -> UIMenu{
        return UIMenu(title: "", options: .displayInline, children:
            Condition.allCases.map{ cat in
                return UIAction(title: cat.rawValue, handler: {(_) in
                    self.condition = cat
                })
            }
        )
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    @IBSegueAction func saveDetails(_ coder: NSCoder, sender: Any?) -> UploadPhotosViewController? {
        let conditon: Condition = Condition(rawValue: textPick.text!)!
        createProduct.setProductDetails(name: productTitleInput.text!, description: productDesriptionInput.text!, price: Int(askingPriceInput.text!)!, condition: conditon)
        return UploadPhotosViewController(coder: coder, prodTitle: productTitleInput.text!, prodDesc: productDesriptionInput.text!)
    }
    
    @IBAction func isValidText(_ sender: UITextField){
        guard let name = productTitleInput.text,
              let description = productDesriptionInput.text,
              let price = askingPriceInput.text,
              let condition = textPick.text else {
            nextButton.isEnabled = false
            return
        }
        
        let priceInt: Int? = Int(price)
        let isPriceValid: Bool = (priceInt != nil && priceInt! > 0)
        
        let isValid: Bool = !name.isEmpty && !description.isEmpty && isPriceValid && !condition.isEmpty && (Condition(rawValue: condition)!.isValid)
        
        nextButton.isEnabled = isValid
    }
    
}
