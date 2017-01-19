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
import FirebaseStorage
class NewUserViewController: FormViewController {
    var items: [Person] = []
    let ref = FIRDatabase.database().reference(withPath: "people")
    var personKey: String! = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.personKey == "") {
            self.navigationItem.title = "New User"
        } else {
            self.navigationItem.title = ""
        }
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
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            for item in snapshot.children {
                guard item is FIRDataSnapshot else {
                    continue
                }
                
                let person = Person(snapshot: item as! FIRDataSnapshot)
                let image = UIImage(named:"profile-picture")!
                self.uploadImage(key: person.key, image: image)
//                let data: NSData = NSMutableData.init(data: UIImageJPEGRepresentation(UIImage(named:"profile-picture")!, 0.005)!)
//                data.len
//        
//                let queue = DispatchQueue(label: "com.araujoraphael.ciklotest.uploadProfilePicture")
        
//                queue.async {
//                    var logFile = AWSS3PutObjectRequest()
//        
//                    logFile?.bucket = "ciklotest"
//                    logFile?.key = person.key
//                    logFile?.contentType = "image/jpeg"
//                    logFile?.body = data
//                    logFile?.contentLength = NSNumber(value: data.length) //[NSNumber numberWithInteger:[data length]];
//                    logFile?.acl = .publicRead;
//                    AWSS3.default().putObject(logFile)
//        
//                }
            }
        })
    }
    
    func uploadImage(key: String, image: UIImage){
        
        // get the image from a UIImageView that is displaying the selected Image
        
        // create a local image that we can use to upload to s3
        let path = "\(NSTemporaryDirectory())profile-picture.jpg"
        let imageData = UIImageJPEGRepresentation(UIImage(named:"profile-picture")!, 0.005)!
        
        // once the image is saved we can use the path to create a local fileurl
        
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: "gs://ciklotest.appspot.com")
        let profilePicRef = storageRef.child("people/\(key).png")

        _ = profilePicRef.put(imageData, metadata: nil) { (metadata, error) in
            print(">>> \(error)")
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL
            print(">>>> downloadURL")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func savePerson(_ sender: Any) {

        let valuesDictionary = form.values()
        
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
        
        self.ref.childByAutoId().setValue(person.toAnyObject())
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

