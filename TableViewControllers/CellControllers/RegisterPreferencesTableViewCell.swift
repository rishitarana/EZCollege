//
//  RegisterPreferencesTableViewCell.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 07/05/24.
//

import UIKit

class RegisterPreferencesTableViewCell: UITableViewCell {

    @IBOutlet weak var prefTitle: UILabel!
    @IBOutlet weak var prefLogo: UIButton!
    @IBOutlet weak var lab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(with preference: Preferences){
        prefTitle.text = preference.category.rawValue
        prefLogo.setImage(UIImage(systemName: preference.icon, withConfiguration: UIImage.SymbolConfiguration(scale: .small)), for: .normal)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
