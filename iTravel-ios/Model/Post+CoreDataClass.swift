//
//  Post+CoreDataClass.swift
//  iTravel-ios
//
//  Created by Kely Sotsky on 09/06/2022.
//
//

import Foundation
import CoreData
import UIKit

@objc(PostDao)
public class PostDao: NSManagedObject {
    
    static var context:NSManagedObjectContext? = { () -> NSManagedObjectContext? in
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    static func getAllPosts()->[Post]{
        guard let context = context else {
            return []
        }

        do{
            let postDao = try context.fetch(PostDao.fetchRequest())
            var ptArray:[Post] = []
            for ptDao in postDao{
                ptArray.append(Post(post:ptDao))
            }
            return ptArray
        }catch let error as NSError{
            print("post fetch error \(error) \(error.userInfo)")
            return []
        }
    }
    
    static func add(post:Post){
        guard let context = context else {
            return
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let pt = PostDao(context: context)
        pt.id = post.id
        pt.title = post.title
        pt.userName = post.userName
        pt.post_description = post.description
        pt.location = post.location
        pt.difficulty = post.difficulty
        pt.lastUpdated = post.lastUpdated
        pt.photo = post.photo
        
        do{
            try context.save()
        }catch let error as NSError{
            print("student add error \(error) \(error.userInfo)")
        }
    }
    
    static func getPost(byId:String)->Post?{
        return nil
    }
    
    static func delete(post:Post){
        
    }
    
    static func localLastUpdated() -> Int64{
        return Int64(UserDefaults.standard.integer(forKey: "POSTS_LAST_UPDATE"))
    }
    
    static func setLocalLastUpdated(date:Int64){
        UserDefaults.standard.set(date, forKey: "POSTS_LAST_UPDATE")
    }
    
}