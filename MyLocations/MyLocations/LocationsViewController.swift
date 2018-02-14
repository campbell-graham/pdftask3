//
//  LocationsViewController.swift
//  MyLocations
//
//  Created by Campbell Graham on 14/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit
import CoreData

class LocationsViewController: UITableViewController {
    
    var locations = [Location]()
    var managedObjectContect: NSManagedObjectContext!
    
    init() {
        super.init(style: .plain)
        title = "Saved Locations"
        tabBarItem = UITabBarItem(title: "myTabBarItem", image: #imageLiteral(resourceName: "second"), selectedImage: #imageLiteral(resourceName: "second"))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        let fetchRequest = NSFetchRequest<Location>()
        let entity = Location.entity()
        fetchRequest.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            locations = try managedObjectContect.fetch(fetchRequest)
        } catch {
            fatalCoreDataError(error)
        }
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
        if let placemark = location.placemark {
            var text = ""
            if let s = placemark.subThoroughfare {
                text += s + " " }
            if let s = placemark.thoroughfare {
                text += s + ", "
            }
            if let s = placemark.locality {
                text += s }
            cell?.detailTextLabel?.text = text
        } else {
            cell?.detailTextLabel?.text = ""
        }
        return cell!
    }

}
