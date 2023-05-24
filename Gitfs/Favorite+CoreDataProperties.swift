//
//  Favorite+CoreDataProperties.swift
//  
//
//  Created by Sagar Arora on 24/05/23.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var gif: String?
    @NSManaged public var id: String?

}
