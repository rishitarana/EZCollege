//
//  SelectCategoryViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 30/04/24.
//

import UIKit

class SelectCategoryViewController: UIViewController {
    @IBOutlet weak var selectCategoryCollectionView: UICollectionView!
    var categories:[Preferences] = Preferences.allPreferences
//    var productsLike:[
        override func viewDidLoad() {
        super.viewDidLoad()
            
        // Do any additional setup after loading the view.
            selectCategoryCollectionView.setCollectionViewLayout(generateLayout(), animated: false)
    }
    private func generateLayout()->UICollectionViewLayout
    {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = .init(top: 0, leading: 12, bottom: 12, trailing: 12)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.absolute(100)), repeatingSubitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBSegueAction func saveCAtegory(_ coder: NSCoder, sender: Any?) -> ProductDetailsViewController? {
        if let item = sender as? UICollectionViewCell, let indexPath = selectCategoryCollectionView.indexPath(for: item){
            let product = categories[indexPath.row]
            createProduct.setCategory(category: product.category)
            return ProductDetailsViewController(coder: coder, category: product.category)
        }
        return nil
    }
}

extension SelectCategoryViewController:UICollectionViewDataSource,UICollectionViewDelegate
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = selectCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "selectCategoryCell", for: indexPath) as! SelectCategoryCollectionViewCell
        let dt:Preferences = categories[indexPath.row]
        cell.categoryNameLabel.text = dt.category.title
        cell.productsLikeLabel.text = "Includes: " +  (dt.mayInlcude?.joined(separator: ", "))! + ", etc"
        return cell
        
    }
    
    
}
