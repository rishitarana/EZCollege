//
//  RegisterTableViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 01/05/24.
//

import UIKit

class RegisterTableViewController: UITableViewController {

    @IBOutlet weak var collegeMenu: UIButton!
    @IBOutlet weak var inputStack: UIStackView!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var collegeInput: UITextField!
    @IBOutlet weak var nameInput: UITextField!
    
    @IBOutlet weak var collegeStack: UIStackView!
    private var college:College?{
        didSet{
            collegeInput.text = college?.name
            validText(collegeInput)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        roundedInputField(outlet: [nameInput])
        proceedButton.isEnabled = false
        collegeInput.isUserInteractionEnabled = false
        collegeMenu.showsMenuAsPrimaryAction = true
        collegeMenu.menu = generateCollegeMenu()
        collegeInput.borderStyle = .none
        collegeStack.layer.cornerRadius = 12
        collegeStack.layer.masksToBounds = true
        collegeStack.layer.borderWidth = 0.5
        collegeStack.layer.borderColor = UIColor.purpleCardBackground.cgColor
        collegeInput.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: collegeInput.frame.height))
        collegeInput.leftViewMode = .always
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resign))
        view.addGestureRecognizer(tapGesture)
    }
    
    //Remove the keyboard when clicking anywhere on screen
    @objc func resign()
    {
        view.endEditing(true)
    }
    
    //Generate the dropdown menu for college selection
    func generateCollegeMenu()->UIMenu
    {
        return UIMenu(title:"",options: .displayInline,children: College.allColleges.map{ col in
            return UIAction(title:col.name, handler: {(_)
                in self.college = col
            })
        })
    }
    
    //Check if user has entered the name and selected college
    @IBAction func validText(_ sender: UITextField) {
        guard let name = nameInput.text, !name.isEmpty,
              let clgName = collegeInput.text, !clgName.isEmpty else {
            proceedButton.isEnabled = false
            return
        }
        proceedButton.isEnabled = true
    }
    
    //Pass the user's name and college through segue
    @IBSegueAction func enterNameandCollegeName(_ coder: NSCoder) -> RegisterEmailTableViewController? {
        user.putNameAndCollege(name: nameInput.text!, collegeName: collegeInput.text!)
        return RegisterEmailTableViewController(coder: coder, name: nameInput.text!,collegeName:collegeInput.text!)
    }
    
    //Set the height occupied by table view footer to 0
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    //Set the height occupied by table view header to 0
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

}
