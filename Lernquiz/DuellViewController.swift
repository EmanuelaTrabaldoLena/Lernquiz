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
    
    var relevanteFragen = [Fragekarte]()
    
    
    @IBAction override func naechsteFrage(_ sender: Any)
    {
        seconds = 60
        pickQuestion(frageKartenLokal: relevanteFragen)
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        ermittleRelevanteFragen()
    }
    
    
    //Wähle 3 zufällige FrageKarten aus dem Array "frageKarten" aus, die für jeden Spieler gleich sind.
    func ermittleRelevanteFragen()
    {
        var x = spiel.fragenKartenID[0]
        var y = spiel.fragenKartenID[1]
        var z = spiel.fragenKartenID[2]
        
        
        if (x == y) && (y == z)
        {
            // Fallunterscheidung Beachte Grenzstellen!!!
        } else {
            if ((x == y) && x < frageKarten.count - 1)
            {
                x += 1
            } else if (x == y){
                x -= 1
            }
            
            if ((x == z ) && x < frageKarten.count - 1)
            {
                x += 1
            } else if (x == z){
                x -= 1
            }
            
            if ((y == z) && y < frageKarten.count - 1)
            {
                y += 1
            } else if (y == z){
                y -= 1
            }
        }
        
        relevanteFragen = [ frageKarten[x],
                            frageKarten[y],
                            frageKarten[z]]
    }
    
    
    //Hier werden die Hintergrundfarben der Antwortbutton je nach richtiger Antwort geändert und der Score erhöht, wenn die richtige Antwort zuerst gedrückt wird.
    override func antwortAuswerten(antwort : Antwort, firstTime : Bool)
    {
        var textView : UITextView!
        switch antwort { case .A: textView = antwortA; case .B: textView = antwortB; case .C: textView = antwortC}
        
        if Int(frageKarten[QNumber-1].RichtigeAntwortIndex) == Int(antwort.rawValue)
        {
            textView.backgroundColor = UIColor.green
            
        }else{
            textView.backgroundColor = UIColor.red
            
            
            if firstTime == true
            {
                switch antwort
                {
                case .A:
                    antwortAuswerten(antwort: Antwort.B, firstTime: false)
                    antwortAuswerten(antwort: Antwort.C, firstTime: false)
                case .B:
                    antwortAuswerten(antwort: Antwort.A, firstTime: false)
                    antwortAuswerten(antwort: Antwort.C, firstTime: false)
                case .C:
                    antwortAuswerten(antwort: Antwort.A, firstTime: false)
                    antwortAuswerten(antwort: Antwort.B, firstTime: false)
                }
            }
            
            
        }

        hasSelected = true
        //Timer wird abgebrochen und restliche Sekunden bleiben stehen
        timer.invalidate()
        
        
       
        
        
        CountdownLabel.text = "\(seconds)"
        //Nachdem eine Antwort gedrückt wurde, erscheint der "Naechste Frage Button"
        naechsteFrageButton.isHidden = false
    }
    
    
    
    override func pickQuestion(frageKartenLokal : [Fragekarte])
    {
        
        super.pickQuestion(frageKartenLokal: frageKartenLokal)

        hasSelected = false
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(DuellViewController.updateTimer), userInfo: nil, repeats: true)
        updateTimer()
        naechsteFrageButton.isHidden = true
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
            antwortAuswerten(antwort: .A, firstTime: true)
        }
    }
    
}
