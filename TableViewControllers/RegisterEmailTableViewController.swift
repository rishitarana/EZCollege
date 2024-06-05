//
//  RegisterEmailTableViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 02/05/24.
//

import UIKit

class RegisterEmailTableViewController: UITableViewController {
    var name: String
    var collegeName:String
    init?(coder: NSCoder, name: String,collegeName:String){
        self.name = name
        self.collegeName = collegeName
        super.init(coder: coder)
    }
    
    @IBOutlet weak var titleString: UILabel!
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var collegeMaillabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.isEnabled = false
        roundedInputField(outlet: [collegeMaillabel])
        titleString.text = "Welcome, \(name.split(separator: " ")[0])"
        nextBtn.isEnabled = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resign))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func resign()
    {
        view.endEditing(true)
    }
    
    @IBAction func validText(sender: UITextField){
        guard let email = collegeMaillabel.text,
                  !email.isEmpty,
                  let college = College.allColleges.first(where: { $0.name == collegeName }),
              isValidEmail(email,on: college)
            else {
                nextBtn.isEnabled = false
                return
            }
            
            nextBtn.isEnabled = true
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    
    //    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    //        var shouldPerform: Bool = true
    //        Task{
    //            do{
    //                let docRef =  database.document("email/\(collegeMaillabel.text!)")
    //
    //                let doc = try await docRef.getDocument()
    //
    //                if(doc.exists){
    //                    shouldPerform = false
    //                }
    //            }
    //        }
    //        //        return shouldPerform
    //    }
    
    
    
    
    @IBAction func otp(_ sender: Any) {
        guard let email = collegeMaillabel.text else {return}
        
        Task{
            do{
                let docRef =  database.document("users/\(email)")
                
                let doc = try await docRef.getDocument()
                
                if(doc.exists){
                    let alertController = UIAlertController(title: "Alert", message: "An account linked with this email already exists. Use a different email or login with existing one.", preferredStyle: .alert)
                    
                    
                    let action = UIAlertAction(title: "OK", style: .default) 
                    alertController.addAction(action)
                    present(alertController, animated: true, completion: nil)
                }
                else
                {
                    user.putEmail(email: email)
                    let otp = generateOTP()
                    otpClass.otp = otp
                    sendEmail(recipient: email, otp: otp)
                    
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterOTPViewController") as? RegisterOTPTableViewController {
                        navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
        
        
        //
        
    }
    
    
}
