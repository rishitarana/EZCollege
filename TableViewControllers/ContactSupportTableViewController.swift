//
//  ContactSupportTableViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 01/05/24.
//

import UIKit
import MessageUI
class ContactSupportTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate {
    @IBOutlet weak var agriMainderFrame: UIImageView!
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result
        {
        case .cancelled:
            print("Message composition cancelled")
            dismiss(animated: true, completion: nil)
        case .sent:
            print("Message sent successfully")
        case .failed:
            print("Message sending failed")
        @unknown default:
            print("Unknown result")
        }
    }
    
    
    //    let phoneCellIdentifier = "supportPhone"
    @IBOutlet weak var supportCell: UIView!
    let supportNumber = "9878762090"
    @IBOutlet weak var copyrightLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(needSupport))
        supportCell.addGestureRecognizer(tap)
        let curYear = Calendar.current.component(.year, from: Date())
        copyrightLable.text = "\u{00A9} \(curYear) AgriMainder Inc."
        
//        AddShadow(contentView: agriMainderFrame, layer: agriMainderFrame.layer)
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    @objc func needSupport()
    {
        let phoneNumber = "9878762090"
        
        if MFMessageComposeViewController.canSendText() {
            let messageController = MFMessageComposeViewController()
            messageController.recipients = [phoneNumber]
            messageController.messageComposeDelegate = self
            present(messageController, animated: true, completion: nil)
        } else {
            // Handle the case where user's device cannot send messages
            // For example, display an alert
            let alert = UIAlertController(title: "Error", message: "Your device cannot send messages", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
}
