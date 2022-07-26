//
//  Post.swift
//  iTravel-ios
//
//  Created by Kely Sotsky on 05/06/2022.
//

import Foundation
import Firebase

class Post: Hashable, Equatable{

    public var id: String? = ""
    public var title: String? = ""
    public var userName: String? = ""
    public var description: String? = ""
    public var location: String? = ""
    public var difficulty: String? = ""
    public var lastUpdated:Int64 = 0
    public var photo: String? = ""
    public var isPostDeleted: String? = ""
    public var coordinate: String? = ""


    var hashValue: Int { get { return id.hashValue } }

    
    init(){}

    init(post:PostDao){
        id = post.id
        title = post.title
        userName = post.userName
        description = post.post_description
        location = post.location
        difficulty = post.difficulty
        lastUpdated = post.lastUpdated
        photo = post.photo
        isPostDeleted = post.isPostDeleted
        coordinate = post.coordinate
    }
    
    static func ==(left:Post, right:Post) -> Bool {
        return left.id == right.id
    }
}

extension Post {
    static func FromJson(json:[String:Any])->Post{
        
        let p = Post()
        p.id = json["id"] as? String
        p.title = json["title"] as? String
        p.userName = json["userName"] as? String
        p.description = json["description"] as? String
        p.location = json["location"] as? String
        p.difficulty = json["difficulty"] as? String
        p.photo = json["photo"] as? String
        p.isPostDeleted = json["isPostDeleted"] as? String
        p.coordinate = json["coordinate"] as? String

        if let lup = json["lastUpdated"] as? Timestamp{
            p.lastUpdated = lup.seconds
        }
            
        return p

    }
    
    func toJson()->[String:Any]{
        
        var json = [String:Any]()
        
        json["id"] = self.id!
        json["title"] = self.title!
        json["userName"] = self.userName!
        json["description"] = self.description!
        json["location"] = self.location!
        json["difficulty"] = self.difficulty!
        json["photo"] = self.photo!
        json["lastUpdated"] = FieldValue.serverTimestamp()
        json["isPostDeleted"] = self.isPostDeleted!
        json["coordinate"] = self.coordinate!

        return json
    }
    
}
