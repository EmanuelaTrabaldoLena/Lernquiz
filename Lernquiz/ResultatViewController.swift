//
//  ResultatViewController.swift
//  Lernquiz
//
//  Created by Lisa Lohner on 29.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import Foundation
import Parse

class ResultatViewController: UIViewController
{
    
    @IBOutlet weak var gegnerName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var meinPunkteL: UILabel!
    @IBOutlet weak var gegnerPunkteL: UILabel!
    @IBOutlet weak var resultatL: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var spiel = Spiel()
    var allowDelete = Bool()
    
    override func viewDidLoad()
    {
        // Schreibt über die Punkte den Namen der Spieler
        username.text = eigenerName
        if spiel.gegner.username == eigenerName{
            gegnerName.text = spiel.spieler.username
        }else{
            gegnerName.text = spiel.gegner.username
        }
        
        super.viewDidLoad()
        populateLabelsWithData()
        if allowDelete == true
        {
            deleteGame()
        }
    }
    
    @IBAction func zumHauptMenueA(_ sender: UIButton)
    {
        let controller = self.navigationController?.viewControllers[2]
        _ = self.navigationController?.popToViewController(controller!, animated: true)
    }
    
    func deleteGame()
    {
        let spieleQuery = PFQuery(className: "Spiele")
        do{
            let spiele = try spieleQuery.findObjects()
            for result in spiele{
                let encodedData = (result["Spiel"] as! NSMutableArray).firstObject as! NSData
                let spielLokal = NSKeyedUnarchiver.unarchiveObject(with: encodedData as Data) as! Spiel
                
                if spiel == spielLokal
                {
                    let zuloeschendeObjekt = result
                    do{
                        try zuloeschendeObjekt.delete()
                    }catch let error {
                        print("Fehler beim Löschen der Spieldateien!\n\(error)")
                    }
                }
            }
        }catch{}
    }
    
    func populateLabelsWithData()
    {
        var spielerScore = 0
        var gegnerScore = 0
        
        for i in 0 ..< 6
        {
            for j in 0 ..< 3
            {
                if spiel.spieler.runden[i][j] == true
                {
                    spielerScore += 1
                }
                if spiel.gegner.runden[i][j] == true
                {
                    gegnerScore += 1
                }
            }
        }
        
        if spiel.gegner.username == eigenerName
        {
            let x = spielerScore
            spielerScore = gegnerScore
            gegnerScore = x
        }
        
        meinPunkteL.text = NSString(format: "%i", spielerScore) as String
        gegnerPunkteL.text = NSString(format: "%i", gegnerScore) as String
        
    
        if gegnerScore-5 > spielerScore {
            resultatL.text = "Du wurdest gefressen!"
            image.image = UIImage(named: "Fish")
            }else if spielerScore == 18{
                resultatL.text = "Du bist eine richtige Strebereule!"
                image.image = UIImage(named: "owl")
            } else if spielerScore >= 15{
                resultatL.text = "Deine Gegner können sich warm anziehen!"
                image.image = UIImage(named: "bird")
            } else if spielerScore >= 12 {
                resultatL.text = "Du bist ein Fuchs!"
                image.image = UIImage(named: "fox")
            } else if spielerScore == gegnerScore {
                resultatL.text = "Ihr seid zwei fleißige Bienen!"
                image.image = UIImage(named: "bees-2")
            } else if spielerScore >= 9 {
                resultatL.text = "Übung macht den Meister!"
                image.image = UIImage(named: "elephant")
            } else if spielerScore >= 6 {
                resultatL.text = "Du lagst wohl zu viel auf der faulen Haut!"
                image.image = UIImage(named: "hippopotamus")
            } else if spielerScore < 6 {
                resultatL.text = "Das war wohl nix!"
                image.image = UIImage(named: "bulldog")
        }
        }
        
        
    }

    
    

