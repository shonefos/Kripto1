//
//  ViewController.swift
//  Kripto
//
//  Created by Nenad Savic on 11/9/18.
//  Copyright © 2018 Nenad Savic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

// EXTENSION FOR COLORS
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var showCurrency: UIButton!
    
    
    
    let URL_DATA = "https://api.coincap.io/v2/assets"
    let CURRENCY_DATA = "http://free.currencyconverterapi.com/api/v5/convert?"
    
    var coin = [CoinModel]()
    var searchCoin:[CoinModel] = []
    var currencymodel = CurrencyModel()
    var searching = false
    let myGroup = DispatchGroup()
    
//    //FIrebase
//    var ref: DatabaseReference?
//    var firebaseArray = [String]()
//    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        searchBar.delegate = self
        currencyExchange()
        getCoinData()
        
        
//        //Set the firebase reference
//        ref = Database.database().reference()
//
//        //Retrieve the exchange and listen for changes
//        databaseHandle = ref?.child("ExchangeCurrencies").observe(.childAdded, with: { (snapshot) in
//
//           let post = snapshot.value as? String
//
//            if let actualPost = post {
//                self.firebaseArray.append(actualPost)
//            }
//
//            print(self.firebaseArray)
//
//        })

        
        
        
    }
    
    func handleShowIndexPath() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.reloadRows(at: [indexPath], with:.fade )
    }
    
 

    
   // TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            
            return searchCoin.count
            
        } else {
            return coin.count
        }
        
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CoinTableViewCell
        
        tableView.backgroundColor = .clear
        cell.backgroundColor = .clear
       
        let coindata: CoinModel
        coindata = coin[indexPath.row]
        //print(currencymodel.indexValue!)
        
        let priceFloat = (coindata.price as NSString).floatValue * currencymodel.indexValue! // Ovde imam problem
        let costString = String(format:"%.3f", priceFloat)
        let percentFloat = (coindata.percent as NSString).floatValue
        let percentString = String(format:"%.2f", percentFloat)
        
        if searching {
            let priceFloatsearch = (searchCoin[indexPath.row].price as NSString).floatValue
            let costStringsearch = String(format:"%.3f", priceFloatsearch)
            let percentFloatsearch = (searchCoin[indexPath.row].percent as NSString).floatValue
            let percentStringsearch = String(format:"%.2f", percentFloatsearch)
            
            if percentFloatsearch < 0 {
                cell.percentLabel.text = "\(percentStringsearch)%"
                cell.percentLabel.textColor = UIColor(hexString: "#F47E99")
            } else {
                cell.percentLabel.text = "+\(percentStringsearch)%"
                cell.percentLabel.textColor = UIColor(hexString: "#19984A")
            }
            
            cell.nameLabel.text = searchCoin[indexPath.row].name
            cell.symbolLabel.text = searchCoin[indexPath.row].symbol
            cell.priceLabel.text = "\(costStringsearch)"
            
        } else {
            cell.nameLabel.text = coin[indexPath.row].name
            cell.symbolLabel.text = coindata.symbol
            cell.priceLabel.text = "\(costString)"
            if percentFloat < 0 {
                cell.percentLabel.text = "\(percentString)%"
                cell.percentLabel.textColor = UIColor(hexString: "#F47E99")
            } else {
                cell.percentLabel.text = "+\(percentString)%"
                cell.percentLabel.textColor = UIColor(hexString: "#19984A")
            }
            
        }
        
        return cell
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCoin = coin.filter( {$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()} )
        searching = true
        tableView.reloadData()
    }
    
    func textFieldShouldReturn() -> Bool {
        
        //textField.resignFirstResponder()
        //or
        self.view.endEditing(true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
        textFieldShouldReturn()
    }
    
    // UI TABLEVIEW DELEGATE
    var selectedCurrency: CoinModel?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectCoin = coin[indexPath.row]
        
        selectedCurrency = selectCoin
        
        performSegue(withIdentifier: "ShowCryptoDetail", sender: nil)
        
    }
    
    //NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCryptoDetail" {
            let destionationTVC = segue.destination as! DetailTableViewController
            destionationTVC.product = selectedCurrency
        }
    }
    
    // GET API FOR COIN VALUE
    
    func getCoinData() {
        Alamofire.request(URL_DATA).responseJSON { response in
            
            if let json = response.result.value as? [String: Any], let arr = json["data"] as? [[String: Any]] {
                let CoinArray: [[String: Any]] = arr
                
                for dict in CoinArray {
                    if let name = dict["name"] as? String,
                        let symbol = dict["symbol"] as? String,
                        let price = dict["priceUsd"] as? String,
                        let percent = dict["changePercent24Hr"] as? String
                        
                    {
                        
                        let coinnModal: CoinModel = CoinModel(name: name, symbol: symbol, price: price, percent: percent)
                        self.coin.append(coinnModal)
                        
                        
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.tableView.reloadData()
                    }
                    
                    
                
                }
                
            }
        }
        
    }
    
    
    // GET API FOR CURRENCY CHANGE
    func getChangeCurrencies (url: String, parameters: [String : String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                let currencyJSON : JSON = JSON(response.result.value!)
                self.updateCurrencies(json: currencyJSON)
                //print(currencyJSON)
            } else {
                print("Error \(String(describing: response.result.error))")
                
            }
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.tableView.reloadData()
            }
            
            
        }
        
    }
    

    func updateCurrencies(json : JSON) {
        let cn : String = ChangeModel.shared.currency ?? "USD"
        let chncurr = "USD_\(cn)"
        
        currencymodel.indexValue = json[chncurr].floatValue
        //print(currencymodel.indexValue!)
 
        
        
    }
    
    func currencyExchange() {
        
        let cn : String = ChangeModel.shared.currency ?? "USD"
        showCurrency.setTitle(cn, for: .normal)
        let chncurr = "USD_\(cn)"
        let apiKey = "f60ece3db203e4ac5e88"
        let ultracur = "ultra"
        let params : [String : String] = ["q" : chncurr, "compact" : ultracur, "apiKey" : apiKey]
        getChangeCurrencies(url: CURRENCY_DATA, parameters: params)
    }
    
    
    
    

    
    
    // POPUP
    @IBAction func showPopUp(_ sender: UIButton) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpID") as! PopOverViewController
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
        
        
        
        
    }
    

}

// srediti pucanje updatecuurencies
