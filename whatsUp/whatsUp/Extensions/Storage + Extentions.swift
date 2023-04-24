//
//  Storage + Extentions.swift
//  whatsUp
//
//  Created by Dhanush S on 15/04/23.
//

import Foundation
import FirebaseStorage

enum firebaseStorageBuckets: String {
    case photos
    case attachments
    
}

extension Storage {
    func uploadData(for key: String, data: Data, bucket: firebaseStorageBuckets) async throws -> URL{
        let storageRef = Storage.storage().reference()
        let photoRef = storageRef.child("\(bucket.rawValue)/\(key)")
        let _ = try await photoRef.putDataAsync(data)
        let downloadURL = try await photoRef.downloadURL()
        return downloadURL
        
    }
}
