//
//  RegisterPreferencesTopTableViewCell.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 07/05/24.
//

import UIKit

class RegisterPreferencesTopTableViewCell: UITableViewCell {

    @IBOutlet weak var titleString: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleString.text = "Welcome, \(user.getName().split(separator: " ")[0])"
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
