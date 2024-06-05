//
//  RegisterPhotoTableViewController.swift
//  EZCollege
//
//  Created by Abhay(IOS) on 02/05/24.
//

import UIKit

class RegisterPhotoTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var titleString: UILabel!
    @IBOutlet weak var inlayImg: UIImageView!
    @IBOutlet weak var overlayTest: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    var imgString: String = ""
    
    @IBOutlet weak var nextBtn: UIButton!
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImg.layer.cornerRadius = profileImg.frame.width/2
        overlayTest.layer.cornerRadius = overlayTest.frame.width/2
        
        inlayImg.layer.cornerRadius = inlayImg.frame.width/2 - 10
        
        titleString.text = "Welcome, \(user.getName().split(separator: " ")[0])"
        nextBtn.isEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapTap))
        overlayTest.addGestureRecognizer(tap)
    }
    @objc func tapTap()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker,animated: true,completion: nil)
    }
    
    @IBAction func proceed(_ sender: Any) {
        user.putImage(image: imgString)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage
        {
            profileImg.image = selectedImage
            let compressedImg = UIImage(data: selectedImage.jpegData(compressionQuality: 0)!)!
            imgString = convertImageToBase64String(image: compressedImg)!
            nextBtn.isEnabled = true
            overlayTest.layer.opacity = 0
        }
        picker.dismiss(animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

