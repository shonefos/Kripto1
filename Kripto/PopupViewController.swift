//
//  PopupViewController.swift
//  Kripto
//
//  Created by Nenad Savic on 11/26/18.
//  Copyright © 2018 Nenad Savic. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController, SBCardPopupContent {
    
    var popupViewController: SBCardPopupViewController?
    var allowsTapToDismissPopupCard: Bool = true
    var allowsSwipeToDismissPopupCard: Bool = true
    
    //create initiate for popup
    
    
//    static func create() -> UIViewController {
//
//      instantiate()
//    
//
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func changeCurrency(_ sender: UIButton) {
        
    }
}
    
extension UIStoryboard {
    func instantiate<T>() -> T {
        return instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
    
    static let main = UIStoryboard(name: "Main", bundle: nil)
}
