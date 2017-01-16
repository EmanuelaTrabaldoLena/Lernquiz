//
//  DuellSpielstandViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 15.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit

class DuellSpielstandViewController: UIViewController {
    
    @IBOutlet weak var gegenSpieler: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        gegenSpieler.text = mitSpieler
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
