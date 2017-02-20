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
    
    var pins = [MKPointAnnotation]()
    
    var locBtnPressed : Bool = true
    
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
        
        locationControl.backgroundColor = UIColor.green.withAlphaComponent(0.50)
        locationControl.setTitle("Locate Me", for: .normal)
        locationControl.addTarget(self, action: #selector(MapViewController.locButton(_:)), for: UIControlEvents.touchUpInside)
        locationControl.tag = 1
        self.view.addSubview(locationControl)
        
        pinControl.backgroundColor = UIColor.purple.withAlphaComponent(0.50)
        pinControl.setTitle("Pin", for: .normal)
        pinControl.addTarget(self, action: #selector(MapViewController.pinButton(_:)), for: UIControlEvents.touchUpInside)
        pinControl.tag = 1
        self.view.addSubview(pinControl)
        
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
  
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
    }

    func locButton(_ sender: UIButton) {
        
        if locBtnPressed {
            
            locBtnPressed = false
            
            mapView.showsUserLocation = true
            mapView.delegate = self;
            mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true);
            
        } else {
            
            locBtnPressed = true
            
            
        }

        
    }
    

    func pinButton(_ sender: UIButton) {
        print("Pin Dropped")
        
        var pinCount = 0
        
        switch pinCount {
        case 0:
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = mapView.centerCoordinate
            mapView.addAnnotation(annotation)
            pins.append(annotation)
            
            let pinToZoomOn = pins[0]
            
            let span = MKCoordinateSpanMake(0.5, 0.5)
            
            let region = MKCoordinateRegion(center: pinToZoomOn.coordinate, span: span)
            
            mapView.setRegion(region, animated: true)
            
            pinCount += 1
            
        case 1:
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = mapView.centerCoordinate
            mapView.addAnnotation(annotation)
            pins.append(annotation)
            
            let pinToZoomOn = pins[1]
            
            let span = MKCoordinateSpanMake(0.5, 0.5)
            
            let region = MKCoordinateRegion(center: pinToZoomOn.coordinate, span: span)
            
            mapView.setRegion(region, animated: true)
            
            pinCount += 1
            
        case 2:
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = mapView.centerCoordinate
            mapView.addAnnotation(annotation)
            pins.append(annotation)
            
            let pinToZoomOn = pins[2]
            
            let span = MKCoordinateSpanMake(0.5, 0.5)
            
            let region = MKCoordinateRegion(center: pinToZoomOn.coordinate, span: span)
            
            mapView.setRegion(region, animated: true)
            
            pinCount = 0
            
        default:
            break
        }
        
//        if pins.isEmpty {
//        
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = mapView.centerCoordinate
//            mapView.addAnnotation(annotation)
//            pins.append(annotation)
//            
//            let pinToZoomOn = pins[0]
//            
//            let span = MKCoordinateSpanMake(0.5, 0.5)
//            
//            let region = MKCoordinateRegion(center: pinToZoomOn.coordinate, span: span)
//            
//            mapView.setRegion(region, animated: true)
//
//            
//        } else if pins.count == 1 {
//            
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = mapView.centerCoordinate
//            mapView.addAnnotation(annotation)
//            pins.append(annotation)
//            
//            let pinToZoomOn = pins[1]
//            
//            let span = MKCoordinateSpanMake(0.5, 0.5)
//            
//            let region = MKCoordinateRegion(center: pinToZoomOn.coordinate, span: span)
//            
//            mapView.setRegion(region, animated: true)
//            
//        } else if pins.count == 2 {
//
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = mapView.centerCoordinate
//            mapView.addAnnotation(annotation)
//            pins.append(annotation)
//            
//            let pinToZoomOn = pins[2]
//            
//            let span = MKCoordinateSpanMake(0.5, 0.5)
//            
//            let region = MKCoordinateRegion(center: pinToZoomOn.coordinate, span: span)
//            
//            mapView.setRegion(region, animated: true)
//            
//        }
    }

    
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

