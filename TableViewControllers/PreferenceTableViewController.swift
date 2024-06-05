//
//  PreferenceTableViewController.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 25/04/24.
//

import UIKit

class PreferenceTableViewController:
    UITableViewController {
    var tapGesture = UITapGestureRecognizer()
    @IBOutlet var tapTap: UITapGestureRecognizer!
    
    let data:[Preferences] = user.getUserPreference()

    var preferenceCategories:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return user.getUserPreference().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preferenceCell", for: indexPath) as! PreferenceTableViewCell
        let dt = data[indexPath.row]
        if dt.choice == true
        {
            cell.accessoryType = .checkmark
            //            preferenceCategories.append(dt.name)
        }
        else {
            cell.accessoryType = .none
        }
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(myGestureTapped(_:)))
        cell.addGestureRecognizer(tapGesture)
        cell.isUserInteractionEnabled = true
        
        cell.update(with: dt)
        return cell
    }
    
    
    @objc func myGestureTapped(_ sender: UITapGestureRecognizer) {
        
        if let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView))
        {
            let cell = tableView.cellForRow(at: indexPath)
            let dt = data[indexPath.row]
            
            if cell?.accessoryType == UITableViewCell.AccessoryType.none
            {
                cell?.accessoryType = .checkmark
                //                preferenceCategories.append(dt.name)
                user.updatePreference(for: indexPath.row, value: true)
                NotificationCenter.default.post(name: NSNotification.Name("userPreferenceChanged"), object: nil)
            }
            else
            {
                cell?.accessoryType = .none
                user.updatePreference(for: indexPath.row, value: false)
                NotificationCenter.default.post(name: NSNotification.Name("userPreferenceChanged"), object: nil)
            }
        }
        
    }
}
