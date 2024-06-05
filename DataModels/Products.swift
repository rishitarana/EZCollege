//
//  Products.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 05/05/24.
//

import Foundation
import Firebase
var allProducts: [Product] = []

var promotedProducts: [UUID] = []
var productsIds: [UUID] = []

func getProducts() async throws {
    do{
        let snapshot = try await database.collection("products").getDocuments()
        
        for document in snapshot.documents{
            let data = document.data()
            
            guard let productId = data["id"] as? String,
                  let id = UUID(uuidString: productId),
                  let name = data["name"] as? String,
                  let listedById = data["listedBy"] as? String,
                  let listedBy = UUID(uuidString: listedById),
                  let timestamp = data["listedAt"] as? Timestamp,
                  let views = data["views"] as? Int,
                  let imagesStrings = data["images"] as? [String],
                  let price = data["price"] as? Int,
                  let conditionStr = data["condition"] as? String,
                  let condition = Condition(rawValue: conditionStr),
                  let description = data["description"] as? String,
                  let categoryStr = data["category"] as? String,
                  let category = Category(rawValue: categoryStr),
                  let isPromoted = data["isPromoted"] as? Int else{
                return
            }
            
            let date = timestamp.dateValue()
            
            let isPromotedBool = isPromoted == 1 ? true: false
            
            let product = Product(
                id: id,
                name: name,
                listedBy: listedBy,
                listedAt: date,
                views: views,
                productImages: imagesStrings,
                price: price,
                condition: condition,
                description: description,
                category: category,
                isPromoted: isPromotedBool
            )
            
            allProducts.append(product)
            productsIds.append(id)
             
            if (allProducts.count % 10 == 0 || allProducts.count == snapshot.documents.count){
                DispatchQueue.main.async{
                    promotedProducts = allProducts.filter{ product in
                        if let promoted = product.isPromoted, promoted{
                            return true
                        }
                        return false
                    }.map{$0.id}
                    
                    NotificationCenter.default.post(name: Notification.Name("userPreferenceChanged"), object: nil)
                    NotificationCenter.default.post(name: Notification.Name("productAdded"), object: nil)
                }
            }
        }
    } catch{}
    
}

func listenToChanges() async {
    let collectionRef = database.collection("products")
    let query = collectionRef.order(by: "listedAt", descending: true).limit(to: 1)
    
    let _ = query.addSnapshotListener { (snapshot, error) in
        if let _ = error {
            return
        }
        
        guard let snapshot = snapshot else { return }
        
        if let document = snapshot.documents.first {
            let data = document.data()
            
            guard let productId = data["id"] as? String,
                  let id = UUID(uuidString: productId),
                  let name = data["name"] as? String,
                  let listedById = data["listedBy"] as? String,
                  let listedBy = UUID(uuidString: listedById),
                  let timestamp = data["listedAt"] as? Timestamp,
                  let views = data["views"] as? Int,
                  let imagesStrings = data["images"] as? [String],
                  let price = data["price"] as? Int,
                  let conditionStr = data["condition"] as? String,
                  let condition = Condition(rawValue: conditionStr),
                  let description = data["description"] as? String,
                  let categoryStr = data["category"] as? String,
                  let category = Category(rawValue: categoryStr),
                  let isPromoted = data["isPromoted"] as? Int else {
                return
            }
            
            let date = timestamp.dateValue()
            
            let isPromotedBool = isPromoted == 1 ? true : false

            
            let product = Product(
                id: id,
                name: name,
                listedBy: listedBy,
                listedAt: date,
                views: views,
                productImages: imagesStrings,
                price: price,
                condition: condition,
                description: description,
                category: category,
                isPromoted: isPromotedBool
            )
            
            if !productsIds.contains(where: {$0 == id}) {
                productsIds.append(id)
                allProducts.insert(product, at: 0)
            }
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("userPreferenceChanged"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("productAdded"), object: nil)
            }
        }
    }
}
func fetchImageAndConvertToBase64(from imageURL: URL) async throws -> String {
    let (data, _) = try await URLSession.shared.data(from: imageURL)

    let base64String = data.base64EncodedString()
    return base64String
}
