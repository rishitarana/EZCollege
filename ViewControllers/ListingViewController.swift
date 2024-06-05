//
//  ListingViewController.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 25/04/24.
//

import UIKit

class ListingViewController: UIViewController,UICalendarViewDelegate,UICollectionViewDataSource {
    @IBAction func activeFunc(_ sender: Any) {
        baseCollectionView.reloadData()
    }
    
    var activeListings:[Listing] = user.getUserActiveListings()
    var expiredListings:[Listing] = user.getUserExpiredListings()
    @IBOutlet weak var baseCollectionView: UICollectionView!
    @IBOutlet weak var activeToggle: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        baseCollectionView.setCollectionViewLayout(generateLayout(), animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: Notification.Name("productAdded"), object: nil)
        
    }
    
    @objc func loadData(){
        activeListings = user.getUserActiveListings()
        expiredListings = user.getUserExpiredListings()
        baseCollectionView.reloadData()
    }
    private func generateLayout()->UICollectionViewLayout
    {
        let spacing:CGFloat = 12
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(103))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        
        group.contentInsets = .init(top: spacing, leading: spacing, bottom: 0, trailing: spacing)
        let section = NSCollectionLayoutSection(group: group)
        
        let layout  = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(activeToggle.selectedSegmentIndex == 0)
        {
            return user.getUserActiveListings().count
        }
        else
        {
            return user.getUserExpiredListings().count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = baseCollectionView.dequeueReusableCell(withReuseIdentifier: "celll", for: indexPath) as! BaseCollectionViewCell
        
        if(activeToggle.selectedSegmentIndex == 0)
        {
            let dt:Product = user.getProduct(with: activeListings[indexPath.item].product)
            
            cell.product = dt
            cell.isExpired = false
        }
        else
        {   let dt:Product = user.getProduct(with: expiredListings[indexPath.item].product)
            cell.product = dt
            cell.isExpired = true
        }
        return cell
    }
    
    @IBAction func unwindToListingPage(segue: UIStoryboardSegue){
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return activeToggle.selectedSegmentIndex == 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editListing"){
            if let item = sender as? UICollectionViewCell, let indexPath = baseCollectionView.indexPath(for: item){
                let product:Product = user.getProduct(with: activeListings[indexPath.item].product)
                
                if let rootVC = segue.destination as? UINavigationController{
                    
                    if let childVC = rootVC.viewControllers.first as? EditListingTableViewController{
                        childVC.listing = product
                    }
                }
            }
        }
    }
}
