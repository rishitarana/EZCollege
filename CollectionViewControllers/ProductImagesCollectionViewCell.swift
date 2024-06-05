//
//  ProductImagesCollectionViewCell.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 07/05/24.
//

import UIKit

class ProductImagesCollectionViewCell: UICollectionViewCell {
    var image: String!{
        didSet{
            configureCell()
        }
    }
    
    @IBOutlet weak var productImage: UIImageView!
    
    override func prepareForReuse() {
        productImage.image = nil
    }
    
    func configureCell(){
        Task{
            do{
                let img = try await renderImageFromUrl(from: URL(string: image)!)
                DispatchQueue.main.async{
                    self.productImage.image = img
                }
            }catch{}
        }
    }
}
