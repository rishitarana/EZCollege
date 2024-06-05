//
//  HomeViewController.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 30/04/24.
//

import UIKit

enum CellType
{
    case promoted
    case standard
}
class HomeViewController: UIViewController, UISearchResultsUpdating {
    
    var searchBar: UISearchController!
    var promotedProducts = categorizedProducts.getPromotedProducts()
    var products = categorizedProducts.getAllProducts()
    var userPreferencs = user.getUserPreference()
    
    var filteredDataSource: [Category: [Product]] = [:]
    
    var catsToDisplay: [Category] = []
    @IBOutlet weak var homeCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredDataSource = products
        updateCategoriesToDisplay()
        
        searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchResultsUpdater = self
        searchBar.obscuresBackgroundDuringPresentation = false
        
        homeCollectionView.collectionViewLayout = createLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(preferenceChanged), name: NSNotification.Name("userPreferenceChanged"), object: nil)
//        view.backgroundColor = UIColor.
        self.navigationItem.searchController = searchBar
    }
    
    
    func updateCategoriesToDisplay() {
        let preferredCategories = userPreferencs.filter { $0.choice }.map { $0.category }
            catsToDisplay = preferredCategories.filter { category in
                if let productsInCategory = filteredDataSource[category] {
                    return !productsInCategory.isEmpty
                }
                return false
            }
            
            homeCollectionView.reloadData()
    }
    
    @objc func preferenceChanged(){
        products = categorizedProducts.getAllProducts()
        filteredDataSource = products
        userPreferencs = user.getUserPreference()
        promotedProducts = categorizedProducts.getPromotedProducts()
        updateCategoriesToDisplay()
    }
    
    private func createLayout()->UICollectionViewLayout{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing:4)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45), heightDimension: .absolute(265))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        
        let promotedItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        promotedItem.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 4, bottom: 12, trailing:4)
        let promotedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .absolute(250)), repeatingSubitem: promotedItem, count: 1)
        
        let promotedSection = NSCollectionLayoutSection(group: promotedGroup)
        promotedSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        
        
        
//        let configuration = UICollectionViewCompositionalLayoutConfiguration()
//        configuration.scrollDirection = .horizontal
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50) // Customize height as needed
        )
                    
        // Add a header to the section
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        // Attach the header to the section
        section.boundarySupplementaryItems = [header]

        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
                if sectionIndex == 0 {
                    return promotedSection
                } else {
                    return section
                }
            }
        
        return layout
    }
  
    @IBSegueAction func goToProductsPage(_ coder: NSCoder, sender: Any?) -> ProductScreenTableViewController? {
        if let item = sender as? UICollectionViewCell, let indexPath = homeCollectionView.indexPath(for: item){
            let prod: Product = promotedProducts[indexPath.row]
            
            return ProductScreenTableViewController(coder: coder, product: prod)
        }
        return nil
    }
    @IBSegueAction func goToNewProductPage(_ coder: NSCoder, sender: Any?) -> ProductScreenTableViewController? {
        
        if let item = sender as? UICollectionViewCell, let indexPath = homeCollectionView.indexPath(for: item){
            let category = catsToDisplay[indexPath.section - 1]
            var prod: Product
            if let prods = filteredDataSource[category]{
                prod = prods[indexPath.row]
                return ProductScreenTableViewController(coder: coder, product: prod)
            }
        }
        return nil
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.lowercased() ?? ""
        if searchText.isEmpty {
            filteredDataSource = categorizedProducts.getAllProducts()
        } else {
            for (cat, prod) in categorizedProducts.getAllProducts() {
                let filter = prod.filter{ prd in
                    prd.name.lowercased().contains(searchText) || prd.description.lowercased().contains(searchText)
                }
                
                if !filter.isEmpty{
                    filteredDataSource[cat] = filter
                }else{
                    filteredDataSource[cat] = []
                }
            }
        }
        updateCategoriesToDisplay()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return catsToDisplay.count + 1
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0
        {
            return promotedProducts.count
        }
        else
        {
            
            let standardSectionIndex = section - 1
            guard standardSectionIndex < catsToDisplay.count else {
                return 0
            }
            let category = catsToDisplay[standardSectionIndex]

            return filteredDataSource[category]?.count ?? 0
        }
        
    }
    func determineCellType(for indexPath: IndexPath) -> CellType {
        // Logic to determine cell type based on indexPath
        // For example, based on row or section
        
        // This is just a placeholder, replace it with your actual logic
        return indexPath.row % 2 == 0 ? .standard : .promoted
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPath.section == 0
        {
            let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "promotedCell", for: indexPath) as! PromotedCollectionViewCell
//            let category = catsToDisplay[indexPath.section]
            let prod = promotedProducts[indexPath.row]
            
            cell.product = prod
            
            return cell
        }
        else
        {
            let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "standardCell", for: indexPath) as! HomeStandartProductCollectionViewCell
            let category = catsToDisplay[indexPath.section - 1]
            
            if let prods = filteredDataSource[category]{
                let prod = prods[indexPath.row]
                
                cell.product = prod
            }
            
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let header = homeCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! HeaderCollectionReusableView
            
            let category = catsToDisplay[indexPath.section - 1]
            
            header.sectionTitle.text = "\(category.title)"
            return header
            
        }
        return UICollectionReusableView()
    }
    
    
    
}
