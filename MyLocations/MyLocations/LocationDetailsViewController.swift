//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Campbell Graham on 13/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit

class LocationDetailsViewController: UITableViewController {
    
    var desciptionTextView: UITextView
    var categoryLabel: UILabel
    var latitudeLabel: UILabel
    var longitudeLabel: UILabel
    var addressLabel: UILabel
    var dateLabel: UILabel
    
    
    init() {
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
    
    //eliminates the deadspace above the first section that is unwanted
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 44
    }
    
    //need this in order for heightForheaderInSection to trigger
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        //generate the cell if one has not been made previously 
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "[\(indexPath.section),\(indexPath.row)]"
        return cell!
    }
    
    @objc func done() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancel() {
        navigationController?.popViewController(animated: true)
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
