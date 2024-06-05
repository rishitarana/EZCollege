//
//  ProfileTableViewController.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 25/04/24.
//

import UIKit
import Firebase

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var logOut: UITableViewCell!
    @IBOutlet weak var userImage: UIImageView!
    
    var tap: UITapGestureRecognizer!
    
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    var currentUser = user.getUser()
    
    @objc func logOutUser(){
        Task{
            do{
                try await signOutUser()
                
                if let tabBarController = self.tabBarController{
                    tabBarController.selectedIndex = 0
                }
            }catch{
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = user.getUser()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentUser = user.getUser()
        updateUI()
    }
    
    func updateUI(){
        Task{
            do{
                let image = try await renderImageFromUrl(from: URL(string: currentUser.uImage)!)
                DispatchQueue.main.async{
                    self.userImage.image = image
                }
            }catch{}
        }
        userName.text = currentUser.uName
        userEmail.text = currentUser.emailId
        tap = UITapGestureRecognizer(target: self, action: #selector(logOutUser))
        
        userImage.layer.cornerRadius = userImage.frame.width/2
        logOut.addGestureRecognizer(tap)
    }
    
    @IBAction func unwindToProfile(_ sender: UIStoryboardSegue){
        
    }
    
}
