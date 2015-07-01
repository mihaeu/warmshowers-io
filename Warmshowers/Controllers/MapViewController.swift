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
import IJReachability

class MapViewController: UIViewController, CLLocationManagerDelegate
{
    @IBOutlet weak var searchResultTableView: UITableView! {
        didSet {
            searchResultTableView.hidden = true
            searchResultTableView.delegate = self
            searchResultTableView.dataSource = self
        }
    }
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.showsUserLocation = true
            mapView.delegate = self
        }
    }
    
    var userInCenter: User? {
        didSet {
            if userInCenter != nil {
                centerMapOnUser(userInCenter!)
            }
        }
    }
    var searchResults = [User]()
    
    private var users = [Int:User]()
    private var userAnnotations = [Int:MKAnnotation]()
    
    private var didAdjustInitialZoomLevel = false
    private var myLocation: CLLocationCoordinate2D?
    
    private let userRepository = UserRepository()
    private let locationManager = CLLocationManager()
    
    private var searchBar = UISearchBar()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }

        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.startUpdatingLocation()
        
        if let user = userRepository.findByActiveUser() {
            if IJReachability.isConnectedToNetwork() {
                API.sharedInstance.login(user.name, password: user.password).onFailure() { error in
                    self.performSegueWithIdentifier(Storyboard.ShowLogin, sender: nil)
                }
            } else {
                if let mapTabBarItem = self.tabBarController?.tabBar.items?.first as? UITabBarItem {
                    mapTabBarItem.enabled = false
                }
                self.performSegueWithIdentifier(Storyboard.ShowFavoriteSegue, sender: nil)
            }
        } else {
            performSegueWithIdentifier(Storyboard.ShowLogin, sender: nil)
        }
    }
    
    func centerMapOnUser(user: User)
    {
        var center = CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longitude)
        var span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        var region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func openSelectedUserAnnotation(user: User)
    {
        userAnnotations.removeValueForKey(user.uid)
        let annotation = UserAnnotation(user: user)
        userAnnotations[user.uid] = annotation
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
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
        
        userRepository.findByLocation(
            minlat,
            maxlat: maxlat,
            minlon: minlon,
            maxlon: maxlon,
            centerlat: centerLatitude,
            centerlon: centerLongitude,
            limit: limit
        ).onSuccess() { users in
            // remove users and their annotations when they are off-screen
            for (userId, user) in self.users {
                let location = CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longitude)
                let center   = mapView.region.center
                var northWestCorner = CLLocationCoordinate2D(
                    latitude: center.latitude  - (region.span.latitudeDelta  / 2.0),
                    longitude: center.longitude - (region.span.longitudeDelta / 2.0)
                )
                var southEastCorner = CLLocationCoordinate2D(
                    latitude: center.latitude  + (region.span.latitudeDelta  / 2.0),
                    longitude: center.longitude + (region.span.longitudeDelta / 2.0)
                )
                
                if !(location.latitude  >= northWestCorner.latitude
                    && location.latitude  <= southEastCorner.latitude
                    && location.longitude >= northWestCorner.longitude
                    && location.longitude <= southEastCorner.longitude)
                {
                    mapView.removeAnnotation(self.userAnnotations[userId])
                    self.users.removeValueForKey(userId)
                }
            }
            // add only new users as annotations
            for (userId, user) in users {
                if self.users[userId] == nil {
                    let userAnnotation = UserAnnotation(user: user)
                    self.userAnnotations[userId] = userAnnotation
                    self.users[userId] = user
                    mapView.addAnnotation(userAnnotation)
                }
            }
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
            
            UserPictureCache.sharedInstance.thumbnailById(userAnnotation.user!.uid).onSuccess { image in
                leftCalloutFrame.image = image
            }.onFailure { error in
                leftCalloutFrame.image = UserPictureCache.defaultThumbnail
            }
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

extension MapViewController: CLLocationManagerDelegate
{
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        if let firstLocation = locations.first as? CLLocation {
            myLocation = firstLocation.coordinate
            locationManager.stopUpdatingLocation()
        }
    }
}

extension MapViewController: UISearchBarDelegate
{
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        if count(searchBar.text) < 3 {
            searchResultTableView.hidden = true
            return
        }
        
        API.sharedInstance.searchByKeyword(searchText, limit: 10, page: 1).onSuccess { users in
            self.searchResults.removeAll(keepCapacity: false)
            for (userId, user) in users {
                self.searchResults.append(user)
            }
            self.searchResultTableView.hidden = false
            self.searchResultTableView.reloadData()
        }
    }
}

extension MapViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let user = searchResults[indexPath.row]
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchResultTableView.hidden = true
        
        centerMapOnUser(user)
        openSelectedUserAnnotation(user)
    }
}

extension MapViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        cell?.textLabel!.text = searchResults[indexPath.row].fullname
        return cell!
    }
}
