//
//  FavoriteViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 20/06/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var favoriteUsers = Realm().objects(User).filter("isFavorite == true")
    
    override func viewWillAppear(animated: Bool)
    {
        tableView.reloadData()
    }
    
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
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let user = favoriteUsers[indexPath.row]
        performSegueWithIdentifier(Storyboard.ShowOtherProfileSegue, sender: user)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.FavoriteCellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: Storyboard.FavoriteCellIdentifier)
        }
        cell!.textLabel?.text = favoriteUsers[indexPath.row].fullname
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return favoriteUsers.count
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let realm = Realm()
            realm.write {
                self.favoriteUsers[indexPath.row].isFavorite = false
            }
            
            favoriteUsers = Realm().objects(User).filter("isFavorite == true")
            tableView.reloadData()
        }
    }
}
