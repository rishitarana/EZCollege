//
//  LoginTableViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 01/05/24.
//

import UIKit
import FirebaseAuth

class LoginTableViewController: UITableViewController {
    
    @IBOutlet weak var loginBTN: UIButton!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        roundedInputField(outlet: [emailInput,passwordInput])
        loginBTN.isEnabled = false
        self.navigationItem.hidesBackButton = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resign))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func resign()
    {
        view.endEditing(true)
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    
    @IBAction func unwindToLoginPage(segue: UIStoryboardSegue){
        
    }
    @IBAction func validText(_ sender: Any) {
        guard let email = emailInput.text,
                  !email.isEmpty,
              let college = College.allColleges.first(where: { email.contains($0.domain) }),
              isValidEmail(email,on: college),
              let password = passwordInput.text, password.count >= 8 else{
            loginBTN.isEnabled = false
            return
        }
        
        loginBTN.isEnabled = true
    }
    
    @IBAction func logIn(_ sender: Any) {
        Task{
            do{
                loginBTN.isEnabled = false
                loginBTN.setTitle("", for: .normal)
                loginBTN.setImage(UIImage(systemName: "ellipsis"), for: .normal)
                try await Auth.auth().signIn(withEmail: emailInput.text!, password: passwordInput.text!)
                await getUserDetails()
                navigationController?.popViewController(animated: true)
            } catch{
                let alertController = UIAlertController(title: "Alert", message: "Email or password is wrong", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default){_ in
                    self.loginBTN.isEnabled = true
                    self.loginBTN.setTitle("Proceed ", for: .normal)
                    self.loginBTN.setImage(UIImage(systemName: "arrow.right"), for: .normal)
                    self.loginBTN.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
                    self.loginBTN.imageView?.contentMode = .scaleAspectFit
                    
                }
                alertController.addAction(action)
                present(alertController, animated: true, completion: nil)
                

                
            }
        }
    }
}
