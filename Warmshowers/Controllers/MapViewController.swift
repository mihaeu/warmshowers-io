//
//  MapViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 08/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate
{
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.showsUserLocation = true
            mapView.delegate = self
        }
    }
    
    let locationManager = CLLocationManager()
    
    var myLocation: CLLocationCoordinate2D? {
        didSet {
//            loadUserAnnotations()
        }
    }
    var users = [User]()
    var userAnnotations = [MKAnnotation]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }

//      TODO: Do I need this for my app?
//
//      We aren't updating our location too many times, because we're not navigating,
//      so maybe just showsUserLocation is enough? Can I get my own location any other way?
//      I only want to reload the user info if I move far away from where I started.
//
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        if let firstLocation = locations.first as? CLLocation {
            myLocation = firstLocation.coordinate
        }
    }

//    func loadUserAnnotations(userSearch: UserSearch = UserSearch())
//    {
//        // if we don't know where we are, we can't search for users around us
//        if myLocation == nil {
//            return
//        }
//        
//        users = userSearch.byLocation(myLocation!.latitude, longitude: myLocation!.longitude)
//        for user in users {
//            
//            // if the user for some reason has no location, skip
//            if user.latitude == nil || user.longitude == nil {
//                continue
//            }
//            
//            var userAnnotation = MKPointAnnotation()
//            userAnnotation.title = user.name
//            userAnnotation.coordinate = CLLocationCoordinate2D(latitude: user.latitude!, longitude: user.longitude!)
//            userAnnotations.append(userAnnotation)
//        }
//        mapView.addAnnotations(userAnnotations)
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == Storyboard.ShowOtherProfileSegue {
            if let otherProfileViewController = segue.destinationViewController as? OtherProfileViewController {
                if let user = sender as? User {
                    otherProfileViewController.user = user
                }
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate
{
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!
    {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(Storyboard.AnnotationViewReuseIdentifier)
        
        if (view == nil) {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Storyboard.AnnotationViewReuseIdentifier)
            view.canShowCallout = true
        } else {
            view.annotation = annotation
        }
        
        var leftCalloutFrame = UIImageView(frame: Storyboard.LeftCalloutFrame)
        leftCalloutFrame.image = UIImage(named: "tab-profile")
        view.leftCalloutAccessoryView = leftCalloutFrame
        view.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
        
        return view
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!)
    {
        for user in users {
            if user.name == view.annotation.title {
                performSegueWithIdentifier(Storyboard.ShowOtherProfileSegue, sender: user)
            }
        }
    }
}
