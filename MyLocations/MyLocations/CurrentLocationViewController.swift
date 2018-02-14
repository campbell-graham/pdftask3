//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Campbell Graham on 12/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

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
    let geoCoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: Error?
    var timer: Timer?
    var managedObjectContext: NSManagedObjectContext!

    init() {
        //object initialisation
        messageLabel = UILabel()
        latitudeValueLabel = UILabel()
        longitudeValueLabel = UILabel()
        latitudeTextLabel = UILabel()
        longitudeTextLabel = UILabel()
        addressLabel = UILabel()
        addressLabel.text = ""
        tagButton = UIButton(type: .system)
        getButton = UIButton(type: .system)
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "myTabBarItem", image: #imageLiteral(resourceName: "first"), selectedImage: #imageLiteral(resourceName: "first"))
        title = "Current Location"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //visual tweaks
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        //button event handling
        getButton.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
        tagButton.addTarget(self, action: #selector(openDetailController), for: .touchUpInside)
        
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
        
        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
            startLocationManager()
        }
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
            timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(didTimeOut), userInfo: nil, repeats: false)
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
            if let timer = timer {
                timer.invalidate()
            }
        }
    }
    
    @objc func didTimeOut() {
        print ("Time out")
        if location == nil {
            stopLocationManager()
            lastLocationError = NSError(domain: "MyLocationsErrorDomain", code: 1, userInfo: nil)
            updateLables()
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
        
        var distance = CLLocationDistance(Double.greatestFiniteMagnitude)
        if let location = location {
            distance = newLocation.distance(from: location)
        }
        
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
            
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("We're done!")
                stopLocationManager()
                
                if distance > 0 {
                    performingReverseGeocoding = false
                }
            }
            updateLables()
            
            if !performingReverseGeocoding {
                print("Going to geocode")
                performingReverseGeocoding = true
                geoCoder.reverseGeocodeLocation(newLocation, completionHandler: {
                    placemarks, error in
                        self.lastGeocodingError = error
                    if error == nil, let p = placemarks, !p.isEmpty {
                        self.placemark = p.last!
                    } else {
                        self.placemark = nil
                    }
                    self.performingReverseGeocoding = false
                    self.updateLables()
                })
            }
        } else if distance < 1 {
            let timeInterval = newLocation.timestamp.timeIntervalSince(location!.timestamp)
            
            if timeInterval > 10 {
                print("Force done!")
                stopLocationManager()
                updateLables()
            }
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
            if let placemark = placemark {
                addressLabel.text = string(from: placemark)
            } else if performingReverseGeocoding {
                    addressLabel.text = "Searching for Address..."
            } else if lastGeocodingError != nil {
                addressLabel.text = "Error Finding Address"
            } else {
                addressLabel.text = "No Adress Found"
            }
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
        
         configureGetButton()
        
    }
    
    func configureGetButton() {
        if updatingLocation {
            getButton.setTitle("Stop", for: .normal)
        } else {
            getButton.setTitle("Get My Location", for: .normal)
        }
    }
    
    func string(from placemark: CLPlacemark) -> String {
        var line1 = ""
        
        if let s = placemark.subThoroughfare {
            line1 += s + " "
        }
        
        if let s = placemark.thoroughfare {
            line1 += s
        }
        
        var line2 = ""
        
        if let s = placemark.locality {
            line2 += s + " "
        }
        
        if let s = placemark.administrativeArea {
            line2 += s + " "
        }
        
        if let s = placemark.postalCode {
            line2 += s
        }
        
        return line1 + "\n" + line2 
    }
    
    @objc func openDetailController() {
        let destination = LocationDetailsViewController(location: location, address: placemark != nil ? string(from: placemark!) : "Nockjnvs Address", placemark: placemark)
        destination.managedObjectContext = self.managedObjectContext
        present(UINavigationController(rootViewController: destination), animated: true, completion: nil)
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
