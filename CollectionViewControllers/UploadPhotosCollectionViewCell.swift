//
//  UploadPhotosCollectionViewCell.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 01/05/24.
//

import UIKit

protocol UploadPhotosCollectionViewCellDelegate: AnyObject {
    func didSelectImageViewInCell(_ cell: UploadPhotosCollectionViewCell)
}

class UploadPhotosCollectionViewCell: UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    /// outlets for view controllers properties
    @IBOutlet weak var inlayImg: UIImageView!
    @IBOutlet weak var overlayContent: UIView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var collectionCell: UIView!
    @IBOutlet weak var capturedPhoto: UIImageView!
    @IBOutlet weak var imageNumberLabel: UILabel!

    var selectedImage:UIImage?

    weak var delegate: UploadPhotosCollectionViewCellDelegate?
    override func awakeFromNib() {
        let tapGesture  = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        collectionCell.addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = 15
        overlayContent.layer.cornerRadius = 15
        inlayImg.layer.cornerRadius = 15
        capturedPhoto.layer.cornerRadius = 15
    }

    // notifying the delegate to set the image in the parent view
    @objc func didTapView() {
        delegate?.didSelectImageViewInCell(self)
    }
    
    func setSelectedImage(_ image: UIImage) {
        capturedPhoto.image = image
        selectedImage = image // Store the selected image
        overlayContent.isHidden = true
    }  
}

