//
//  Recipe+CoreDataProperties.swift
//  
//
//  Created by Mathieu Janneau on 31/01/2018.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var id: String?
    @NSManaged public var image: String?
    @NSManaged public var ingredients: [String]?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var recipeName: String?
    @NSManaged public var totalTime: String?
    @NSManaged public var yield: String?

}
