//
//  MapViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 08/05/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit
import MapKit
import Haneke

class MapViewController: UIViewController, CLLocationManagerDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    
    var users = [Int:User]()
    var userAnnotations = [MKAnnotation]()
    
    var api = API.sharedInstance
    
    var didAdjustInitialZoomLevel = false
    var myLocation: CLLocationCoordinate2D?
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        mapView.showsUserLocation = true
        mapView.delegate = self

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
            locationManager.stopUpdatingLocation()
        }
    }

    func loadUserAnnotations(users: [Int:User])
    {
        // todo
        mapView.removeAnnotations(userAnnotations)
        userAnnotations.removeAll()
        
        for (id, user) in users {
            if user.longitude != 0.0 {
                userAnnotations.append(UserAnnotation(user: user))
            }
        }
        
        mapView.addAnnotations(userAnnotations)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == Storyboard.ShowOtherProfileSegue {
            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let otherProfileViewController = navigationController.topViewController as? OtherProfileViewController {
                    if let user = sender as? User {
                        otherProfileViewController.user = user
                    }
                }
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate
{
    // MARK: Zooming and pinching
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool)
    {
        if didAdjustInitialZoomLevel == false {
            return
        }
        
        let region = mapView.region
        
        let centerLongitude = region.center.longitude
        let centerLatitude = region.center.latitude
        
        let minlat = region.center.latitude - (region.span.latitudeDelta / 2)
        let minlon = region.center.longitude - (region.span.longitudeDelta / 2)
        
        let maxlat = region.center.latitude + (region.span.latitudeDelta / 2)
        let maxlon = region.center.longitude + (region.span.longitudeDelta / 2)
        
        let limit = 100
        
        api.searchByLocation(
            minlat,
            maxlat: maxlat,
            minlon: minlon,
            maxlon: maxlon,
            centerlat: centerLatitude,
            centerlon: centerLongitude,
            limit: limit
        ).onSuccess() { users in
            self.users = users
            self.loadUserAnnotations(users)
        }
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView!)
    {
        if didAdjustInitialZoomLevel == false {
            var region = mapView.region
            region.span.latitudeDelta = region.span.latitudeDelta / 10
            region.span.longitudeDelta = region.span.longitudeDelta / 10
            mapView.setRegion(region, animated: true)
            didAdjustInitialZoomLevel = true
        }
    }
    
    
    // MARK: Annotations
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!
    {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(Storyboard.AnnotationViewReuseIdentifier)
        
        if (view == nil) {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Storyboard.AnnotationViewReuseIdentifier)
            view.canShowCallout = true
        } else {
            view.annotation = annotation
        }
        
        if let userAnnotation = annotation as? UserAnnotation {
            var leftCalloutFrame = UIImageView(frame: Storyboard.LeftCalloutFrame)
            let thumbnailURL = NSURL(string: userAnnotation.user!.thumbnailURL)
            
            leftCalloutFrame.hnk_setImageFromURL(thumbnailURL!, placeholder: UIImage(named: "tab-profile"))
            view.leftCalloutAccessoryView = leftCalloutFrame
        }

        view.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
        
        return view
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!)
    {
        for (id, user) in users {
            if user.name == view.annotation.title {
                performSegueWithIdentifier(Storyboard.ShowOtherProfileSegue, sender: user)
            }
        }
    }
}
