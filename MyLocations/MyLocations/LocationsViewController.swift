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
        tabBarItem = UITabBarItem(title: "myTabBarItem", image: #imageLiteral(resourceName: "stack"), selectedImage: #imageLiteral(resourceName: "stack"))
        title = "Saved Locations"

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: "cell")
        view.backgroundColor = AppColors.backgroundColor
        tableView.separatorStyle = .none
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationTableViewCell
        cell.selectionStyle = .none
        let locationToDisplay = locationsToDisplay[indexPath.section][indexPath.row]
        if locationToDisplay.hasPhoto {
           cell.locationImageView.image = locationToDisplay.photoImage
        } else {
            cell.locationImageView.image = #imageLiteral(resourceName: "icons8-image-50")
        }
        
        let letters = NSCharacterSet.letters
        let range = locationToDisplay.locationDescription.rangeOfCharacter(from: letters)
        
        if range != nil {
            cell.locationDescriptionLabel.text = locationToDisplay.locationDescription.trimmingCharacters(in: NSCharacterSet.whitespaces)
        } else {
            cell.locationDescriptionLabel.text = "[No Description]"
        }
        
        cell.locationCategoryLabel.text = locationToDisplay.address
        return cell
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
                            object.removePhotoFile()
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
