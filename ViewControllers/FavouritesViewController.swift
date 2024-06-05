//
//  FavouritesViewController.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 25/04/24.
//

import UIKit

class FavouritesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var favCollectionView: UICollectionView!
    
    var searchBar: UISearchController!
    
    var products:[Product] = []
    var likedProds: [UUID] = []
    var filteredDataSource: [Product] = []
    override func viewDidLoad() {
        likedProds = user.getLikedProducts()
        super.viewDidLoad()
        
        
        searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchResultsUpdater = self
        searchBar.obscuresBackgroundDuringPresentation = false
        
        products = user.getProducts().filter{
            product  in
            return likedProds.contains(product.id)
        }
        
        filteredDataSource = products
        self.navigationItem.searchController = searchBar
        favCollectionView.setCollectionViewLayout(generateLayout(), animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeData), name: NSNotification.Name("dataChanged"), object: nil)
        
    }
    
    @objc func changeData(){
        likedProds = user.getLikedProducts()
        products = user.getProducts().filter{
            product  in
            return likedProds.contains(product.id)
        }
        filteredDataSource = products
        favCollectionView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.lowercased() ?? ""
        let data = user.getProducts().filter{ product in
            return user.getLikedProducts().contains(product.id)
        }

        if searchText.isEmpty {
            filteredDataSource = data
        } else {
            filteredDataSource = data.filter{ product in
                product.name.lowercased().contains(searchText) || product.description.lowercased().contains(searchText)
            }
        }
        favCollectionView.reloadData()
    }


    private func generateLayout()->UICollectionViewLayout
    {
        let spacing:CGFloat = 15
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = .init(top: spacing, leading: 0, bottom: 0, trailing: spacing )
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(260))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout  = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favCollectionView.dequeueReusableCell(withReuseIdentifier: "favCell", for: indexPath) as! FavouriteCollectionViewCell
        let dt:Product = filteredDataSource[indexPath.row]
        cell.product = dt
        return cell
    }
    
    @IBSegueAction func viewPeoduct(_ coder: NSCoder, sender: Any?) -> ProductScreenTableViewController? {
        if let item = sender as? UICollectionViewCell, let indexPath = favCollectionView.indexPath(for: item){
            let product = filteredDataSource[indexPath.row]
            return ProductScreenTableViewController(coder: coder, product: product)
        }
        return nil
    }
}
