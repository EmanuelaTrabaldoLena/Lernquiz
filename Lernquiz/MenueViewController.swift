//
//  MenueViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 12.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit

class MenueViewController: UIViewController {
    
    @IBOutlet weak var fachLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        fachLabel.text = fachName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
