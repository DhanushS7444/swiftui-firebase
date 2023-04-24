//
//  UserModel.swift
//  whatsUp
//
//  Created by Dhanush S on 07/04/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class UserModel : ObservableObject {
    
    @Published var groups: [Group] = []
    @Published var chatMessages: [ChatMessage] = []
    
    var firestoreListener: ListenerRegistration?
    
    private func updateUserInfoForAllMessages(uid: String, updatedInfo: [AnyHashable: Any]) async throws {
        let db = Firestore.firestore()
        let groupDocuments = try await db.collectionGroup("groups").getDocuments().documents
        
        for groupDoc in groupDocuments {
           let messages = try await groupDoc.reference.collection("messages")
                .whereField("uid", isEqualTo: uid)
                .getDocuments().documents
            
            for message in messages {
                try await message.reference.updateData(updatedInfo)
            }
        }
    }
    
    func updateDisplayName(for user: User, displayName: String) async throws {
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        try await request.commitChanges()
        try await updateUserInfoForAllMessages(uid: user.uid, updatedInfo: ["displayName" : user.displayName ?? "Guest"])
    }
    
    func detachFirebaseListner() {
        self.firestoreListener?.remove()
    }
    
    func listenForChatMessages(in group: Group) {
        let db = Firestore.firestore()
        chatMessages.removeAll()
        guard let documentId = group.documentID else {return}
        self.firestoreListener = db.collection("groups")
            .document(documentId)
            .collection("messages")
            .order(by: "dateCreated", descending: false)
            .addSnapshotListener({ [weak self] snapshot, error in
                guard let snapshot = snapshot else {
                    print("error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if diff.type == .added {
                        let chatMessage = ChatMessage.fromSnapshot(snapshot: diff.document)
                        if let chatMessage {
                            let exist = self?.chatMessages.contains(where: { cm in
                                cm.documentId == chatMessage.documentId
                            })
                            if !exist! {
                                self?.chatMessages.append(chatMessage)
                            }
                        }
                    }
                }
            })
    }
    
    func saveGroup(group: Group, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore() //
        var docRef: DocumentReference? = nil
        docRef = db.collection("groups")
            .addDocument(data: group.toDictionary()) { [weak self] error in
                if error != nil {
                    completion(error)
                } else {
                    // add the group to group arrays
                    if let docRef {
                        var newGroup = group
                        newGroup.documentID = docRef.documentID
                        self?.groups.append(newGroup)
                        completion(nil)
                    } else {
                        completion(nil)
                    }
                }
            }
    }
    
    func populateGroups() async throws {
        let db = Firestore.firestore()
       let snapShot = try await db.collection("groups")
            .getDocuments()
        
        groups = snapShot.documents.compactMap { snapShot in
            // we need to get a group based on the snapshot
            Group.fromSnapShot(snapshot: snapShot)
        }
    }
    
    func saveChatMessageToGroup(chatMessage: ChatMessage, group: Group) async throws {
        let db = Firestore.firestore()
        guard let groupDocumentID = group.documentID else {return}
        let _ = try await db.collection("groups")
            .document(groupDocumentID)
            .collection("messages")
            .addDocument(data: chatMessage.toDictionary())
    }
    
    /*
    func saveChatMessageToGroup(chatText: String, group: Group, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        guard let groupDocumentID = group.documentID else {return}
        db.collection("groups")
            .document(groupDocumentID)
            .collection("messages")
            .addDocument(data: ["chatText": chatText]) { error in
                completion(error)
            }
    }*/
    
    func updatePhotoURL(for user: User, photoURL: URL) async throws {
        let request = user.createProfileChangeRequest()
        request.photoURL = photoURL
        try await request.commitChanges()
        // update userinfo for all messages
        try await updateUserInfoForAllMessages(uid: user.uid, updatedInfo: ["profilePhotoURL" : photoURL.absoluteString])
    }

}
