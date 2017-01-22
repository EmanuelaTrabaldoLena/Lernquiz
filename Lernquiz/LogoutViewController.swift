//
//  LogoutViewController.swift
//  Lernquiz
//
//  Created by bk on 22.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit

class LogoutViewController: UIViewController{
    
    

    @IBAction func zurueckZumLoginFenster(_ sender: Any) {
        
        ausgeloggt += 1
        
        print(ausgeloggt)
    }
    
 override func viewDidLoad() {
    
    }
    
}

