//
//  Post+CoreDataProperties.swift
//  iTravel-ios
//
//  Created by Kely Sotsky on 09/06/2022.
//
//

import Foundation
import CoreData


extension PostDao {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostDao> {
        return NSFetchRequest<PostDao>(entityName: "PostDao")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var userName: String?
    @NSManaged public var location: String?
    @NSManaged public var post_description: String?
    @NSManaged public var difficulty: String?
    @NSManaged public var lastUpdated: Int64
    @NSManaged public var photo: String?

}

extension PostDao : Identifiable {

}
