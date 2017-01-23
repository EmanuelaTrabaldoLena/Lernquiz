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
        var textView : UITextView!
        switch antwort { case .A: textView = antwortA; case .B: textView = antwortB; case .C: textView = antwortC}
        if Int(frageKarten[QNumber-1].RichtigeAntwortIndex) == Int(antwort.rawValue){
            textView.backgroundColor = UIColor.green
            
        }else{
            textView.backgroundColor = UIColor.red
        }
        
        hasSelected = true
        //Timer wird abgebrochen und restliche Sekunden bleiben stehen
        timer.invalidate()
        CountdownLabel.text = "\(seconds)"
        //Nachdem eine Antwort gedrückt wurde, erscheint der "Naechste Frage Button"
        naechsteFrageButton.isHidden = false
    }
    
    override func pickQuestion() {
        hasSelected = false
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(DuellViewController.updateTimer), userInfo: nil, repeats: true)
        
        antwortA.backgroundColor = UIColor.white
        antwortB.backgroundColor = UIColor.white
        antwortC.backgroundColor = UIColor.white
        
        if (QNumber < frageKarten.count){
            FrageLabel.text = frageKarten[QNumber].Fragentext
            antwortA.text! = frageKarten[QNumber].AntwortA
            antwortB.text! = frageKarten[QNumber].AntwortB
            antwortC.text! = frageKarten[QNumber].AntwortC
            
            print("Richtige Antwort-Index: \(frageKarten[QNumber].RichtigeAntwortIndex)")
            print("Richtige Antwort: \(frageKarten[QNumber].RichtigeAntwort)")
            
            QNumber += 1
        }else{
            NSLog("Keine weiteren Fragen")
        }
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
