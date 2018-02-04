//
//  SecondViewController.swift
//  Assignment4
//
//  Created by Hitesh Bhatia on 10/12/17.
//  Copyright © 2017 Hitesh Bhatia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SecondViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate  {

    var count = 0
    let searchDestAnnotation = MKPointAnnotation()
    let searchAnnotation = MKPointAnnotation()
    
    @IBOutlet weak var mapView: MKMapView!
    let myManager = CLLocationManager()
    
    @IBOutlet weak var sourceSearch: UIBarButtonItem!
    @IBOutlet weak var destSearch: UIBarButtonItem!
    
    @IBAction func sourceSearchClicked(_ sender: UIBarButtonItem) {
        let sourceSearchBar = UISearchController(searchResultsController:nil)
        sourceSearchBar.searchBar.delegate = self
        present(sourceSearchBar, animated: true, completion: nil)
    }
    
    
    @IBAction func destSearchClicked(_ sender: UIBarButtonItem) {
        let destSearchBar = UISearchController(searchResultsController:nil)
        destSearchBar.searchBar.delegate = self
        present(destSearchBar, animated: true, completion: nil)
    }
    
    func isSourceClicked() -> Bool{
        if count%2 == 0{
         return true
        }else{
         return false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let activity = UIActivityIndicatorView()
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activity.center = self.view.center
        activity.hidesWhenStopped = true
        activity.startAnimating()
        
        self.view.addSubview(activity)
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchSourceReq = MKLocalSearchRequest()
        searchSourceReq.naturalLanguageQuery = searchBar.text
        
        let activeSourceSearch = MKLocalSearch(request: searchSourceReq)
        activeSourceSearch.start {(response, error) in
            activity.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil{
                self.count = 0
            }else{
                let searchLat = response?.boundingRegion.center.latitude
                let searchLon = response?.boundingRegion.center.longitude
                let overlays = self.mapView.overlays
                self.mapView.removeOverlays(overlays)
                if self.isSourceClicked(){
                    //If ony single source give directions from current location to source location
                    let searchAnnotations = self.mapView.annotations
                    self.mapView.removeAnnotations(searchAnnotations)
                    self.addEscondido()
                    self.addElCajon()

                    self.searchAnnotation.title = searchBar.text
                    self.searchAnnotation.coordinate = CLLocationCoordinate2DMake(searchLat!, searchLon!)
                    self.mapView.addAnnotation(self.searchAnnotation)
                    
                    self.searchDestAnnotation.title = searchBar.text
                    self.searchDestAnnotation.coordinate = CLLocationCoordinate2DMake(searchLat!, searchLon!)
                    self.mapView.addAnnotation(self.searchDestAnnotation)
                    
                    let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(searchLat!, searchLon!)
                    let span = MKCoordinateSpanMake(0.3, 0.3)
                    let region = MKCoordinateRegionMake(coordinate, span)
                    
                    self.mapView.setRegion(region, animated: true)
                    let sourcePlacemark = MKPlacemark(coordinate:self.mapView.userLocation.coordinate)
                    let destPlacemark = MKPlacemark(coordinate:self.searchDestAnnotation.coordinate)
                    let sourceItem = MKMapItem(placemark:sourcePlacemark)
                    let destItem = MKMapItem(placemark:destPlacemark)
                    let directionRequest = MKDirectionsRequest()
                    directionRequest.source = sourceItem
                    directionRequest.destination = destItem
                    directionRequest.transportType = .walking
                    let directions = MKDirections(request:directionRequest)
                    directions.calculate(completionHandler:
                        { response, error in
                            guard let response = response else
                            {
                                if error != nil
                                {
                                    self.count = 0
                                }
                                return
                            }
                            
                            let route = response.routes[0]
                            self.mapView.add(route.polyline, level: .aboveRoads)
                            let rekt = route.polyline.boundingMapRect
                            self.mapView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
                    })
                    self.count += 1
                }else{
                    //If Destination available give directions from Source to Destination
                    self.searchDestAnnotation.title = searchBar.text
                    self.searchDestAnnotation.coordinate = CLLocationCoordinate2DMake(searchLat!, searchLon!)
                    self.mapView.addAnnotation(self.searchDestAnnotation)
                    
                    let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(searchLat!, searchLon!)
                    let span = MKCoordinateSpanMake(0.3, 0.3)
                    let region = MKCoordinateRegionMake(coordinate, span)
                    
                    self.mapView.setRegion(region, animated: true)
                    let sourcePlacemark = MKPlacemark(coordinate:self.searchAnnotation.coordinate)
                    let destPlacemark = MKPlacemark(coordinate:self.searchDestAnnotation.coordinate)
                    let sourceItem = MKMapItem(placemark:sourcePlacemark)
                    let destItem = MKMapItem(placemark:destPlacemark)
                    let directionRequest = MKDirectionsRequest()
                    directionRequest.source = sourceItem
                    directionRequest.destination = destItem
                    directionRequest.transportType = .walking
                    let directions = MKDirections(request:directionRequest)
                    directions.calculate(completionHandler:
                        { response, error in
                            guard let response = response else
                            {
                                if error != nil
                                {
                                    self.count = 0
                                }
                                return
                            }
                            
                            let route = response.routes[0]
                            self.mapView.add(route.polyline, level: .aboveRoads)
                            let rekt = route.polyline.boundingMapRect
                            self.mapView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
                    })
                    self.count+=1
                }
            }
        }
    }
    
    func addElCajon(){
        let locationElCajon : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:  32.794821, longitude: -116.962315)
        
        let annotationElCajon = MKPointAnnotation()
        annotationElCajon.coordinate = locationElCajon
        annotationElCajon.title = "El Cajon"
        annotationElCajon.subtitle = "This is El Cajon, San Diego"
        mapView.addAnnotation(annotationElCajon)
    }
    
    func addEscondido(){
        let locationEscondido : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 33.120549, longitude: -117.086976)
        
        let annotationEscondido = MKPointAnnotation()
        annotationEscondido.coordinate = locationEscondido
        annotationEscondido.title = "Escondido"
        annotationEscondido.subtitle = "This is Escondido, San Diego"
        mapView.addAnnotation(annotationEscondido)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        myManager.delegate = self
        myManager.desiredAccuracy = kCLLocationAccuracyBest
        myManager.requestWhenInUseAuthorization()
        myManager.startUpdatingLocation()
        
        mapView.subviews[1].isHidden = true
        let span : MKCoordinateSpan = MKCoordinateSpanMake(0.3, 0.3)
        let location : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:
            32.942386, longitude: -117.069810)
        let region : MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        
        addElCajon()
        addEscondido()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = UIColor.purple
        render.lineWidth = 2.0
        return render
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

