//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Paul Jesukiewicz on 2/8/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    let locations = [
        ["title": "Home",    "latitude": 38.906635, "longitude": -77.10192],
        ["title": "School", "latitude": 35.973233, "longitude": -79.99504],
        ["title": "Work",     "latitude": 38.832972, "longitude": -77.117442]
    ]
    
    var pins = [MKPointAnnotation]()
    var pinCount = 0
    var device = UIDevice.current
    
    //keep track of starting location
    let startLoc = MKPointAnnotation()
    
    //keep track of starting span
    var startSpan: MKCoordinateSpan!

    override func loadView() {
        //Create a map view
        mapView = MKMapView()
        
        locationManager.requestAlwaysAuthorization()
        
        //Set it as the view of this view controller
        view = mapView
        
        let standardString = NSLocalizedString("Standard", comment: "foobar")
        let satelliteString = NSLocalizedString("Satellite", comment: "foobar")
        let hybridString = NSLocalizedString("Hybrid", comment: "foobar")
        let segmentedControl = UISegmentedControl(items: [standardString, satelliteString, hybridString])
        let locationControl: UIButton = UIButton(frame: CGRect(x: 265, y: 580, width: 100, height: 30))
        let pinControl: UIButton = UIButton(frame: CGRect(x: 10, y: 580, width: 50, height: 30))
        
        print(String(describing: device))
        
//        switch device {
//            case .iPhone5:
//                print("No TouchID sensor")
//            case .iPhone5S:
//                fallthrough
//            case .iPhone6:
//                fallthrough
//            case .iPhone6plus:
//                fallthrough
//            case .iPhone6S:
//                fallthrough
//            case .iPhone6Splus:
//                print("Put your thumb on the " + UIDevice().type.rawValue + " sensor thingy")
//            case .iPhone7:
//                print("Izza 7")
//            case .iPhone7plus:
//                print("Izza plus")
//            default:
//                print("I am not equipped to handle this device")
//        }
        
        
        //For loop to set annotations and add them to the pins array
        for location in locations {
            var count = 0
            let annotation = MKPointAnnotation()
            annotation.title = location["title"] as? String
            annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
            pins.append(annotation)
            count += 1
        }
        
        //Setup location button
        locationControl.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        locationControl.setTitle("Locate Me", for: .normal)
        locationControl.addTarget(self, action: #selector(MapViewController.locButton(_:)), for: UIControlEvents.touchUpInside)
        locationControl.tag = 1
        self.view.addSubview(locationControl)
        
        //Setup pin button
        pinControl.backgroundColor = UIColor.purple.withAlphaComponent(0.5)
        pinControl.setTitle("Pin", for: .normal)
        pinControl.addTarget(self, action: #selector(MapViewController.pinButton(_:)), for: UIControlEvents.touchUpInside)
        pinControl.tag = 1
        self.view.addSubview(pinControl)
        
        //Setup segment control bar
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        //Set the constraints of the segControl Bar
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
    }

    //Button to set mapview to current user locaion, or jump back to original map location
    func locButton(_ sender: UIButton) {
        
        //If you are showing the current location, jump back to origin. Otherwise show the current location
        if mapView.showsUserLocation {
            
            let span:MKCoordinateSpan = MKCoordinateSpanMake(startSpan.latitudeDelta, startSpan.longitudeDelta)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(startLoc.coordinate, span)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = false
            
        } else {
            
            startLoc.coordinate = mapView.centerCoordinate
            startSpan = mapView.region.span
            mapView.showsUserLocation = true
            mapView.delegate = self;
            mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true);
            
        }
    }
    
    //When the user presses the pin button the mapView jumps to the first pin.
    //continuesd pressing moves the focus to the next pin.
    //If you press pin three times, the next press will return the view back
    //to the current location.
    func pinButton(_ sender: UIButton) {
        
        //If you press pin a fourth time, go to last location and reset the pincount
        if pinCount == 3 {
            
            mapView.removeAnnotation(pins[pinCount-1])
            
            pinCount = 0
            
            let span:MKCoordinateSpan = MKCoordinateSpanMake(startSpan.latitudeDelta, startSpan.longitudeDelta)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(startLoc.coordinate, span)
            
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = false
            
        } else {
            
            //If no pins have been set, record the current mapView location so you can go back
            if pinCount == 0 {
                startLoc.coordinate = mapView.centerCoordinate
                startSpan = mapView.region.span
            } else { //If a pin has been set, remove the previous pin before adding a new one
                mapView.removeAnnotation(pins[pinCount-1])
            }
            
            let pinZoom = pins[pinCount]
            
            mapView.addAnnotation(pins[pinCount])
            
            let span = MKCoordinateSpanMake(0.5, 0.5)
            let region = MKCoordinateRegion(center: pinZoom.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
            //incriment pin count
            pinCount = (pinCount + 1)%4
        }

    }

    //Switch control for maptype
    func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loded its view.")
        
    }
    
}

