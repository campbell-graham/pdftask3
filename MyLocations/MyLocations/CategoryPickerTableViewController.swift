//
//  CategoryPickerTableViewController.swift
//  MyLocations
//
//  Created by Campbell Graham on 13/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit

class CategoryPickerTableViewController: UITableViewController {
    
    var delegate: CategoryPickerTableViewControllerDelegate?
    var selectedCategoryName = ""
    
    let categories = [
        "No Category",
        "Apple Store",
        "Bar",
        "Bookstore",
        "Club",
        "Grocery Store",
        "Historic Building",
        "House",
        "Icecream Vendor",
        "Landmark",
        "Park"
        ]
    
    init() {
        super.init(style: .plain)
        title = "Select Category"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        view.backgroundColor = AppColors.backgroundColor
        tableView.separatorColor = AppColors.placeholderTextColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        cell.backgroundColor = AppColors.cellBackgroundColor
        cell.textLabel?.textColor = AppColors.textColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(categories[indexPath.row])
        navigationController?.popViewController(animated: true)
        delegate?.categoryPickerTableViewController(self, didSelectCategory: categories[indexPath.row])
    }
}

protocol CategoryPickerTableViewControllerDelegate: class {
    func categoryPickerTableViewController(_ class: CategoryPickerTableViewController, didSelectCategory category: String)
}
