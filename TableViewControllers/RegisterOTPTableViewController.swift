//
//  RegisterOTPTableViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 02/05/24.
//

import UIKit

class RegisterOTPTableViewController: UITableViewController,UITextFieldDelegate {
    var name: String = user.getName()
    var email: String = user.getEmail()
    var otpCheck:String = otpClass.otp
    var otpEntered:String = ""
//    init?(coder: NSCoder, name: String, email:String){
//        self.name = name
//        self.email = email
//        super.init(coder: coder)
//    }
//    
//    required init?(coder: NSCoder){
//        fatalError("coder not implemented")
//    }
    @IBOutlet weak var titleString: UILabel!
    
    @IBOutlet weak var proceedBtn: UIButton!
    
    @IBOutlet weak var otpField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        roundedInputField(outlet: [otpField])
        proceedBtn.isEnabled = false
        otpField.delegate = self
        titleString.text = "Welcome, \(name.split(separator: " ")[0])"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resign))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func resign()
    {
        view.endEditing(true)
    }
    
    @IBAction func otpAction(_ sender: Any) {
        
        otpEntered = otpField.text!
        otpVerify()
    }
    @IBAction func resendOtp(_ sender: Any) {
        
        otpCheck = generateOTP()
        otpClass.otp = otpCheck
        print(otpCheck)
        otpVerify()
        sendEmail(recipient: email, otp: otpCheck)
    }
    
   
    
    func otpVerify() {
        if(otpCheck == otpEntered)
        {
            proceedBtn.isEnabled = true
            
        }
        else
        {
            proceedBtn.isEnabled = false
            
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return newText.count <= 6
        }
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

