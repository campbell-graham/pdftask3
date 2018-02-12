//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Campbell Graham on 12/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    
    var messageLabel: UILabel
    var latitudeValueLabel: UILabel
    var longitudeValueLabel: UILabel
    var latitudeTextLabel: UILabel
    var longitudeTextLabel: UILabel
    var addressLabel: UILabel
    var tagButton: UIButton
    var getButton: UIButton
    let locationManager = CLLocationManager()
    var location: CLLocation!
    var updatingLocation = false
    var lastLocationError: Error?

    init() {
        //object initialisation
        messageLabel = UILabel()
        latitudeValueLabel = UILabel()
        longitudeValueLabel = UILabel()
        latitudeTextLabel = UILabel()
        longitudeTextLabel = UILabel()
        addressLabel = UILabel()
        tagButton = UIButton(type: .system)
        getButton = UIButton(type: .system)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //visual tweaks
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tabBarItem.image = #imageLiteral(resourceName: "first")
        title = "Current Location"
        
        //button event handling
        getButton.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
        
        //add to view
        view.addSubview(messageLabel)
        view.addSubview(latitudeValueLabel)
        view.addSubview(longitudeValueLabel)
        view.addSubview(latitudeTextLabel)
        view.addSubview(longitudeTextLabel)
        view.addSubview(addressLabel)
        view.addSubview(tagButton)
        view.addSubview(getButton)
    
        //constraint set up
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        latitudeValueLabel.translatesAutoresizingMaskIntoConstraints = false
        longitudeValueLabel.translatesAutoresizingMaskIntoConstraints = false
        latitudeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        longitudeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        tagButton.translatesAutoresizingMaskIntoConstraints = false
        getButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            //message label
            messageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            messageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            //latitude text label
            latitudeTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            latitudeTextLabel.trailingAnchor.constraint(equalTo: latitudeValueLabel.leadingAnchor, constant: -20),
            latitudeTextLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 26),
            //longitude text label
            longitudeTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            longitudeTextLabel.trailingAnchor.constraint(equalTo: longitudeValueLabel.leadingAnchor),
            longitudeTextLabel.topAnchor.constraint(equalTo: latitudeTextLabel.bottomAnchor, constant: 26),
            //latitude value label
            latitudeValueLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            latitudeValueLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 26),
            //longitude value label
            longitudeValueLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            longitudeValueLabel.topAnchor.constraint(equalTo: latitudeValueLabel.bottomAnchor, constant: 26),
            //address label
            addressLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addressLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addressLabel.topAnchor.constraint(equalTo: longitudeValueLabel.bottomAnchor, constant: 26),
            //tag button
            tagButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            tagButton.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 26),
            //get button
            getButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            getButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -26)
            ])
        
        //text and other visual tweaks
        messageLabel.textAlignment = .center
        latitudeValueLabel.textAlignment = .right
        longitudeValueLabel.textAlignment = .right
        tagButton.setTitle("Tag Current Location", for: .normal)
        getButton.setTitle("Get My Location", for: .normal)
        
        //default text for labels that do not change
        latitudeTextLabel.text = "Latitude:"
        longitudeTextLabel.text = "Longitude:"
        
        
        updateLables()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func getLocation() {
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        startLocationManager()
        updateLables()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did fail with error: \(error)")
        
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        
        lastLocationError = error
        
        startLocationManager()
        updateLables()
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("Did update to location : \(newLocation)")
        
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
            
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("We're done!")
                stopLocationManager()
            }
            updateLables()
        }
    }
    
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func updateLables() {
        if let location = location {
            latitudeValueLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeValueLabel.text = String(format: "%.8f", location.coordinate.longitude)
            tagButton.isHidden = false
            messageLabel.text = ""
        } else {
            let statusMessage: String
            if let error = lastLocationError as NSError? {
                if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                    statusMessage = "Location Services Disabled"
                } else {
                    statusMessage = "Error Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled"
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap 'Get My Location' to Start"
            }
            messageLabel.text = statusMessage
            latitudeValueLabel.text = ""
            longitudeValueLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
        }
        
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
