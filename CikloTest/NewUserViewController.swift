//
//  NewUserViewController.swift
//  CikloTest
//
//  Created by Raphael Araújo on 1/15/17.
//  Copyright © 2017 Raphael Araújo. All rights reserved.
//

import UIKit
import Eureka
import MapKit
import CoreLocation
import FirebaseDatabase

class NewUserViewController: FormViewController {
    var items: [Person] = []
    let ref = FIRDatabase.database().reference(withPath: "people")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(savePerson(_:)))
        addButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = addButton
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        }
        
        form = Section("Personal Data")
            <<< ImageRow() { row in
                row.title = "Picture"
                row.tag = "PictureRow"
                row.add(rule: RuleRequired())
            }

            <<< TextRow(){ row in
                row.title = "Names"
                row.placeholder = "Ex: Raphael"
                row.tag = "NamesRow"
                row.add(rule: RuleRequired())
            }
            .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            <<< TextRow(){ row in
                row.title = "Surnames"
                row.placeholder = "Ex: Alves de Araújo"
                row.tag = "SurnamesRow"

            }
            .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            <<< IntRow(){ row in
                row.title = "Age"
                row.placeholder = "Ex: 99"
                row.tag = "AgeRow"

            }
            
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            <<< PhoneRow(){
                $0.title = "Phone Number"
                $0.placeholder = "Ex: 9999.9999"
                $0.tag = "PhoneRow"

            }
            .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            +++ Section("Location")
            <<< LocationRow() {
                $0.title = "LocationRow"
                $0.value = CLLocation(latitude: -8.0460854, longitude: -35.0728262)
                $0.tag = "LocationRow"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func savePerson(_ sender: Any) {

        let valuesDictionary = form.values()

        print(">>> \(valuesDictionary)")
        
        let names = valuesDictionary["NamesRow"] as? String
        
        let surnames = valuesDictionary["SurnamesRow"] as? String
        let age = valuesDictionary["AgeRow"] as? Int
        let phone = valuesDictionary["PhoneRow"] as? String
        let location = valuesDictionary["LocationRow"] as? CLLocation
        let picture = valuesDictionary["PictureRow"] as? UIImage
        
        if(surnames == nil || age == nil || phone == nil || location == nil || picture == nil) {
            let alert = UIAlertController.init(title: "", message: "All fields are required!", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let person = Person(names: names!,
                                      surnames: surnames!,
                                      age: age!,
                                      phoneNumber: phone!,
                                      latitude: location!.coordinate.latitude,
                                      longitude: location!.coordinate.longitude,
                                      picture: picture!)
        let childRef = self.ref.child("person")
        childRef.setValue(person.toAnyObject())

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

