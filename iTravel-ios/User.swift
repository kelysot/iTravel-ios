//
//  User.swift
//  iTravel-ios
//
//  Created by Bar Elimelech on 08/06/2022.
//

import Foundation

class User{
    
    public var fullName: String? = ""
    public var nickName: String? = ""
    public var email: String? = ""
    public var photo: String? = ""
    public var posts: [String]?


    init(){}

    
//    init(post:PostDao){
//        id = post.id
//        title = post.title
//        usename = post.usename
//        description = post.description
//        location = post.location
//        difficulty = post.difficulty
//        photo = post.photo
//    }
}


extension User{
    static func FromJson(json:[String:Any])->User{
        let user = User()
        user.fullName = json["fullName"] as? String
        user.nickName = json["nickName"] as? String
        user.email = json["email"] as? String
        user.photo = json["photo"] as? String
        user.posts = json["posts"] as? [String]

        return user
    }
    
    func toJson()->[String:Any]{
        var json = [String:Any]()
        json["fullName"] = self.fullName
        json["nickName"] = self.nickName
        json["email"] = self.email
        json["photo"] = self.photo!
        json["posts"] = self.posts
       return json
    }
}
