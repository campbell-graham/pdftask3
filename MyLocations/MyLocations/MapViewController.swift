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
        for l in locations {
            annotation.coordinate = CLLocationCoordinate2D(latitude: l.latitude, longitude: l.longitude)
            mapView.addAnnotation(annotation)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
