//
//  RegisterPreferencesTableViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 07/05/24.
//

import UIKit

class RegisterPreferencesTableViewController: UITableViewController {
    
    @IBOutlet weak var dynamicTable: UITableView!
    @IBOutlet var staticTable: UITableView!
    
    let data:[Preferences] = user.getUserPreference()
    
    var preferenceCategories:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dynamicTableView = tableView.viewWithTag(100) as? UITableView {
            dynamicTable.delegate = self
            dynamicTable.dataSource = self
        } else {
            print("Dynamic table view not found.")
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resign))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func resign()
    {
        view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3
        {
            return user.getUserPreference().count
        }
        else {
            // Return the number of rows for other static cells
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Assuming your dynamic table view is in the first row of the first section
        if indexPath.section == 3 && indexPath.row == 0 {
            // Dequeue cells from the dynamic table view
            let cell = tableView.dequeueReusableCell(withIdentifier: "preferenceCell", for: indexPath) as! RegisterPreferencesTableViewCell
            return cell
        } else {
            // Handle other static cells if any
            let staticCell = super.tableView(tableView, cellForRowAt: indexPath)
            return staticCell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            // Assuming your dynamic table view is in the first row of the first section
            if indexPath.section == 3 && indexPath.row == 0 {
                // Set the height for dynamic cells
                return 44 // Adjust this value according to your requirements
            } else {
                // Set the height for other static cells
                return super.tableView(tableView, heightForRowAt: indexPath)
            }
        }
    
}


