//
//  CoinModel.swift
//  Kripto
//
//  Created by Nenad Savic on 11/9/18.
//  Copyright © 2018 Nenad Savic. All rights reserved.
//

import Foundation

class CoinModel {
    
    var name: String
    var symbol: String
    var price: String
    var percent: String
    
    init(name: String, symbol: String, price: String, percent: String) {
        
        self.name = name
        self.symbol = symbol
        self.price = price
        self.percent = percent
    }
    
    
}


