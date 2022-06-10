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
import FirebaseAuth
    

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
    
    //Didn't check if works - still didn't needed.
//    func getPost(byId:String, completion:@escaping (Post)->Void){
//        db.collection("Posts").document(byId).getDocument { (document, error) in
//            if let document = document, document.exists {
////                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                let dataDescription = document.data()
//                let p = Post.FromJson(json: dataDescription!)
//                print("Document data: \(p)")
//                completion(p)
//            } else {
//                print("Document does not exist")
//            }
//        }
//        
//    }
    

    func editPost(post:Post, completion:@escaping ()->Void){
        let id = String(post.id!)
        db.collection("Posts").document(id).updateData(    [
            "description": post.description!,
            "difficulty": post.difficulty!,
            "location": post.location!,
            "photo": post.photo!,
            "userName": post.userName!,
            "lastUpdated": FieldValue.serverTimestamp(),
            "title": post.title!,
            "isPostDeleted": post.isPostDeleted!
            
        ]) { (error) in
            if error == nil {
                print("Post updated")
            }else{
                print("Post not updated")
            }
            completion()
        }
    }
    
    func deletePost(post:Post, completion:@escaping ()->Void){
        db.collection("Posts").document(post.id!).delete() { err in
            if let err = err {
                print("Error deleting document: \(err)")
            } else {
                print("Document deleted successfully")
            }
            completion()
        }
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
    
    func add(user:User, completion:@escaping ()->Void){
        db.collection("Users").document(user.email!)
            .setData(user.toJson())
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with")
            }
            completion()
        }
    }
    
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
          Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
              if let user = authResult?.user {
                  print(user)
                  completionBlock(true)
              } else {
                  completionBlock(false)
              }
          }
      }
    
}
