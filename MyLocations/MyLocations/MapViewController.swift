//
//  MapViewController.swift
//  MyLocations
//
//  Created by Campbell Graham on 15/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView
    var managedObjectContext: NSManagedObjectContext!
    var showUserBarButtonItem: UIBarButtonItem!
    let locationManager = CLLocationManager()
    var locations = [Location]()
    let annotation = MKPointAnnotation()
    
    init() {
        mapView = MKMapView()
        super.init(nibName: nil, bundle: nil)
        showUserBarButtonItem = UIBarButtonItem(title: "Show User", style: .plain, target: self, action: #selector(showUserLocation))
        tabBarItem = UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "first"), selectedImage: #imageLiteral(resourceName: "first"))
        title = "Map"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         mapView.delegate = self
        
        navigationItem.rightBarButtonItem = showUserBarButtonItem
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        mapView.userTrackingMode = .none
        mapView.showsUserLocation = true
        
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: false)
        loadUserData()
        applyMapPins()
    }
    
    @objc func showUserLocation() {
        let locationToZoom = CLLocationCoordinate2D(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        let region = MKCoordinateRegionMakeWithDistance(locationToZoom, 1000, 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    func loadUserData() {
        let fetchRequest = NSFetchRequest<Location>()
        let entity = Location.entity()
        fetchRequest.entity = entity
        do {
            locations = try managedObjectContext.fetch(fetchRequest)
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    func applyMapPins() {
        mapView.addAnnotations(locations)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Location else {
            return nil
        }
        
        let identifier = "Location"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            pinView.isEnabled = true
            pinView.canShowCallout = true
            pinView.animatesDrop = false
            pinView.pinTintColor = UIColor(red: 0.32, green: 0.82, blue: 0.4, alpha: 1)
            
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.addTarget(self, action: #selector(showLocationDetails), for: .touchUpInside)
            pinView.rightCalloutAccessoryView = rightButton
            annotationView = pinView
        }
        
        if let annotationView = annotationView {
            annotationView.annotation = annotation
            let button = annotationView.rightCalloutAccessoryView as! UIButton
            if let index = locations.index(of: annotation as! Location) {
                button.tag = index
            }
        }
        
        return annotationView
    }
    
    @objc func showLocationDetails(_ sender: UIButton) {
        let destination = LocationDetailsViewController(locationToEdit: locations[sender.tag])
        destination.managedObjectContext = self.managedObjectContext
        present(UINavigationController(rootViewController: destination), animated: true, completion: nil)
    }
}
