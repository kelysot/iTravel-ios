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
    
    
    //************************USER************************//
    
    func getConnectedUser(completion:@escaping (User)->Void){
        //Get specific document from current user
        let docRef = Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.email ?? "")
                       docRef.getDocument { (document, error) in
                var user = User()
                           if let error = error{
                               print("TAG USER\(error)")
                               completion(user)
                           }
                           else{
                   guard let document = document, document.exists else {
                       print("Document does not exist")
                       return
                    }
                               let dataDescription = document.data()
                               user = User.FromJson(json: dataDescription!)
                               print("TAG USER          ::::: \(user.email)")
                               print("TAG USER          ::::: \(user.fullName)")
                               print("TAG USER          ::::: \(user.nickName)")
                               print("TAG USER          ::::: \(user.photo)")
                               completion(user)
                }

//                   guard let fullname = dataDescription?["fullName"] else { return }
//                   guard let email = dataDescription?["email"] else { return }
//                   guard let photo = dataDescription?["photo"] else { return }
//                   guard let nickName = dataDescription?["nickName"] else { return }
//                   guard let posts = dataDescription?["posts"] else { return }
//
//                   user.nickName = nickName as? String
//                   user.email = email as? String
//                   user.photo = photo as? String
//                   user.fullName = fullname as? String
//                   user.posts = (posts as? [String])!
        
               }
       
//        guard let userID = Auth.auth().currentUser?.uid{
//            db.collection("Users").document(userId)
//        } else { return }
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
                  print("TAG USER \(error)")
                  completionBlock(false)
              }
          }
      }
    
    func signIn(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error{
                print("TAG USER \(error)")
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
    
    func signOut(){
        do {
          try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
}
