//
//  Person.swift
//  CikloTest
//
//  Created by Raphael Araújo on 1/16/17.
//  Copyright © 2017 Raphael Araújo. All rights reserved.
//

import Foundation
import Firebase
struct Person {
    let key: String
    let names: String
    let surnames: String
    let age: Int
    let phoneNumber: String
    let latitude: Double
    let longitude: Double
    let picture: UIImage?
    let ref: FIRDatabaseReference?
    
    init(names: String, surnames: String, age: Int, phoneNumber: String, latitude: Double = 0.0, longitude: Double = 0.0, picture: UIImage, key: String = "") {
        self.key = key
        self.names = names
        self.surnames = surnames
        self.age = age
        self.phoneNumber = phoneNumber
        self.latitude = latitude
        self.longitude = longitude
        self.picture = picture
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        names = snapshotValue["names"] as! String
        surnames = snapshotValue["surnames"] as! String
        age = snapshotValue["age"] as! Int
        phoneNumber = snapshotValue["phoneNumber"] as! String
        latitude = snapshotValue["latitude"] as! Double
        longitude = snapshotValue["longitude"] as! Double
        picture = snapshotValue["picture"] as? UIImage
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "names": names,
            "surnames": surnames,
            "age": age,
            "phoneNumber": phoneNumber,
            "latitude": latitude,
            "longitude": longitude
        ]
    }

}
