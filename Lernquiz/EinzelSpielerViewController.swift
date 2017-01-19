//
//  EinzelSpielerViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit
import Parse

class EinzelSpielerViewController: SpielmodusViewController{
    
    //Counter fuer Score, wird lokal gespeichert
    var Score: Int = 0
    
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet var FrageBewerten: UIButton!
    
    
    // Fragen für das Fach werden heruntergeladen und eine wird ausgewählt
    override func viewDidLoad() {
        super.viewDidLoad()
        
        download()
        
        //Sorgt dafuer, dass der Score beim Schließen der App nicht geloescht wird sondern lokal gespeichert (Muss aus irgendeinem Grund in der viewDidLoad Funktion stehen)
        let ScoreDefault = UserDefaults.standard
        
        if (ScoreDefault.value(forKey: "Score") != nil){
            Score = ScoreDefault.value(forKey: "Score") as! NSInteger!
            ScoreLabel.text = NSString(format: "Score : %i", Score) as String
        }
        
        pickQuestion()
    }
    
    override func antwortAuswerten(antwort : Antwort){
        var button : UIButton!
        switch antwort{ case .A: button = AntwortAButton; case .B: button = AntwortBButton; case .C: button = AntwortCButton }
        if Int(frageKarten[QNumber-1].RichtigeAntwortIndex) == Int(antwort.rawValue){
            if (hasSelected != true){
                Score += 1
                ScoreLabel.text = NSString(format: "Score : %i", Score) as String
                let ScoreDefault = UserDefaults.standard
                ScoreDefault.set(Score, forKey: "Score")
                ScoreDefault.synchronize()
            }
            button.backgroundColor = UIColor.green
            hasSelected = true
        }else{
            button.backgroundColor = UIColor.red
            hasSelected = true
        }
    }
}
