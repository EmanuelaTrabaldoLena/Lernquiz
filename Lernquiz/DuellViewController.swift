//
//  DuellViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit
import Parse

class DuellViewController: UIViewController {    
    
    @IBOutlet weak var naechsteFrageButton: UIButton!
    @IBOutlet weak var FrageLabel: UILabel!
    @IBOutlet weak var AntwortAButton: UIButton!
    @IBOutlet weak var AntwortBButton: UIButton!
    @IBOutlet weak var AntwortCButton: UIButton!

    var gewaehltesFach = [Fach]()
    
    // Gewaehlte Antwort
    var EineAntwort: Bool = true
    // Aktuelle Frage
    var CurrentQuestion: Int = 0
    
    // Counter fuer Score, wird lokal gespeichert
    var Score: Int = 0
    
    // Sorgt dafür, dass der Score nicht hochgeht, wenn erst eine falsche Antwort ausgewählt wird
    var hasSelected = false;
    
    var QNumber = Int()
    var frageKarten = [Fragekarte]()
    
    
    var spieler = Spieler()
    var gegner = Spieler()
    
    
    func download()
    {
        let projectQuery = PFQuery(className: "Fragekarte")
        //projectQuery.includeKey("Fach")
        //projectQuery.whereKey("Fach", equalTo: gewaehltesFach)
        
        do {
            let results = try projectQuery.findObjects()
            for result in results
            {
                let encodedData = (result["Frage"] as! NSMutableArray).firstObject as! NSData
                let frageKarte = NSKeyedUnarchiver.unarchiveObject(with: encodedData as Data) as! Fragekarte
                frageKarten.append(frageKarte)
                print(frageKarte.toString())
            }
            
        } catch {}
    }
    
    
//Weist den Buttons den Text zu und laedt die Fragen nacheinander rein bis keine mehr vorhanden sind
    
    func PickQuestion(){
        
        //Bei jeder neuen Frage werden die Farben der Antworten wieder auf weiß gesetzt und der Bool wieder auf false gesetzt bevor der erste Antwortbutton gedrückt wird
        naechsteFrageButton.isHidden = true
        //Sorgt dafür, dass der Timer bei jeder Frage läuft
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(DuellViewController.updateTimer), userInfo: nil, repeats: true)
        //Zeigt an, dass bisher noch keine Antwortmöglichkeit gedrückt wurde
        hasSelected = false
        
        AntwortAButton.backgroundColor = UIColor.white
        AntwortBButton.backgroundColor = UIColor.white
        AntwortCButton.backgroundColor = UIColor.white
        
        if QNumber < frageKarten.count
        {
            FrageLabel.text = frageKarten[QNumber].Fragentext
            AntwortAButton.setTitle(frageKarten[QNumber].AntwortA, for: UIControlState.normal)
            AntwortBButton.setTitle(frageKarten[QNumber].AntwortB, for: UIControlState.normal)
            AntwortCButton.setTitle(frageKarten[QNumber].AntwortC, for: UIControlState.normal)
            
            print("Richtige Antwort-Index: \(frageKarten[QNumber].RichtigeAntwortIndex)")
            print("Richtige Antwort: \(frageKarten[QNumber].RichtigeAntwort)")
            
            QNumber = QNumber + 1
        }
        else{
            NSLog("Keine weiteren Fragen")
        }
    }
    
    
    //Hier werden die Hintergrundfarben der Antwortbutton je nach richtiger Antwort geändert und der Score erhöht, wenn die richtige Antwort zuerst gedrückt wird.
    enum Antwort : Int { case A ; case B ; case C }
    func antwortAuswerten(antwort : Antwort)
    {
        var button : UIButton!
        switch antwort { case .A: button = AntwortAButton; case .B: button = AntwortBButton; case .C: button = AntwortCButton }
        if Int(frageKarten[QNumber-1].RichtigeAntwortIndex) == Int(antwort.rawValue)
        {
            if (hasSelected != true)
            {
                Score += 1
                print(Score)
//                ScoreLabel.text = NSString(format: "Score : %i", Score) as String
//                let ScoreDefault = UserDefaults.standard
//                ScoreDefault.set(Score, forKey: "Score")
//                ScoreDefault.synchronize()
            }
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
    
    
    @IBAction func AntwortA(_ sender: Any) {
            antwortAuswerten(antwort: .A)
        
    }
   
    @IBAction func AntwortB(_ sender: Any) {
            antwortAuswerten(antwort: .B)
    }
    
    @IBAction func AntwortC(_ sender: Any) {
            antwortAuswerten(antwort: .C)
    }
    
    // Schleife basteln, damit pro Runde 3 zufällige Fragen gestellt werden, für die jeweils ein Countdown von 60 Sekunden läuft
    
    // Wir brauchen eine Function, die die richtig beantworteten Frage in der Runde zusammenzählt
    // Alle 3 Fragen wurden beantwortet, jetzt muss man zur Übersicht mit den Spielständen gelangen
    
    // Timer gebastelt, der pro Frage 60 Sekunden runterzählt um die Frage zu beantworten
    
    var seconds: Int = 60
    var timer = Timer()
    var timerIsOn = false
 
    
    @IBOutlet weak var CountdownLabel: UILabel!
    
    //Timer Funktion, die bei abgelaufener Zeit die richtige und falsche Antworten anzeigt
    func updateTimer(){
        if seconds > 0 {
        seconds -= 1
       CountdownLabel.text = "\(seconds)"
        }
        
        if (seconds == 0){
            antwortAuswerten(antwort: .A)
            antwortAuswerten(antwort: .B)
            antwortAuswerten(antwort: .C)
            
    }
    }
    
    @IBAction func naechsteFrage(_ sender: Any) {
    
        seconds = 60
        PickQuestion()
    }
    
    // Fragen für das Fach werden heruntergeladen und eine wird ausgewählt
     override func viewDidLoad() {
        
        download()
        
        //Sorgt dafuer, dass der Score beim Schließen der App nicht geloescht wird sondern lokal gespeichert (Muss aus irgendeinem Grund in der viewDidLoad Funktion stehen)
//        let ScoreDefault = UserDefaults.standard
//        
//        if (ScoreDefault.value(forKey: "Score") != nil){
//            Score = ScoreDefault.value(forKey: "Score") as! NSInteger!
//            ScoreLabel.text = NSString(format: "Score : %i", Score) as String
        
        
        PickQuestion()
        
}

}
