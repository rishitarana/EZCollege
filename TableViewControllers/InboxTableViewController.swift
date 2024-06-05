//
//  InboxTableViewController.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 25/04/24.
//

import UIKit

class InboxTableViewController: UITableViewController {
    var data = allChats
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = allChats
        self.navigationItem.searchController = UISearchController()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        NotificationCenter.default.addObserver(self, selector: #selector(newChatAdded), name: NSNotification.Name("chatAdded"), object: nil)
    }
    
    @objc func newChatAdded(){
        data = allChats
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        data = allChats
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inboxCell", for: indexPath)
        
        let product = getProduct(with: data[indexPath.row].on)
        var dict: [String: String] = [:]
        var content = cell.defaultContentConfiguration()
        content.text = product.name
        Task{
            do{
                let ids = data[indexPath.row].id
                if(ids[0] == user.getUser().id){
                    dict = try await fetchUser(with: ids[2])!
                }else{
                    dict = try await fetchUser(with: ids[0])!
                }
                content.secondaryText = "With: \(dict["name"] ?? "User not found")"
                cell.contentConfiguration = content
            }catch{}
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ids =  data[indexPath.row].id
        let product = getProduct(with: data[indexPath.row].on)
        
        let vc  = NewChatViewController()
        vc.title = "\(product.name)"
        vc.ids = ids
        navigationController?.pushViewController(vc, animated: true)
        //Show chat messages
    }
}
