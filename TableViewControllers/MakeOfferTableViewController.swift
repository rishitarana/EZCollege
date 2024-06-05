//
//  MakeOfferTableViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 02/05/24.
//

import UIKit

class MakeOfferTableViewController: UITableViewController {
    @IBOutlet weak var productImage: UIImageView!
    var product: Product
    var currentUser = user.getUser()
    
    init?(coder: NSCoder, product: Product){
        self.product = product
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var firstCell: UIView!
    @IBOutlet weak var offerPrice: UITextField!
    @IBOutlet weak var originalAsk: UILabel!
    @IBOutlet weak var productCondition: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.isEnabled = false
        
        offerPrice.placeholder = "\u{20B9} 0"
        
        productTitle.text = product.name
        productCondition.text = product.condition.rawValue
        originalAsk.text = "\u{20B9} \(product.price)"
        Task{
            do{
                let image = try await renderImageFromUrl(from: URL(string: product.productImages[0])!)
                DispatchQueue.main.async{
                    self.productImage.image = image
                }
            }catch{}
        }
        roundedInputField(outlet: [offerPrice])
        productImage.layer.cornerRadius = 15
        addBottomBorder(outlet: firstCell)
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func addBottomBorder(outlet:UIView)
    {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.placeholderText.cgColor
        borderLayer.frame = CGRect(
            x: 0,
            y: outlet.frame.size.height - 0.25,
            width: outlet.frame.width,
            height: 0.25
        )
        
        outlet.layer.addSublayer(
            borderLayer
        )
            
//            outlet.borderStyle = .none
            outlet.backgroundColor = .clear
    }
    
    @IBAction func validText(_ sender: UITextField){
        guard let text = sender.text, let price = Int(text), price > 0 && price < product.price else {sendButton.isEnabled = false; return}
        sendButton.isEnabled = true
    }
    
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        Task{
            do{
                let concatStr = currentUser.id.uuidString + "+" + product.id.uuidString + "+" + product.listedBy.uuidString
                
                try await putMessage(from: currentUser.id.uuidString, to: product.listedBy.uuidString, with: "Hii! I would like to offer \u{20B9}\(offerPrice.text!)", in: concatStr, on: product.id.uuidString)
            }catch{}
        }
        
        let alertController = UIAlertController(title: "Message sent!", message: "Your offer has been sent to the seller!", preferredStyle: .alert)

                let action = UIAlertAction(title: "OK", style: .default) {[weak self] (action:UIAlertAction) in
                    self?.dismiss(animated: true, completion: nil)
                }
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
}
