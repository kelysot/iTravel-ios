//
//  Model.swift
//  iTravel-ios
//
//  Created by Kely Sotsky on 05/06/2022.
//

import Foundation
import UIKit
import CoreData

class ModelNotificatiponBase{
    let name:String
    init(_ name:String){
        self.name=name
    }
    func observe(callback:@escaping ()->Void){
        NotificationCenter.default.addObserver(forName: Notification.Name(name), object: nil, queue: nil){ data in
            NSLog("got notify")
            callback()
        }
    }
    
    func post(){
        NSLog("post notify")
        NotificationCenter.default.post(name: Notification.Name(name), object: self)
    }

}

class Model{


    let firebaseModel = ModelFirebase()
    let dispatchQueue = DispatchQueue(label: "com.iTravel-ios")

    // Notification center
    static let postDataNotification = ModelNotificatiponBase("com.iTravel.ios")
    
    static let instance = Model()
    
    func getAllPosts(completion:@escaping ([Post])->Void){
        //get the Local Last Update data
        var lup = PostDao.localLastUpdated()
        NSLog("TAG POSTS_LAST_UPDATE " + String(lup))
        
        //fetch all updated records from firebase
        firebaseModel.getAllPosts(since: lup){ posts in
            //insert all records to local DB
            NSLog("TAG firebaseModel.getAllPosts in \(posts.count)")
            self.dispatchQueue.async{
                for post in posts {
                    PostDao.add(post: post)
                    if post.lastUpdated > lup {
                        lup = post.lastUpdated
                    }
                }
                //update the local last update date
                PostDao.setLocalLastUpdated(date: lup)
                
                DispatchQueue.main.async {
                    //return all records to caller
                    completion(PostDao.getAllPosts())
                }
            }
        }
        
    }
    
    func add(post:Post, completion: @escaping ()->Void){
        firebaseModel.add(post: post){
            completion()
            Model.postDataNotification.post()
        }
    }
    
    func getPost(byId:String)->Post?{
        return firebaseModel.getPost(byId: byId)
    }
    
    func delete(post:Post){
        firebaseModel.delete(post: post)
    }
    
    func uploadImage(name:String, image:UIImage, callback:@escaping(_ url:String)->Void){
        firebaseModel.uploadImage(name: name, image: image, callback: callback)
    }
}
