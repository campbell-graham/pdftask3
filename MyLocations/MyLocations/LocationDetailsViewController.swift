//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Campbell Graham on 13/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit
import CoreLocation

class LocationDetailsViewController: UITableViewController, CategoryPickerTableViewControllerDelegate {
    
    var desciptionTextView: UITextView
    var categoryLabel: UILabel
    var latitudeLabel: UILabel
    var longitudeLabel: UILabel
    var addressLabel: UILabel
    var dateLabel: UILabel
    var doneButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    var location: CLLocation
    var address: String
    let formatter = DateFormatter()
    
    init(location: CLLocation, address: String) {
        
        self.location = location
        self.address = address
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        desciptionTextView = UITextView()
        categoryLabel = UILabel()
        latitudeLabel = UILabel()
        longitudeLabel = UILabel()
        addressLabel = UILabel()
        dateLabel = UILabel()
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tag Location"
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "textFieldCell")
        navigationItem.largeTitleDisplayMode = .never
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
        // Do any additional setup after loading the view.
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
        return indexPath.section == 0 && indexPath.row == 0 ? 100 : 50
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 2 ? nil : indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            let destination = CategoryPickerTableViewController()
            destination.delegate = self
            navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    //eliminates the deadspace above the first section that is unwanted
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 44
    }
    
    //need this in order for heightForheaderInSection to trigger
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldTableViewCell
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
                cell.detailTextLabel?.text = "No Category"
                cell.accessoryType = .disclosureIndicator
            default:
                print("Error: Cell location is invalid")
            }
        } else if location.section == 1 {
            cell.textLabel?.text = "Add Photo"
            cell.accessoryType = .disclosureIndicator
        } else if location.section == 2 {
            switch location.row {
            case 0:
                cell.textLabel?.text = "Latitude"
                cell.detailTextLabel?.text = String(format: "%.8f", self.location.coordinate.latitude)
            case 1:
                cell.textLabel?.text = "Longitude"
                cell.detailTextLabel?.text = String(format: "%.8f", self.location.coordinate.longitude)
            case 2:
                cell.textLabel?.text = "Address"
                cell.detailTextLabel?.text = address
            case 3:
                cell.textLabel?.text = "Date"
                cell.detailTextLabel?.text = formatter.string(from: Date())
            default:
                cell.textLabel?.text = ""
            }
        } else {
            print("Error: Cell location is invalid")
        }
        
        
    }
    
    @objc func done() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func categoryPickerTableViewController(_ class: CategoryPickerTableViewController, didSelectCategory category: String) {
        tableView.cellForRow(at: IndexPath(item: 1, section: 0))?.detailTextLabel?.text = category
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
