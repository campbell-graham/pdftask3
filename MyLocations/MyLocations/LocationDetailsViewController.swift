//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Campbell Graham on 13/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class LocationDetailsViewController: UITableViewController, CategoryPickerTableViewControllerDelegate {
    
    var doneButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    var location: CLLocation?
    var address: String?
    var date = Date()
    let formatter = DateFormatter()
    var managedObjectContext: NSManagedObjectContext!
    var placemark: CLPlacemark?
    var categoryName: String?
    var locationToEdit: Location?
    var imageView = UIImageView()
    var image: UIImage?
    var descriptionText = ""
    var categoryText = "No Category"
    
    init(location: CLLocation, address: String, placemark: CLPlacemark?) {
        
        self.location = location
        self.address = address
        self.placemark = placemark
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        
        super.init(style: .grouped)
    }
    
    init(locationToEdit: Location) {
        self.locationToEdit = locationToEdit
        self.descriptionText = (self.locationToEdit?.locationDescription)!
        self.categoryText = (self.locationToEdit?.category)!
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        if locationToEdit.hasPhoto {
            image = locationToEdit.photoImage
        }
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if locationToEdit != nil {
            title = "Edit Locaiton"
        } else {
            title = "Tag Location"
        }
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "textFieldCell")
        navigationItem.largeTitleDisplayMode = .never
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        if indexPath != nil && indexPath!.section == 0 && indexPath!.row == 0 {
            return
        }
        
        (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldTableViewCell).textField.resignFirstResponder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 4
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if image != nil && indexPath.section == 1 && indexPath.row == 0 {
            return 280
        }
        
        return indexPath.section == 0 && indexPath.row == 0 ? 100 : 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.section == 0 && indexPath.row == 1 {
            let destination = CategoryPickerTableViewController()
            destination.delegate = self
            navigationController?.pushViewController(destination, animated: true)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            pickPhoto()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Description"
        case 1:
            return "Image"
        case 2:
            return "Details"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldTableViewCell
            cell.textField.text = descriptionText
            return cell
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        //generate the cell if one has not been made previously 
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        }
        configureCell(for: cell!, at: indexPath)
        return cell!
    }
    
    func configureCell(for cell: UITableViewCell, at location: IndexPath) {
        if location.section == 0 {
            switch location.row {
            case 1:
                cell.textLabel?.text = "Category"
                cell.detailTextLabel?.text = categoryText
                cell.accessoryType = .disclosureIndicator
            default:
                print("Error: Cell location is invalid")
            }
        } else if location.section == 1 {
            cell.accessoryType = .disclosureIndicator
            if image != nil {
                imageView.tag = 1
                imageView.frame = CGRect(x: 10, y: 10, width: 260, height: 260)
                imageView.image = image
                cell.contentView.addSubview(imageView)
            } else {
                cell.contentView.viewWithTag(1)?.removeFromSuperview()
                cell.textLabel?.text = "Add Photo"
            }
            
        } else if location.section == 2 {
            cell.selectionStyle = .none
            switch location.row {
            case 0:
                cell.textLabel?.text = "Latitude"
                cell.detailTextLabel?.text = locationToEdit != nil ? String(format: "%.8f", (locationToEdit?.latitude)!) : String(format: "%.8f", (self.location?.coordinate.latitude)!)
            case 1:
                cell.textLabel?.text = "Longitude"
                cell.detailTextLabel?.text = locationToEdit != nil ? String(format: "%.8f", (locationToEdit?.longitude)!) : String(format: "%.8f", (self.location?.coordinate.longitude)!)
            case 2:
                cell.textLabel?.text = "Address"
                cell.detailTextLabel?.text = locationToEdit != nil ? locationToEdit?.address : address
            case 3:
                cell.textLabel?.text = "Date"
                cell.detailTextLabel?.text = locationToEdit != nil ? formatter.string(from: (locationToEdit?.date)!) : formatter.string(from: date)
            default:
                cell.textLabel?.text = ""
            }
        } else {
            print("Error: Cell location is invalid")
        }
        
        
    }
    
    @objc func done() {
        let hudView = HudView.hud(inView: navigationController!.view, animated: true)
        
        let locationToAdd: Location
        
        if let temp = locationToEdit {
            hudView.text = "Edited"
            locationToAdd = temp
        } else {
            hudView.text = "Tagged"
            locationToAdd = Location(context: managedObjectContext)
            locationToAdd.latitude = (location?.coordinate.latitude)!
            locationToAdd.photoID = nil
            locationToAdd.address = address!
            locationToAdd.longitude = (location?.coordinate.longitude)!
            locationToAdd.date = date
        }
        
        
        locationToAdd.locationDescription = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldTableViewCell).textField.text!
        locationToAdd.category = (tableView.cellForRow(at: IndexPath(item: 1, section: 0))?.detailTextLabel?.text)!
        
        
        if let placemark = placemark {
            locationToAdd.placemark = placemark
        }
        
        
        if let image = image {
            if !locationToAdd.hasPhoto {
                locationToAdd.photoID = Location.nextPhotoID() as NSNumber
            }
            if let data = UIImageJPEGRepresentation(image, 0.5) {
                do {
                    try data.write(to: locationToAdd.photoURL, options: .atomic)
                } catch {
                    print("Error saving photo")
                }
            }
        } else if locationToAdd.hasPhoto {
            locationToAdd.removePhotoFile()
        }
        
        do {
            try managedObjectContext.save()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.cancel()
            }
        } catch {
            fatalCoreDataError(error)
        }
        
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func categoryPickerTableViewController(_ class: CategoryPickerTableViewController, didSelectCategory category: String) {
        tableView.cellForRow(at: IndexPath(item: 1, section: 0))?.detailTextLabel?.text = category
    }
    
}

extension LocationDetailsViewController:
    UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if let theImage = image {
            imageView.image = theImage
        }
        descriptionText = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldTableViewCell).textField.text!
        categoryText = (tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.detailTextLabel?.text)!
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(actionCancel)
        
        let actionPhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in self.takePhotoWithCamera()})
        
        alert.addAction(actionPhoto)
        
        let actionLibrary = UIAlertAction(title: "Chose From Library", style: .default, handler: {_ in self.choosePhotoFromLibrary()})
        
        alert.addAction(actionLibrary)
        
        if image != nil {
            let actionRemove = UIAlertAction(title: "Remove Photo", style: .default, handler: {_ in
                self.image = nil
                self.descriptionText = (self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldTableViewCell).textField.text!
                self.categoryText = (self.tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.detailTextLabel?.text)!
                self.tableView.reloadData()
            })
            alert.addAction(actionRemove)
        }
    
        
        present(alert, animated: true, completion: nil)

    }
    
}
