//
//  PreferenceTableViewCell.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 25/04/24.
//

import UIKit

class PreferenceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var prefTitle: UILabel!
    @IBOutlet weak var prefIcon: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with preference: Preferences){
        prefTitle.text = preference.category.rawValue
        prefIcon.setImage(UIImage(systemName: preference.icon, withConfiguration: UIImage.SymbolConfiguration(scale: .small)), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
