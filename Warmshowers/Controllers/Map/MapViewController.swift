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
import SwiftyDrop
import IJReachability

class MapViewController: UIViewController
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
    private var searchResults = [User]()
    private var users = [Int:User]()
    private var userAnnotations = [Int:MKAnnotation]()
    private var initialZoomFinished = false
    private var locationManager = CLLocationManager()
    private var searchBar = UISearchBar()
    private let userRepository = UserRepository.sharedInstance
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // set up location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true

        // add the search bar
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar

        // find the active user
        let user = userRepository.findByActiveUser()
        if user == nil {
            performSegueWithIdentifier(Storyboard.ShowLogin, sender: nil)
            return
        }

        // when connected, refresh login cookie
        if IJReachability.isConnectedToNetwork() {
            API.sharedInstance
                .login(user!.username, password: user!.password)
                .onFailure() { error in
                    self.performSegueWithIdentifier(Storyboard.ShowLogin, sender: nil)
                }
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
        userAnnotations.removeValueForKey(user.id)
        let annotation = UserAnnotation(user: user)
        userAnnotations[user.id] = annotation
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

//--------------------------------------------------------------------------------------------------
// MARK: MKMapViewDelegate
//--------------------------------------------------------------------------------------------------

extension MapViewController: MKMapViewDelegate
{
    // MARK: Zooming and pinching
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool)
    {
        // saves a couple of API requests if we wait until we're zoomed
        if initialZoomFinished == false {
            return
        }

        let region = mapView.region
        
        let centerLongitude = region.center.longitude
        let centerLatitude = region.center.latitude
        
        let minlat = region.center.latitude - (region.span.latitudeDelta / 2.0)
        let minlon = region.center.longitude - (region.span.longitudeDelta / 2.0)
        
        let maxlat = region.center.latitude + (region.span.latitudeDelta / 2.0)
        let maxlon = region.center.longitude + (region.span.longitudeDelta / 2.0)
        
        let limit = 100
        
        userRepository.findByLocation(
            minlat,
            maxLatitude: maxlat,
            minLongitude: minlon,
            maxLongitude: maxlon,
            centerLatitude: centerLatitude,
            centerLongitude: centerLongitude,
            limit: limit
        ).onSuccess() { users in
            // remove users and their annotations when they are off-screen
            for (userId, user) in self.users {
                if !(user.latitude  >= minlat
                    && user.latitude  <= maxlat
                    && user.longitude >= minlon
                    && user.longitude <= maxlon)
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
        }.onFailure { error in
            if !IJReachability.isConnectedToNetwork() {
                Drop.down("Can't find any hosts, because there is no internet connection.", state: .Info)
            }
        }
    }

    /**
        This will trigger the first initial zoom

        :param: mapView
    */
    func mapViewDidFinishLoadingMap(mapView: MKMapView!)
    {
        if initialZoomFinished == false {
            var region = mapView.region
            region.span.latitudeDelta = region.span.latitudeDelta / 10
            region.span.longitudeDelta = region.span.longitudeDelta / 10
            mapView.setRegion(region, animated: true)
            initialZoomFinished = true
        }
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!
    {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(
            Storyboard.AnnotationViewReuseIdentifier) as? UserAnnotationView
        if view == nil {
            view = UserAnnotationView(annotation: annotation, reuseIdentifier: Storyboard.AnnotationViewReuseIdentifier)
        }
        if let userAnnotation = annotation as? UserAnnotation {
            view!.updateUserInfo(userAnnotation.user!)
        }

        return view
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!)
    {
        for (id, user) in users {
            if user.username == view.annotation.title {
                performSegueWithIdentifier(Storyboard.ShowOtherProfileSegue, sender: user)
            }
        }
    }
}

//--------------------------------------------------------------------------------------------------
// MARK: CLLocationManagerDelegate
//--------------------------------------------------------------------------------------------------

extension MapViewController: CLLocationManagerDelegate
{
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        if let firstLocation = locations.first as? CLLocation {
            let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            let region = MKCoordinateRegion(center: firstLocation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
}

//--------------------------------------------------------------------------------------------------
// MARK: UISearchBarDelegate
//--------------------------------------------------------------------------------------------------

extension MapViewController: UISearchBarDelegate
{
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        if count(searchBar.text) < 3 {
            searchResultTableView.hidden = true
            return
        }

        userRepository.searchByKeyword(searchText, limit: 5).onSuccess { users in
            // if search bar is empty, someone has already clicked a result
            // and this response is coming in too late
            if searchBar.text == "" {
                return
            }

            self.searchResults = [User]()
            for (userId, user) in users {
                self.searchResults.append(user)
            }
            self.searchResultTableView.hidden = false

            var frame = self.searchResultTableView.frame;
            frame.size.height = self.searchResultTableView.contentSize.height;
            self.searchResultTableView.frame = frame;

            self.searchResultTableView.reloadData()
        }
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }
}

//--------------------------------------------------------------------------------------------------
// MARK: UITableViewDelegate
//--------------------------------------------------------------------------------------------------

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

//--------------------------------------------------------------------------------------------------
// MARK: UITableViewDataSource
//--------------------------------------------------------------------------------------------------

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
        cell?.textLabel?.textAlignment = NSTextAlignment.Center
        return cell!
    }
}
