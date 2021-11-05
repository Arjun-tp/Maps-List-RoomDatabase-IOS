//
//  LocationsEntity+CoreDataClass.swift
//  ArjunS2Project
//
//  Created by Sachin Madhav on 2021-10-10.
//
//

import Foundation
import CoreData
import MapKit

@objc(LocationsEntity)
public class LocationsEntity: NSManagedObject, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(lattitude,longitude)
    }
    public var title: String?{
        return name
    }
    public var subtitle: String?{
        return country
    }
}
