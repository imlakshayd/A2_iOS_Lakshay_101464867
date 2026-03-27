//
//  Product+CoreDataProperties.swift
//  A2_iOS_Lakshay_101464867
//
//  Created by Lakshay on 2026-03-27.
//

import Foundation
import CoreData

extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var productID: Int32
    @NSManaged public var productName: String?
    @NSManaged public var productDescription: String?
    @NSManaged public var productPrice: Double
    @NSManaged public var productProvider: String?

}

extension Product : Identifiable {

}
