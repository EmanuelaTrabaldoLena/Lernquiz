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
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        ermittleRelevanteFragen()
        pickQuestion(frageKartenLokal: relevanteFragen)
    }
    
    
    //Jedes Mal wenn die View erscheint, wird die Navigationbar versteckt
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction override func naechsteFrage(_ sender: Any){
        seconds = 30
        pickQuestion(frageKartenLokal: relevanteFragen)
        antwortA.isUserInteractionEnabled = true
        antwortB.isUserInteractionEnabled = true
        antwortC.isUserInteractionEnabled = true
        
    }
    
    
    //Wähle 3 zufällige FrageKarten aus dem Array "frageKarten" aus, die für jeden Spieler gleich sind.
    func ermittleRelevanteFragen(){
        var x = spiel.fragenKartenID[0]
        var y = spiel.fragenKartenID[1]
        var z = spiel.fragenKartenID[2]
        
        
        if (x == y) && (y == z){
            // Fallunterscheidung Beachte Grenzstellen!!!
        }else{
            if ((x == y) && x < frageKarten.count - 1){
                x += 1
            }else if (x == y){
                x -= 1
            }
            
            if ((x == z ) && x < frageKarten.count - 1){
                x += 1
            }else if (x == z){
                x -= 1
            }
            
            if ((y == z) && y < frageKarten.count - 1){
                y += 1
            } else if (y == z){
                y -= 1
            }
        }
        
        relevanteFragen = [ frageKarten[x], frageKarten[y], frageKarten[z] ]
    }
    
    
    //Überprüfung und Auswertung der einzelnen Runden
    func einzelRundenAuswertung(richtigeAntwort : Bool){
        if spiel.spieler.username == eigenerName{
            spiel.spieler.runden[spiel.runde][QNumber - 1] = richtigeAntwort
        }else{
            spiel.gegner.runden[spiel.runde][QNumber - 1] = richtigeAntwort
        }
    }
    
    
    //Hier werden die Hintergrundfarben der Antwortbutton je nach richtiger Antwort geändert und der Score erhöht, wenn die richtige Antwort zuerst gedrückt wird.
    override func antwortAuswerten(antwort : Antwort, firstTime : Bool){
        var textView : UITextView!
        switch antwort { case .A: textView = antwortA; case .B: textView = antwortB; case .C: textView = antwortC}

        if Int(relevanteFragen[QNumber-1].RichtigeAntwortIndex) == Int(antwort.rawValue){
            textView.backgroundColor = UIColor.green
            
            if firstTime{
                einzelRundenAuswertung(richtigeAntwort: true)

            }
            
        }else{
            if firstTime {
                einzelRundenAuswertung(richtigeAntwort: false)
         
            }
            
            textView.backgroundColor = UIColor.red
            
            if firstTime == true {
                switch antwort{
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
        if firstTime{
            
            hasSelected = true
            //Timer wird abgebrochen und restliche Sekunden bleiben stehen
            timer.invalidate()
            
            CountdownLabel.text = "\(seconds)"
            //Nachdem eine Antwort gedrückt wurde, erscheint der "Naechste Frage Button"
            naechsteFrageButton.isHidden = false

            
            //Falls hier die letzte Frage ausgewertet wird, leite über zur Auswertung/Übersichts
            if (super.QNumber == 3){
                updateRound()
                upload()
                naechsteFrageButton.isHidden = true
                delay(2, closure: {
                    if self.spiel.runde > 5
                    {
                        self.performSegue(withIdentifier: "DuellVC2ResultatVC", sender: self.spiel)
                    } else {
                        self.performSegue(withIdentifier: "DuellVC2DuellSpielstandVC", sender: self.spiel)
                    }
                })
            }
        }
    }
    
    
    //Überreiche Spiel an Übersicht
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "DuellVC2DuellSpielstandVC"{
            let vc = segue.destination as! DuellSpielstandViewController
            vc.spiel = sender as! Spiel
        }else if segue.identifier == "DuellVC2ResultatVC"{
            let vc = segue.destination as! ResultatViewController
            vc.spiel = sender as! Spiel
        }
    }
    
    
    //Wenn die Runde beendet wurde, wird diese hochgezählt und 3 neue Fragen geladen
    func updateRound(){
        synced(lock: self) {
            if spiel.gegner.username == eigenerName { //Bin ich der Gegenspieler?
                spiel.gegner.setRundeBeendet(true)
                spiel.gegner.setIstDran(false)
                spiel.spieler.setIstDran(true)
            }else{                                  //Bin ich der Spielersteller?
                spiel.spieler.setRundeBeendet(true)
                spiel.spieler.setIstDran(false)
                spiel.gegner.setIstDran(true)
            }
            if spiel.gegner.getRundeBeendet() && spiel.spieler.getRundeBeendet(){
                spiel.gegner.setRundeBeendet(false)
                spiel.spieler.setRundeBeendet(false)
                spiel.generateRandomQuestions()
                spiel.runde += 1
            }
        }
    }
    
    
    //Neuer Spielstand wird auf Server gespeichert
    func upload(){
        let spieleQuery = PFQuery(className: "Spiele")
        do{
            let spiele = try spieleQuery.findObjects()
            for result in spiele{
                let encodedData = (result["Spiel"] as! NSMutableArray).firstObject as! NSData
                let spielLokal = NSKeyedUnarchiver.unarchiveObject(with: encodedData as Data) as! Spiel
                
                if spiel == spielLokal{
                    let hochzuladendesObjekt = result
                    
                    hochzuladendesObjekt["Spiel"] = NSMutableArray(object: NSKeyedArchiver.archivedData(withRootObject: spiel))
                    hochzuladendesObjekt["Spieler"] = eigenerName
                    hochzuladendesObjekt["Gegner"] = gegnerName
                    hochzuladendesObjekt["Fach"] = fachName
                    
                    do{
                        try hochzuladendesObjekt.save()
                    }catch let error {
                        print("Fehler beim Upload der Spieldateien!\n\(error)")
                    }
                }
            }
        }catch{}
    }
    
    
    //Weist den Textviews den Text zu, laedt die Fragen nacheinander rein, wertet diese aus und laesst den Timer laufen
    override func pickQuestion(frageKartenLokal : [Fragekarte]){
        super.pickQuestion(frageKartenLokal: frageKartenLokal)
        
        hasSelected = false
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(DuellViewController.updateTimer), userInfo: nil, repeats: true)
        updateTimer()
        naechsteFrageButton.isHidden = true
    }
    
    
    //Es müssen erst die notwendigen Funktionen ausgeführt werden, bevor man weitere ausführen kann
    func synced(lock: AnyObject, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    
    // Timer gebastelt, der pro Frage 60 Sekunden runterzählt um die Frage zu beantworten
    var seconds: Int = 30
    var timer = Timer()
    var timerIsOn = false
    
    
    //Timer Funktion, die bei abgelaufener Zeit die richtige und falsche Antworten anzeigt
    func updateTimer(){
        if(seconds > 0){
            seconds -= 1
            CountdownLabel.text = "\(seconds)"
        }
        
        //Nachträglich ausgebessert, damit immer wenn der Timer abläuft, die Antwort als falsch gewertet wird
        if(seconds == 0){
            if Int(relevanteFragen[QNumber-1].RichtigeAntwortIndex) != Int(Antwort.A.rawValue) {
                antwortAuswerten(antwort: .A, firstTime: true)
            } else if Int(relevanteFragen[QNumber-1].RichtigeAntwortIndex) != Int(Antwort.B.rawValue){
                antwortAuswerten(antwort: .B, firstTime: true)
            } else {
                antwortAuswerten(antwort: .C, firstTime: true)
            }
            
        }
    }
    
}
