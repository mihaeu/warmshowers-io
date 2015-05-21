//
//  OtherProfileViewController.swift
//  Warmshowers
//
//  Created by admin on 09/05/15.
//  Copyright (c) 2015 mihaeu. All rights reserved.
//

import UIKit

class OtherProfileViewController: UIViewController
{
    
//    TODO: I would like to see the tab bar while browsing other views, how do I do that?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad()
    {
        nameLabel.text = user?.name
        self.navigationController?.navigationBarHidden = false
    }
}
