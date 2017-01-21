//
//  DuellSpielstandViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 15.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit


class DuellSpielstandViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var gegenSpieler: UILabel!
    @IBOutlet weak var rundenTable: UITableView!


    var spiel = Spiel()
    
    override func viewWillAppear(_ animated: Bool) {
        gegenSpieler.text = gegnerName
        
    }
    
    override func viewDidLoad() {
        
        rundenTable.dataSource = self
        rundenTable.delegate = self
        
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RundenCell", for: indexPath) as! RundenTableViewCell
        
        cell.rundenLabel.text = "Runde \(indexPath.row + 1)"
        
        if let runde = spiel.spieler.einzelrunde?[0]
        {
            if runde == true {cell.duS1.backgroundColor = UIColor.green}
            if runde == false {cell.duS1.backgroundColor = UIColor.red}
        }
        if let runde = spiel.spieler.einzelrunde?[1]
        {
            if runde == true {cell.duS2.backgroundColor = UIColor.green}
            if runde == false {cell.duS2.backgroundColor = UIColor.red}
        }
        if let runde = spiel.spieler.einzelrunde?[2]
        {
            if runde == true {cell.duS3.backgroundColor = UIColor.green}
            if runde == false {cell.duS3.backgroundColor = UIColor.red}
        }
        
        if let runde = spiel.gegner.einzelrunde?[0]
        {
            if runde == true {cell.gsS1.backgroundColor = UIColor.green}
            if runde == false {cell.gsS1.backgroundColor = UIColor.red}
        }
        if let runde = spiel.gegner.einzelrunde?[1]
        {
            if runde == true {cell.gsS2.backgroundColor = UIColor.green}
            if runde == false {cell.gsS2.backgroundColor = UIColor.red}
        }
        if let runde = spiel.gegner.einzelrunde?[2]
        {
            if runde == true {cell.gsS3.backgroundColor = UIColor.green}
            if runde == false {cell.gsS3.backgroundColor = UIColor.red}
        }

        return cell
    }
    
    
    
}
