//
//  LoginOTPTableViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 06/05/24.
//

import UIKit

class RegisterPasswordTableViewController: UITableViewController {

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var titleString: UILabel!
    @IBOutlet weak var passwordInput: UITextField!
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        
        roundedInputField(outlet: [passwordInput])
        titleString.text = "Welcome, \(user.getName().split(separator: " ")[0])"
        nextBtn.isEnabled = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resign))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func resign()
    {
        view.endEditing(true)
    }
    
    @IBAction func validText(sender: UITextField){
        guard let password = passwordInput.text, password.count >= 8 else {
            nextBtn.isEnabled = false
            return
        }
        nextBtn.isEnabled = true
    }
    
    
    @IBSegueAction func proceed(_ coder: NSCoder) -> RegisterPhotoTableViewController? {
        user.putPassword(with: passwordInput.text!)
        return RegisterPhotoTableViewController(coder: coder)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

}
