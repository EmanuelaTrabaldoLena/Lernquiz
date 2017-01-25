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
    
    //Counter für Score, wird lokal gespeichert
    var Score: Int = 0
    
    //Counter für "Frage melden"
    var meldung: Int = 0
    
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet var FrageBewerten: UIButton!
    
    //neu eingefügt um die Funktion naechsteFrage schreiben zu können, die beim Laden einer nächsten Frage auch den "Frage melden"-Button zurücksetzt
    @IBOutlet var naechsteFrageButton: UIButton!
    
    
    // Fragen für das Fach werden heruntergeladen und eine wird ausgewählt
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sorgt dafuer, dass der Score beim Schließen der App nicht geloescht wird sondern lokal gespeichert (Muss aus irgendeinem Grund in der viewDidLoad Funktion stehen)
        let ScoreDefault = UserDefaults.standard
        
        if (ScoreDefault.value(forKey: "Score") != nil){
            Score = ScoreDefault.value(forKey: "Score") as! NSInteger!
            ScoreLabel.text = NSString(format: "Score : %i", Score) as String
        }
    }
    
    
    override func antwortAuswerten(antwort : Antwort, firstTime: Bool = true){
        var textView : UITextView!
        switch antwort{ case .A: textView = antwortA; case .B: textView = antwortB; case .C: textView = antwortC}
        if Int(frageKarten[QNumber-1].RichtigeAntwortIndex) == Int(antwort.rawValue){
            if (hasSelected != true){
                Score += 1
                ScoreLabel.text = NSString(format: "Score : %i", Score) as String
                let ScoreDefault = UserDefaults.standard
                ScoreDefault.set(Score, forKey: "Score")
                ScoreDefault.synchronize()
            }
            textView.backgroundColor = UIColor.green
            hasSelected = true
        }else{
            textView.backgroundColor = UIColor.red
            hasSelected = true
        }
    }
    
    //Funktion die es erlaubt eine Frage zu melden, dabei wird der Text im Button zu "Fehler gemeldet" geändert und eine Meldung zur Variablen "meldung" hinzugefügt
    
    //es fehlt noch die explizite Speicherung dieser Meldung für die gerade gespielte Frage. Momentan existiert einfach nur die Zahl als Variable!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    @IBAction func FrageBewerten(_ sender: Any) {
        
        meldung += 1
        FrageBewerten.backgroundColor = UIColor.green
        FrageBewerten.setTitle("Frage gemeldet", for: [])
        
        //als Test
        print(meldung)
        
        //Man kann Button nur einmal klicken
        FrageBewerten.isEnabled = false
        
        //hier gehört jetzt noch rein, dass die Anzahl an Meldungen für die eine Frage mit dem Index "bla" gespeichert wird. Dazu wurde die Klasse "Fragekarte" schon erweitert (aber in auskommentierter Form)
    }
    
    
    //Funktion um die Farbe des "Frage melden"-Button auf rot + den Text im Button wieder auf "Fehler melden" zurückzusetzten
    func zuruecksetztenFrageBewertenButton(){
        
        FrageBewerten.backgroundColor = UIColor.red
        FrageBewerten.setTitle("Frage melden", for: [])
        
        //Man kann Button wieder klicken
        FrageBewerten.isEnabled = true
        
    }
}
