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
    @IBOutlet weak var gegnerPunktestand: UILabel!
    @IBOutlet weak var spielerPunktestand: UILabel!
    
    var spielerScore: Int = 0
    var gegnerScore: Int = 0
    
    var spiel = Spiel()
    
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
        gegenSpieler.text = gegnerName
        rundenTable.dataSource = self
        rundenTable.delegate = self
        score()
        super.viewDidLoad()
    }
    
    
    @IBAction func zumDuellmenue(_ sender: Any) {
        performSegue(withIdentifier: "DuellSpielstand2DuellMenue", sender: spiel)
    }
    
    
    //Spielstaende der einzelnen Runden werden gespeichert
    func score(){
        if let runde = spiel.spieler.runden[spiel.runde][0]{
            if runde == true{        self.spielerScore += 1
                spielerPunktestand.text = NSString(format: "%i", spielerScore) as String}
        }
        
        if let runde = spiel.spieler.runden[spiel.runde][1]{
            if runde == true{        spielerScore += 1
                spielerPunktestand.text = NSString(format: "%i", spielerScore) as String}
        }
        
        if let runde = spiel.spieler.runden[spiel.runde][2]{
            if runde == true{        spielerScore += 1
                spielerPunktestand.text = NSString(format: "%i", spielerScore) as String}
        }
        
        if let runde = spiel.gegner.runden[spiel.runde][0]{
            if runde == true{        gegnerScore += 1
                gegnerPunktestand.text = NSString(format: "%i", gegnerScore) as String}
        }
        
        if let runde = spiel.gegner.runden[spiel.runde][1]{
            if runde == true{         gegnerScore += 1
                gegnerPunktestand.text = NSString(format: "%i", gegnerScore) as String}
        }
        
        if let runde = spiel.gegner.runden[spiel.runde][2]{
            if runde == true{       gegnerScore += 1
                gegnerPunktestand.text = NSString(format: "%i", gegnerScore) as String}
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    
    //Die Buttons in der Tableview werden werden pro Runde gefaerbt, gruen fuer korrekte Antwort, rot fuer falsche Antwort
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RundenCell", for: indexPath) as! RundenTableViewCell
        
        cell.rundenLabel.text = "Runde \(indexPath.row + 1)"
        
        if let runde = spiel.spieler.runden[indexPath.row][0]{
            if runde == true {cell.duS1.backgroundColor = UIColor.green}
            if runde == false {cell.duS1.backgroundColor = UIColor.red}
        }
        
        if let runde = spiel.spieler.runden[indexPath.row][1]{
            if runde == true {cell.duS2.backgroundColor = UIColor.green}
            if runde == false {cell.duS2.backgroundColor = UIColor.red}
        }
        
        if let runde = spiel.spieler.runden[indexPath.row][2]{
            if runde == true {cell.duS3.backgroundColor = UIColor.green}
            if runde == false {cell.duS3.backgroundColor = UIColor.red}
        }
        
        if let runde = spiel.gegner.runden[indexPath.row][0]{
            if runde == true {cell.gsS1.backgroundColor = UIColor.green}
            if runde == false {cell.gsS1.backgroundColor = UIColor.red}
        }
        
        if let runde = spiel.gegner.runden[indexPath.row][1]{
            if runde == true {cell.gsS2.backgroundColor = UIColor.green}
            if runde == false {cell.gsS2.backgroundColor = UIColor.red}
        }
        
        if let runde = spiel.gegner.runden[indexPath.row][2]{
            if runde == true {cell.gsS3.backgroundColor = UIColor.green}
            if runde == false {cell.gsS3.backgroundColor = UIColor.red}
        }
        return cell
    }
}
