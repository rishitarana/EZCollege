//
//  RegisterDynamicPreferencesTableViewTableViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 07/05/24.
//

import UIKit

class RegisterDynamicPreferencesTableViewTableViewController: UITableViewController {

    var tapGesture = UITapGestureRecognizer()
    let data:[Preferences] = user.getUserPreference()

    var preferenceCategories:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section
        {
        case 0: return 1
        case 1: return user.getUserPreference().count
        default:
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "registerTop", for: indexPath)
            
            return cell

        }
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "registerPref", for: indexPath) as! RegisterPreferencesTableViewCell
            let dt = data[indexPath.row]
            if dt.choice == true
            {
                cell.accessoryType = .checkmark
            }
            else
            {
                cell.accessoryType = .none
            }
            
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(myGestureTapped(_:)))
            cell.addGestureRecognizer(tapGesture)
            cell.isUserInteractionEnabled = true
            cell.update(with: dt)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "proceedBtn", for: indexPath)
            return cell
        }
         

        
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


