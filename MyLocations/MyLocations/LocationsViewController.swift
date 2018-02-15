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
    var locationsToDisplay = [[Location]]()
    var managedObjectContext: NSManagedObjectContext!
    var categories = [String]()
    
    init() {
        super.init(style: .grouped)
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    //currently reloads everything from core data into the locations array every time the page appears, should be changed later if possible
    override func viewDidAppear(_ animated: Bool) {
        
        categories.removeAll()
        locationsToDisplay.removeAll()
        
        
        let fetchRequest = NSFetchRequest<Location>()
        let entity = Location.entity()
        fetchRequest.entity = entity
        let sortDescriptorDate = NSSortDescriptor(key: "date", ascending: true)
        let sortDescriptorCategory = NSSortDescriptor(key: "category", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorDate, sortDescriptorCategory]
        do {
            locations = try managedObjectContext.fetch(fetchRequest)
        } catch {
            fatalCoreDataError(error)
        }
        
        for l in locations {
            if !categories.contains(l.category) {
                categories.append(l.category)
            }
        }
        
        
        for c in categories {
            locationsToDisplay.append(locations.filter({$0.category == c}))
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       return categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsToDisplay[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = locationsToDisplay[indexPath.section][indexPath.row].locationDescription
        cell?.detailTextLabel?.text = locationsToDisplay[indexPath.section][indexPath.row].address
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            let destination = LocationDetailsViewController(locationToEdit: self.locationsToDisplay[editActionsForRowAt.section][editActionsForRowAt.row])
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
                        print(object.locationDescription)
                        if object == self.locationsToDisplay[editActionsForRowAt.section][editActionsForRowAt.row]{
                            self.managedObjectContext.delete(object)
                            self.locationsToDisplay[editActionsForRowAt.section].remove(at: editActionsForRowAt.row)
                            break
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
