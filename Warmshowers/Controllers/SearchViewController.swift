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
    
    var data = ["1","2","3","4","5","6","7","8","9","10"]
    var filteredData = ["1","2","3","4","5","6","7","8","9","10"]
}

extension SearchViewController: UISearchBarDelegate
{
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        filteredData.removeAll(keepCapacity: false)
        for number in data {
            if number > searchBar.text {
                filteredData.append(number)
            }
        }
        tableView.reloadData()
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
        cell?.textLabel!.text = filteredData[indexPath.row]
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filteredData.count
    }
}

extension SearchViewController: UITableViewDelegate
{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        log.debug("Select row \(indexPath.row)")
    }
}
