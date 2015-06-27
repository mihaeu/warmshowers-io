//
//  FavoriteViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 20/06/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    // matching table for section headers, contains all country codes of favorited users
    // 0 : na
    // 1 : za
    // 2 : de
    var countries = [String:Int]()
    
    var tableData = [[User]]()
    
    let userRepository = UserRepository()
    
    override func viewWillAppear(animated: Bool)
    {
        setTableData()
        tableView.reloadData()
    }
    
    func setTableData()
    {
        tableData = [[User]]()
        countries = [String:Int]()
        for user in userRepository.findByFavorite() {
            var key = user.country == "" ? "na" : user.country
            if countries[key] == nil {
                countries[key] = countries.count
            }
            
            if tableData.count < countries.count {
                tableData.append([user])
            } else {
                tableData[countries[key]!].append(user)
            }
        }
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
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let user = tableData[indexPath.section][indexPath.row]
        performSegueWithIdentifier(Storyboard.ShowOtherProfileSegue, sender: user)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.FavoriteCellIdentifier) as? FavoriteCell
        if cell == nil {
            cell = FavoriteCell(style: UITableViewCellStyle.Default, reuseIdentifier: Storyboard.FavoriteCellIdentifier)
        }
        
        let user = tableData[indexPath.section][indexPath.row]
        cell!.userLabel.text = user.fullname
        cell!.addressLabel.text = user.city

        let url = NSURL(string: user.thumbnailURL)!
        cell!.userPictureImageView.hnk_setImageFromURL(url)
        cell?.userPictureImageView.layer.cornerRadius = 8
        cell?.userPictureImageView.clipsToBounds = true
        cell?.userPictureImageView.layer.borderWidth = 1.0;
        
        cell!.sizeToFit()
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableData[section].count
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            userRepository.update(self.tableData[indexPath.section][indexPath.row], key: "isFavorite", value: false)
            
            setTableData()
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        for (shortCode, index) in countries {
            if index == section {
                return Constants.CountryCodes[shortCode]
            }
        }
        return "N/A"
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return tableData.count
    }
}
