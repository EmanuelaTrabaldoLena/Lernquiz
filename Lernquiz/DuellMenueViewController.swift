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
    
    
    var aktiveSpiele = [Spiel]()
    var inaktiveSpiele = [Spiel]()
    
    override func viewDidLoad(){
        aktiveSpieleTV.dataSource = self
        aktiveSpieleTV.delegate = self
        inaktiveSpieleTV.dataSource = self
        inaktiveSpieleTV.delegate = self
        
        startRefreshTimer()
    }
    
    
    override func viewWillAppear(_ animated: Bool){
        self.navigationController?.navigationBar.isHidden = true
        aktiveSpiele = [Spiel]()
        inaktiveSpiele = [Spiel]()
        
        download()
        
        aktiveSpieleTV.reloadData()
        inaktiveSpieleTV.reloadData()
    }
    
    
    @IBAction func zumHauptmenue(_ sender: Any){
        //View wird mit pop vom Stack genommen
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func startRefreshTimer(){
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { (timer) in
            self.inaktiveSpiele.removeAll()
            self.aktiveSpiele.removeAll()
            
            self.download()
            
            self.aktiveSpieleTV.reloadData()
            self.inaktiveSpieleTV.reloadData()
        }
    }
    
    
    //Falls man in der TableView aktiveSpiele eine Zeile anwählt und das Spiel bereits fertig gespielt wurde, wird man zum Resultat, ansonsten in ein Duell weitergeleitet
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if tableView.isEqual(aktiveSpieleTV){
            //Spiel schon fertig gespielt
            if aktiveSpiele[indexPath.row].runde > 5{
                performSegue(withIdentifier: "DuellMenueVC2ResultatVC", sender: aktiveSpiele[indexPath.row])
            } else {
                if eigenerName == aktiveSpiele[indexPath.row].gegner.username //Bin ich der Gegner?
                {
                    gegnerName = aktiveSpiele[indexPath.row].spieler.username
                } else {                                                     //Bin ich der Spielersteller?
                    gegnerName = aktiveSpiele[indexPath.row].gegner.username
                }
                
                performSegue(withIdentifier: "DuellMenueVC2DuellVC", sender: aktiveSpiele[indexPath.row])
            }
        }
    }
    
    
    //Man wird entweder zum Duell oder zum Resutat weitergeleitet
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "DuellMenueVC2DuellVC"{
            let vc = segue.destination as! DuellViewController
            vc.spiel = sender as! Spiel
        } else if segue.identifier == "DuellMenueVC2ResultatVC"{
            let vc = segue.destination as! ResultatViewController
            vc.spiel = sender as! Spiel
            vc.allowDelete = true
        }
    }
    
    
    //Beide Tableviews werden mit den Gegnernamen gefüllt mit denen man ein Spiel führt, entweder man ist dran oder man muss auf den Gegner warte
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if (tableView.isEqual(aktiveSpieleTV)){
            let cell = tableView.dequeueReusableCell(withIdentifier: "aktiveSpieleCell", for: indexPath) as? SpielTableViewCell
            
            if aktiveSpiele[indexPath.row].gegner.username == eigenerName{
                cell?.textLabel?.text = aktiveSpiele[indexPath.row].spieler.username
            } else {
                cell?.textLabel?.text = aktiveSpiele[indexPath.row].gegner.username
            }
            return cell!
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "inaktiveSpieleCell", for: indexPath) as? SpielTableViewCell
            
            if inaktiveSpiele[indexPath.row].gegner.username == eigenerName{
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
    
    
    //Spieldaten werden vom Server gedownloadet
    func download(){
        let projectQuery = PFQuery(className: "Spiele")
        projectQuery.includeKey("Fach")
        projectQuery.whereKey("Fach", equalTo: fachName)
        
        do{
            let spiele = try projectQuery.findObjects()
            spiele_loop : for result in spiele{
                let encodedData = (result["Spiel"] as! NSMutableArray).firstObject as! NSData
                let spiel = NSKeyedUnarchiver.unarchiveObject(with: encodedData as Data) as! Spiel
                
                
                for lokalesSpiel in aktiveSpiele{
                    if spiel == lokalesSpiel{
                        continue spiele_loop
                    }
                }
                for lokalesSpiel in inaktiveSpiele{
                    if spiel == lokalesSpiel{
                        continue spiele_loop
                    }
                }
                
                // Verlgeich von Spielpartnerwahl, ob Gegner mich als Gegenspieler gewaehlt hat
                if ((spiel.gegner.username == eigenerName) || (spiel.spieler.username == eigenerName)){
                    
                    if (spiel.gegner.username != eigenerName) //Bin ich der Gegner?
                    {
                        if (spiel.gegner.getIstDran()){
                            inaktiveSpiele.append(spiel)
                            
                        }else{
                            aktiveSpiele.append(spiel)
                        }
                    } else {
                        if (spiel.gegner.getIstDran()){
                            aktiveSpiele.append(spiel)
                            
                        }else{
                            inaktiveSpiele.append(spiel)
                        }
                    }
                }
            }
        }catch{}
        aktiveSpieleTV.reloadData()
        inaktiveSpieleTV.reloadData()
    }
    
}
