//
//  SearchViewController.swift
//  Warmshowers
//
//  Created by Michael Haeuslmann on 01/07/15.
//  Copyright (c) 2015 Michael Haeuslmann. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController
{
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    var data = [User]()
}

extension SearchViewController: UISearchBarDelegate
{
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        API.sharedInstance.searchByKeyword(searchText, limit: 10, page: 1).onSuccess { users in
            self.data.removeAll(keepCapacity: false)
            for (userId, user) in users {
                self.data.append(user)
            }
            self.tableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDataSource
{
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        cell?.textLabel!.text = data[indexPath.row].fullname
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return data.count
    }
}

extension SearchViewController: UITableViewDelegate
{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let value = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text

        if let mapViewController = presentingViewController as? MapViewController {
            // setup information for controller
        } else if let newMessageViewController = presentingViewController as? NewMessageViewController {
            // setup information for controller
        }
    }
}
