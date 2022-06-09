//
//  ModelFirebase.swift
//  iTravel-ios
//
//  Created by Kely Sotsky on 05/06/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
import FirebaseStorage
import UIKit

class ModelFirebase{
    
    let db = Firestore.firestore()
    let storage = Storage.storage()

    init(){}
    
    func getAllPosts(since:Int64, completion:@escaping ([Post])->Void){
        db.collection("Posts").whereField("lastUpdated", isGreaterThanOrEqualTo: Timestamp(seconds: since, nanoseconds: 0)).getDocuments() { (querySnapshot, err) in
            var posts = [Post]()
            if let err = err {
                print("Error getting documents: \(err)")
                completion(posts)
            } else {
                for document in querySnapshot!.documents {
                    let p = Post.FromJson(json: document.data())
                    posts.append(p)
                    completion(posts)
                }
            }
        }
        
    }
    
    func add(post:Post, completion:@escaping ()->Void){
        db.collection("Posts").document(post.id!)
            .setData(post.toJson())
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with")
            }
            completion()
        }
    }
    
    func getPost(byId:String)->Post?{
        return nil
    }
    
    func delete(post:Post){

    }
    
    func uploadImage(name: String, image: UIImage, callback: @escaping (_ url:String)-> Void){
        let storageRef = storage.reference()
        let imageRef = storageRef.child(name)
        let data = image.jpegData(compressionQuality: 0.8)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        imageRef.putData(data!, metadata: metaData) { (metaData, error) in
            imageRef.downloadURL { (url, error) in
                let urlString = url?.absoluteString
                callback(urlString!)
            }
        }
    }
    
}
