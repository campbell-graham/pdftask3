//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Campbell Graham on 12/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit

class CurrentLocationViewController: UIViewController {
    
    
    var messageLabel: UILabel
    var latitudeLabel: UILabel
    var longitudeLabel: UILabel
    var addressLabel: UILabel
    var tagButton: UIButton
    var getButton: UIButton
    

    init() {
        messageLabel = UILabel()
        latitudeLabel = UILabel()
        longitudeLabel = UILabel()
        addressLabel = UILabel()
        tagButton = UIButton(type: .system)
        getButton = UIButton(type: .system)
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tabBarItem.image = #imageLiteral(resourceName: "first")
        title = "Current Location"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add to view
        view.addSubview(messageLabel)
        view.addSubview(latitudeLabel)
        view.addSubview(longitudeLabel)
        view.addSubview(addressLabel)
        view.addSubview(tagButton)
        view.addSubview(getButton)
    
        //constraint set up
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        latitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        longitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        tagButton.translatesAutoresizingMaskIntoConstraints = false
        getButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            //message label
            messageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            messageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            //latitude label
            latitudeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            latitudeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            latitudeLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 26),
            //longitude label
            longitudeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            longitudeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            longitudeLabel.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: 8),
            //address label
            addressLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            addressLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            addressLabel.topAnchor.constraint(equalTo: longitudeLabel.bottomAnchor, constant: 26),
            //tag button
            tagButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            tagButton.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 26),
            //get button
            getButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            getButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -26)
            ])
        
        //text and other visual tweaks
        messageLabel.textAlignment = .center
        messageLabel.text = "[user location here]"
        latitudeLabel.text = "Lattitude: [Latitude goes here]"
        longitudeLabel.text = "Longitude: [Longitude goes here]"
        addressLabel.text = "Address goes here"
        tagButton.setTitle("Tag Current Location", for: .normal)
        getButton.setTitle("Get My Location", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLocation() {
        
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
