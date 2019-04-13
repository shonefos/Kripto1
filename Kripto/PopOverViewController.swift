//
//  PopOverViewController.swift
//  Kripto
//
//  Created by Nenad Savic on 11/28/18.
//  Copyright © 2018 Nenad Savic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PopOverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var popUpView: UIView!
    
    @IBOutlet weak var tableViewPopUp: UITableView!
    
    var currencieschange = [ChangeModel]()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var currencies:[String] = ["EUR", "XAF", "RSD", "AUD", "PEN", "COP", "DKK", "GBP", "ZMW", "RUB", "HRK", "CHF", "ZAR"]
    
    
    let URL_DATA2 = "http://data.fixer.io/api/latest?access_key=0ebe39f91670e186e80e29c145858ed6"
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ChangeModel.shared.currency = currencies[indexPath.row]
        
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewControler = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.present(newViewControler,animated: true, completion: nil)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewPopUp.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CurrencyTableViewCell
        
        cell.currencyLabel.text = currencies[indexPath.row]
        
        return cell
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
    }

  
    @IBAction func closePopUp(_ sender: Any) {
        self.view.removeFromSuperview()
        
    }
    
}
