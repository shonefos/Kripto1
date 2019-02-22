//
//  DetailTableViewController.swift
//  Kripto
//
//  Created by Nenad Savic on 1/23/19.
//  Copyright © 2019 Nenad Savic. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    @IBOutlet weak var imageDetail: UIImageView!
    
    var product: CoinModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Crypto Detail"
    }
    
}
