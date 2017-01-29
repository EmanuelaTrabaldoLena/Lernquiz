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
    
    @IBOutlet weak var meinPunkteL: UILabel!
    @IBOutlet weak var gegnerPunkteL: UILabel!
    @IBOutlet weak var resultatL: UILabel!
    
    var spiel = Spiel()
    var allowDelete = Bool()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        populateLabelsWithData()
        if allowDelete == true
        {
            deleteGame()
        }
    }
    
    @IBAction func zumHauptMenueA(_ sender: UIButton)
    {
        performSegue(withIdentifier: "ResultatVC2DuellMenueVC", sender: nil)
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
        
        if spielerScore > gegnerScore
        {
            resultatL.text = "Du hast gewonnen!"
        } else if spielerScore == gegnerScore {
            resultatL.text = "Unentschieden!"
        } else if spielerScore < gegnerScore {
            resultatL.text = "Du hast verloren!"
        }
    }
    
    
    
}
