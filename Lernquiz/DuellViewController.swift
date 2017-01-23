//
//  DuellViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit
import Parse

class DuellViewController: SpielmodusViewController{
    
    @IBOutlet weak var CountdownLabel: UILabel!
    @IBOutlet weak var naechsteFrageButton: UIButton!
    
    var spiel = Spiel()
    
    
    override func viewDidLoad(){
        download()
        //Sorgt dafuer, dass der Score beim Schließen der App nicht geloescht wird sondern lokal gespeichert (Muss aus irgendeinem Grund in der viewDidLoad Funktion stehen)
        //        let ScoreDefault = UserDefaults.standard
        //
        //        if (ScoreDefault.value(forKey: "Score") != nil){
        //            Score = ScoreDefault.value(forKey: "Score") as! NSInteger!
        //            ScoreLabel.text = NSString(format: "Score : %i", Score) as String
        pickQuestion()

    }
    
    
    //Hier werden die Hintergrundfarben der Antwortbutton je nach richtiger Antwort geändert und der Score erhöht, wenn die richtige Antwort zuerst gedrückt wird.
    override func antwortAuswerten(antwort : Antwort){
        var button : UIButton!
        switch antwort { case .A: button = AntwortAButton; case .B: button = AntwortBButton; case .C: button = AntwortCButton }
        if Int(frageKarten[QNumber-1].RichtigeAntwortIndex) == Int(antwort.rawValue){
            button.backgroundColor = UIColor.green
            
        }else{
            button.backgroundColor = UIColor.red
        }
        
        hasSelected = true
        //Timer wird abgebrochen und restliche Sekunden bleiben stehen
        timer.invalidate()
        CountdownLabel.text = "\(seconds)"
        //Nachdem eine Antwort gedrückt wurde, erscheint der "Naechste Frage Button"
        naechsteFrageButton.isHidden = false
    }
    
    
    // Schleife basteln, damit pro Runde 3 zufällige Fragen gestellt werden, für die jeweils ein Countdown von 60 Sekunden läuft
    // Wir brauchen eine Function, die die richtig beantworteten Frage in der Runde zusammenzählt
    // Alle 3 Fragen wurden beantwortet, jetzt muss man zur Übersicht mit den Spielständen gelangen
    
    
    // Timer gebastelt, der pro Frage 60 Sekunden runterzählt um die Frage zu beantworten
    var seconds: Int = 60
    var timer = Timer()
    var timerIsOn = false
    
    
    //Timer Funktion, die bei abgelaufener Zeit die richtige und falsche Antworten anzeigt
    func updateTimer(){
        if(seconds > 0){
            seconds -= 1
            CountdownLabel.text = "\(seconds)"
        }
        
        if(seconds == 0){
            antwortAuswerten(antwort: .A)
            antwortAuswerten(antwort: .B)
            antwortAuswerten(antwort: .C)
        }
    }
    
    @IBAction override func naechsteFrage(_ sender: Any){
        seconds = 60
        pickQuestion()
    }
    
}
