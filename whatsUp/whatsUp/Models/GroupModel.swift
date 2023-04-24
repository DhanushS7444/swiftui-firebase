//
//  GroupModel.swift
//  whatsUp
//
//  Created by Dhanush S on 11/04/23.
//

import Foundation
import FirebaseFirestore

struct Group: Codable, Identifiable {
    var documentID: String? = nil
    let subject: String
    
    var id : String {
        documentID ?? UUID().uuidString
    }
}

extension Group {
    func toDictionary() -> [String: Any] {
        return ["subject": subject]
    }
    
    static func fromSnapShot(snapshot: QueryDocumentSnapshot) -> Group? {
        let dictionary = snapshot.data()
        guard let subject = dictionary["subject"] as? String else {
            return nil
        }
        
        return Group(documentID: snapshot.documentID, subject: subject)
    }
}
