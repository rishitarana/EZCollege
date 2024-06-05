//
//  UploadToStorage.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 09/05/24.
//

import Foundation
import FirebaseStorage

func uploadBase64Images(base64Images: [String], completion: @escaping ([String]?, Error?) -> Void) {
    let storage = Storage.storage()
    var downloadURLs: [String] = []
    var errors: [Error] = []

    // Use a Dispatch Group to track when all uploads are complete
    let dispatchGroup = DispatchGroup()

    for base64ImageString in base64Images {
        dispatchGroup.enter()  // Enter the group for each upload

        // Convert base64 encoded string to Data
        guard let imageData = Data(base64Encoded: base64ImageString) else {
            dispatchGroup.leave()  // Leave the group if conversion fails
            continue
        }

        // Create a unique path for each image
        let imageRef = storage.reference().child("product_images").child(UUID().uuidString + ".jpg")

        // Upload the image data
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                errors.append(error)
                dispatchGroup.leave()
                return
            }

            // Retrieve the download URL
            imageRef.downloadURL { url, error in
                if let error = error {
                    errors.append(error)
                } else if let url = url {
                    downloadURLs.append(url.absoluteString)
                }
                dispatchGroup.leave()
            }
        }
    }

    // Once all uploads are complete, execute the completion handler
    dispatchGroup.notify(queue: .main) {
        if errors.isEmpty {
            completion(downloadURLs, nil)
        } else {
            completion(nil, errors.first)
        }
    }
}

func uploadBase64Images(base64Images: String, completion: @escaping (String?, Error?) -> Void) {
    let storage = Storage.storage()
    var downloadURL: String = ""
    var errors: [Error] = []

    // Use a Dispatch Group to track when all uploads are complete
    let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()

        guard let imageData = Data(base64Encoded: base64Images) else {
            dispatchGroup.leave()
            return
        }

        let imageRef = storage.reference().child("user_images").child(UUID().uuidString + ".jpg")

        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                errors.append(error)
                dispatchGroup.leave()
                return
            }

            imageRef.downloadURL { url, error in
                if let error = error {
                    errors.append(error)
                } else if let url = url {
                    downloadURL = url.absoluteString
                }
                dispatchGroup.leave()
            }
        }
    
    dispatchGroup.notify(queue: .main) {
        if errors.isEmpty {
            completion(downloadURL, nil)
        } else {
            completion(nil, errors.first)
        }
    }
}
