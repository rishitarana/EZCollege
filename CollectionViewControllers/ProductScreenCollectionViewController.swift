//
//  ProductScreenCollectionViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 07/05/24.
//

import UIKit

private let reuseIdentifier = "productImages"

class ProductScreenCollectionViewController: UICollectionViewController {
    var images:[String]
    
    /// init function
    ///
    /// - Parameter coder: NSCoder
    /// - Parameter images: [String] to set the images of the cell
    init?(coder: NSCoder, images: [String]){
        self.images = images
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder){
        fatalError("not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setCollectionViewLayout(generateLayout(), animated: true, completion: nil)
    }
    

    /// function to generate the layout for collection view
    private func generateLayout() -> UICollectionViewLayout{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(400)), repeatingSubitem: item, count: 1)
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductImagesCollectionViewCell
        
        let image = images[indexPath.row]
        cell.image = image
        return cell
    }
}
