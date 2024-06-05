//
//  CollegeDetailsTableViewController.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 26/04/24.
//

import UIKit

class CollegeDetailsTableViewController: UITableViewController {

    @IBOutlet weak var clgEmail: UILabel!
    @IBOutlet weak var clgName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clgName.text = user.getUser().college.name
        clgEmail.text = user.getUser().emailId
    }
}
