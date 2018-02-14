//
//  LocationsViewController.swift
//  MyLocations
//
//  Created by Campbell Graham on 14/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class LocationsViewController: UITableViewController {
    
    var locations = [Location]()
    var managedObjectContext: NSManagedObjectContext!
    
    init() {
        super.init(style: .plain)
        tabBarItem = UITabBarItem(title: "myTabBarItem", image: #imageLiteral(resourceName: "second"), selectedImage: #imageLiteral(resourceName: "second"))
         title = "Saved Locations"

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    //currently reloads everything from core data into the locations array every time the page appears, should be changed later if possible
    override func viewDidAppear(_ animated: Bool) {
        let fetchRequest = NSFetchRequest<Location>()
        let entity = Location.entity()
        fetchRequest.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            locations = try managedObjectContext.fetch(fetchRequest)
        } catch {
            fatalCoreDataError(error)
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        let location = locations[indexPath.row]
        cell?.textLabel?.text = location.locationDescription
        cell?.detailTextLabel?.text = location.address
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            let destination = LocationDetailsViewController(locationToEdit: self.locations[editActionsForRowAt.row])
            destination.managedObjectContext = self.managedObjectContext
            self.present(UINavigationController(rootViewController: destination), animated: true, completion: nil)
        }
        more.backgroundColor = .lightGray
    
        
        let share = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            do {
                let fetchRequest = NSFetchRequest<Location>()
                let entity = Location.entity()
                fetchRequest.entity = entity
                if let result = try? self.managedObjectContext.fetch(fetchRequest) {
                    for object in result {
                        if object == self.locations[editActionsForRowAt.row] {
                            self.managedObjectContext.delete(object)
                            self.locations.remove(at: editActionsForRowAt.row)
                        }
                    }
                }
               try self.managedObjectContext.save()
            } catch {
                print("Error deleting/saving")
            }
            self.tableView.reloadData()
        }
        share.backgroundColor = .red
        
        return [share, more]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}
