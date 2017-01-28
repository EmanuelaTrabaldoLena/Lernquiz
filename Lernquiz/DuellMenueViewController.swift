//
//  DuellMenueViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 15.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit
import Parse

class DuellMenueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var aktiveSpieleTV: UITableView!

    @IBOutlet weak var inaktiveSpieleTV: UITableView!


    @IBAction func zumHauptmenue(_ sender: Any) {
       //View wird mit pop vom Stack genommen
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    var aktiveSpiele = [Spiel]()
    var inaktiveSpiele = [Spiel]()
    var spiel = Spiel()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        aktiveSpieleTV.dataSource = self
        aktiveSpieleTV.delegate = self
        inaktiveSpieleTV.dataSource = self
        inaktiveSpieleTV.delegate = self
        
        //download()
        
        aktiveSpieleTV.reloadData()
        inaktiveSpieleTV.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.isEqual(aktiveSpieleTV)
        {
            performSegue(withIdentifier: "DuellMenueVC2DuellVC", sender: aktiveSpiele[indexPath.row])
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "DuellMenueVC2DuellVC"
        {
            let vc = segue.destination as! DuellViewController
            vc.spiel = sender as! Spiel
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if (tableView.isEqual(aktiveSpieleTV)){
            let cell = tableView.dequeueReusableCell(withIdentifier: "aktiveSpieleCell", for: indexPath) as? SpielTableViewCell
            
            
            if aktiveSpiele[indexPath.row].gegner.username == eigenerName
            {
                cell?.textLabel?.text = aktiveSpiele[indexPath.row].spieler.username
            } else {
                cell?.textLabel?.text = aktiveSpiele[indexPath.row].gegner.username
            }
            return cell!
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "inaktiveSpieleCell", for: indexPath) as? SpielTableViewCell
            
            if inaktiveSpiele[indexPath.row].gegner.username == eigenerName
            {
                cell?.textLabel?.text = inaktiveSpiele[indexPath.row].spieler.username
            } else {
                cell?.textLabel?.text = inaktiveSpiele[indexPath.row].gegner.username
            }
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (tableView.isEqual(aktiveSpieleTV)){
           return aktiveSpiele.count
           
        }else{
            return inaktiveSpiele.count
           
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool){
        download()
        aktiveSpieleTV.reloadData()
        inaktiveSpieleTV.reloadData()
    }
    
    
    func download(){
        let projectQuery = PFQuery(className: "Spiele")
        projectQuery.includeKey("Fach")
        projectQuery.whereKey("Fach", equalTo: fachName)
        
        do{
            let spiele = try projectQuery.findObjects()
            spiele_loop : for result in spiele{
                let encodedData = (result["Spiel"] as! NSMutableArray).firstObject as! NSData
                let spiel = NSKeyedUnarchiver.unarchiveObject(with: encodedData as Data) as! Spiel
                
                
                for lokalesSpiel in aktiveSpiele
                {
                    if spiel == lokalesSpiel
                    {
                       continue spiele_loop
                    }
                }
                for lokalesSpiel in inaktiveSpiele
                {
                    if spiel == lokalesSpiel
                    {
                        continue spiele_loop
                    }
                }
                
                
                // Verlgeich von Spielpartnerwahl, ob Gegner mich als Gegenspieler gewaehlt hat
                if ((spiel.gegner.username == eigenerName) || (spiel.spieler.username == eigenerName)){
                    
                    
                    if (spiel.gegner.username != eigenerName) //Bin ich der Gegner?
                    {
                        if (spiel.gegner.istDran)
                        {
                            inaktiveSpiele.append(spiel)
                            
                        }else{
                            aktiveSpiele.append(spiel)
                        }
                    } else {
                        if (spiel.gegner.istDran)
                        {
                            aktiveSpiele.append(spiel)
                            
                        }else{
                            inaktiveSpiele.append(spiel)
                        }
                    }
                }
            }
        }catch{}
    }
    
}
