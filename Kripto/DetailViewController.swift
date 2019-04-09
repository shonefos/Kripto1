//
//  DetailViewController.swift
//  Kripto
//
//  Created by Nenad Savic on 3/30/19.
//  Copyright © 2019 Nenad Savic. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var getDetailName = String()
    var getDetailPrice = String()
    var getDetailPercent = String()
    
    @IBOutlet weak var currencyDetailName: UILabel!
    @IBOutlet weak var priceDetailName: UILabel!
    @IBOutlet weak var percentDetail: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        currencyDetailName.text = getDetailName
        priceDetailName.text = getDetailPrice
        percentDetail.text = getDetailPercent
        
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
