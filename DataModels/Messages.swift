//
//  Messages.swift
//  EZCollege
//
//  Created by Abhay Aggarwal on 13/05/24.
//

import Foundation

import FirebaseFirestore

var allChats: [Chat] = []

func getChats() async {
    let id = user.getUser().id.uuidString
    database.collection("messages").whereField("involved", arrayContains: id).addSnapshotListener{ (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {return}
        
        allChats.removeAll()
        for document in documents {
            let ids = document.documentID.split(separator: "+")
            let data = document.data()
            guard let timestamp = data["timestamp"] as? Timestamp else {return}
            let date = timestamp.dateValue()
            var uuids: [UUID] = []
            for id in ids{
                uuids.append(UUID(uuidString: String(id))!)
            }
            allChats.append(Chat(id: uuids, on: UUID(uuidString: String(ids[1]))!, timestamp: date))
        }
        
        allChats.sort(by: >)
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("chatAdded"), object: nil)
        }
    }
}

var messages: [Message] = []

func getMessages(with id: String) async {
    print("Message getter")
    let docRef = database.collection("messages").document(id)
    
    docRef.addSnapshotListener{ documentSnapshot, error in
        guard let document = documentSnapshot else {
            return
        }
        guard let data = document.data() else {
            return
        }
        
        guard let allMessages = data["messages"] as? [[String: Any]] else{
            return
        }
        
        messages.removeAll()
        
        for message in allMessages {
            guard let messageStr = message["messages"] as? String,
                  let idStr = message["id"] as? String,
                  let id = UUID(uuidString: idStr),
                  let fromId = message["from"] as? String,
                  let from = UUID(uuidString: fromId),
                  let toId = message["to"] as? String,
                  let to = UUID(uuidString: toId),
                  let timestamp = message["timestamp"] as? Timestamp else {return}
            
            let date = timestamp.dateValue()
            
            if !messages.contains(where: {$0.id == id}){
                messages.insert(
                    Message(id: id, messages: messageStr, from: from, to: to, timestamp: date),at: 0
                )
            }
        }
        
        messages.sort()
        DispatchQueue.main.async{
            NotificationCenter.default.post(name: Notification.Name("chatLoaded"), object: nil)
        }
    }
}
