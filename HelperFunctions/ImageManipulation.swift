//
//  ImageManipulation.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 06/05/24.
//

import Foundation
import UIKit


func convertImageToBase64String(image: UIImage) -> String? {
    guard let imageData = image.jpegData(compressionQuality: 1.0) else {
        return nil
    }
    
    let base64String = imageData.base64EncodedString()
    
    return base64String
}

func convertBase64StringToImage(base64String: String) -> UIImage? {
    guard let imageData = Data(base64Encoded: base64String) else {
        return nil
    }
    
    let image = UIImage(data: imageData)
    return image
}

func renderImageFromUrl(from url: URL) async throws -> UIImage{
    let request = URLRequest(url: url)
    let (data, _) = try await URLSession.shared.data(for: request)
    
    guard let image = UIImage(data: data) else {
        throw NSError(domain: "ImageConversionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert data to UIImage."])
    }
        
    return image
}
