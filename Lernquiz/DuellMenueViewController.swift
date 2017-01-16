//
//  DuellMenueViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 15.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit
import Parse

class DuellMenueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var aktiveSpieleTV: UITableView!
    @IBOutlet weak var inaktiveSpieleTV: UITableView!
    
    var aktiveSpiele = [Spiel]()
    var inaktiveSpiele = [Spiel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aktiveSpieleTV.dataSource = self
        aktiveSpieleTV.delegate = self
        inaktiveSpieleTV.dataSource = self
        inaktiveSpieleTV.delegate = self
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView.isEqual(aktiveSpieleTV))
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "aktiveSpieleCell", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "inaktiveSpieleCell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.isEqual(aktiveSpieleTV))
        {
            return aktiveSpiele.count
        } else {
            return inaktiveSpiele.count
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool){
        download()
    }
    
    func download() {
        let projectQuery = PFQuery(className: "Spiele")
        
        do {
            let spiele = try projectQuery.findObjects()
            for result in spiele
            {
                let encodedData = (result["Spiel"] as! NSMutableArray).firstObject as! NSData
                let spiel = NSKeyedUnarchiver.unarchiveObject(with: encodedData as Data) as! Spiel
                // Verlgeich von Spielpartnerwahl, ob Gegner mich als Gegenspieler gewaehlt hat
                
                if ((spiel.gegner.username == eigenerName) || (spiel.spieler.username == eigenerName))
                {
                    if (spiel.gegner.istDran)
                    {
                        inaktiveSpiele.append(spiel)
                    } else {
                        aktiveSpiele.append(spiel)
                    }
                }
            }
            
        } catch {}
    }
    
}
