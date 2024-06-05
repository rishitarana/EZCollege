//
//  UploadPhotosViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 01/05/24.
//

import UIKit

class UploadPhotosViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var prodTitle: String?
    var prodDesc: String?
    var prodImgs: [String] = []
    
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDesc: UILabel!
    
    @IBOutlet weak var showView: UIView!
    init?(coder: NSCoder, prodTitle: String, prodDesc: String){
        self.prodTitle = prodTitle
        self.prodDesc = prodDesc
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    var tappedIndexPath: IndexPath?
    var selectedCell:UploadPhotosCollectionViewCell?
    @IBOutlet weak var uploadPhotosCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AddRadius(layer: showView.layer)
        
        productTitle.text = "For: \(prodTitle!)"
        productDesc.text = prodDesc!
        
        if let layout = uploadPhotosCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                }
        uploadPhotosCollectionView.setCollectionViewLayout(generateLayout(), animated: false)
        addBottomBorder(outlet: uploadPhotosCollectionView)
    }
    
    //Bottom layer of collection view
    func addBottomBorder(outlet:UICollectionView)
    {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.placeholderText.cgColor
        borderLayer.frame = CGRect(x: 0, y: outlet.frame.size.height - 0.5, width: outlet.frame.width, height: 0.5)
        
        outlet.layer.addSublayer(borderLayer)
    }
    
    //Imagepicker view to set and store the captured images
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            if let selectedCell = selectedCell {
                selectedCell.setSelectedImage(pickedImage)
                let compressedImg = UIImage(data: pickedImage.jpegData(compressionQuality: 0)!)!
                
                if let index = uploadPhotosCollectionView.indexPath(for: selectedCell)?.row {
                    if index < prodImgs.count {
                        prodImgs[index] = convertImageToBase64String(image: compressedImg)!
                    } else {
                        prodImgs.append(convertImageToBase64String(image: compressedImg)!)
                    }
                }
                listButton.isEnabled = true
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    
    //Generating layout for collection view
    private func generateLayout()->UICollectionViewLayout
    {
        let spacing:CGFloat = 15
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = .init(top: spacing, leading: 0, bottom: 0, trailing: spacing )
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(128), heightDimension: .absolute(128))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        
        
        let section = NSCollectionLayoutSection(group: group)
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal

        
        let layout  = UICollectionViewCompositionalLayout(section: section,configuration: configuration)
            return layout
    }
    
    
    //Passing the product to next screen
    @IBSegueAction func finalStep(_ coder: NSCoder, sender: Any?) -> ListingDoneViewController? {
        createProduct.setProductImages(images: prodImgs)
        let product = createProduct.createProduct(user: user)
        
//        NotificationCenter.default.post(name: Notification.Name("userPreferenceChanged"), object: nil)
//        NotificationCenter.default.post(name: Notification.Name("productAdded"), object: nil)
        return ListingDoneViewController(coder: coder, product: product)
    }
}
extension UploadPhotosViewController:UICollectionViewDelegate,UICollectionViewDataSource
{
    
    //Number of items in a section in collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    
    //Dequeue the reusable cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = uploadPhotosCollectionView.dequeueReusableCell(withReuseIdentifier: "uploadPhotoCell", for: indexPath)as! UploadPhotosCollectionViewCell
        cell.delegate = self
        return cell
    }
}

extension UploadPhotosViewController:UploadPhotosCollectionViewCellDelegate
{
    
    //Presenting the image picker view
    func didSelectImageViewInCell(_ cell: UploadPhotosCollectionViewCell) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
        imagePicker.sourceType = .camera
        selectedCell = cell
        present(imagePicker, animated: true, completion: nil)
        }
}
