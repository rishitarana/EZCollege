//
//  Session.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 05/05/24.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

var currentUser: User?
var userFunctions: UserCreationAndSessionCreation = UserCreationAndSessionCreation()

func signOutUser() async throws {
    try Auth.auth().signOut()
}

func getUserDetails() async {
    guard let currUser = Auth.auth().currentUser else{
        return
    }
    let email = currUser.email!
    let docRef = database.collection(
        "users"
    ).document(
        email
    )
    do {
        let document = try await docRef.getDocument(source: .server).data()
        
        guard let data = document else {
            print(
                "Document does not exist"
            )
            return
        }
        
        guard let idStr = data["id"] as? String,
              let id = UUID(uuidString: idStr) as UUID?,
              let emailId = data["emailId"] as? String,
              let name = data["name"] as? String,
              let preferences = data["preferences"] as? [[String: Any]],
              let collegeName = data["collegeName"] as? String,
              let likedProducts = data["likedProducts"] as? [String],
              let password = data["password"] as? String,
              let listings = data["listings"] as? [String],
              let img = data["image"] as? String
        else{
            return
        }
        
        var userPreferences: [Preferences] = []
        preferences.map{ preference in
            guard let categoryString = preference["category"] as? String,
                    let category = Category(rawValue: categoryString),
                    let icon = preference["icon"] as? String,
                  let choice = preference["choice"] as? Int
            else{
                return
            }
            let userChoice = choice == 1 ? true: false
            userPreferences.append(Preferences(category: category, icon: icon, choice: userChoice))
        }
        
        var userListings:[Listing] = []
        
        listings.map{listing in
            guard let idStr = data["id"] as? String,
                  let id = UUID(uuidString: idStr),
                  let isExpired = data["isExpired"] as? Int
            else{
                return
            }
            let isExp = isExpired == 1 ? true: false
            userListings.append(Listing(product: id, isExpired: isExp))
        }
        
        let likedProds = likedProducts.map({UUID(uuidString: $0)!})
        
        user.createFetchedUser(id: id, email: emailId, name: name, collegeName: collegeName, userImage: img, likedProduct: likedProds, preferences: userPreferences, listings: userListings, password: password)
    } catch {
        print("Error fetching document: \(error)")
    }

}

func fetchUser(with id: UUID) async throws -> [String: String]?{
    var returnThingy: [String: String] = [:]
    do{
        let snapshot = try await database.collection("users").whereField("id", isEqualTo: id.uuidString).getDocuments()
        
        for document in snapshot.documents{
            let data = document.data()
            guard let name = data["name"] as? String,
                  let image = data["image"] as? String else{return nil}
            returnThingy["name"] = name
            returnThingy["image"] = image
        }
    }catch{}
    
    return returnThingy
}
