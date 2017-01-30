//
//  MenueViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 12.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit

class MenueViewController: UIViewController{
    
    @IBOutlet weak var fachLabel: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    //Wenn die View erscheint, wird das Label gleich dem Namen des gewählten Faches gesetzt
    override func viewWillAppear(_ animated: Bool){
        fachLabel.text = fachName
         self.navigationController?.navigationBar.isHidden = false
    }
    
}
