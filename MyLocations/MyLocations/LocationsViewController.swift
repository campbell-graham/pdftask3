//
//  LocationsViewController.swift
//  MyLocations
//
//  Created by Campbell Graham on 14/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit

class LocationsViewController: UITableViewController {
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}
