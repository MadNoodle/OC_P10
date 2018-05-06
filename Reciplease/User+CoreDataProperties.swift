//
//  User+CoreDataProperties.swift
//  
//
//  Created by Mathieu Janneau on 10/02/2018.
//
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var recipes: Recipe?

}
