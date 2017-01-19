//
//  MasterViewController.swift
//  CikloTest
//
//  Created by Raphael Araújo on 1/15/17.
//  Copyright © 2017 Raphael Araújo. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var people = [Person]()
    let ref = FIRDatabase.database().reference(withPath: "people")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newUser(_:)))
        addButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        ref.observe(.value, with: { snapshot in
            var newItems: [Person] = []
            
            // 3
            for item in snapshot.children {
                // 4
                let groceryItem = Person(snapshot: item as! FIRDataSnapshot)
                newItems.append(groceryItem)
            }
            
            // 5
            self.people = newItems
            print(">>>> PEOPLE \(self.people)")
            self.tableView.reloadData()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func newUser(_ sender: Any) {
        self.performSegue(withIdentifier: "newUserSegue", sender: nil)
//        users.insert(NSDate(), at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userDetailSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let user = people[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = user

            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let person = people[indexPath.row]
        cell.textLabel!.text = "\(person.names) \(person.surnames)"
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            objects.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
    }


}

