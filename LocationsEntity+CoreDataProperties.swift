//
//  LocationsEntity+CoreDataProperties.swift
//  ArjunS2Project
//
//  Created by Sachin Madhav on 2021-10-10.
//
//

import Foundation
import CoreData


extension LocationsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationsEntity> {
        return NSFetchRequest<LocationsEntity>(entityName: "LocationsEntity")
    }

    @NSManaged public var birthday: Date?
    @NSManaged public var country: String?
    @NSManaged public var gender: String?
    @NSManaged public var image: Data?
    @NSManaged public var lattitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?

}

extension LocationsEntity : Identifiable {

}
