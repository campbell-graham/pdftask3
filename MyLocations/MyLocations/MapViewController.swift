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

class MapViewController: UIViewController {
    
    var mapView: MKMapView
    var managedObjectContext: NSManagedObjectContext!
    var showUserBarButtonItem: UIBarButtonItem!
    
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

        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }
    
    @objc func showUserLocation() {
        print("Will now show the user's location")
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
