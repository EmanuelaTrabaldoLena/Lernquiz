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

    
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet var FrageBewerten: UIButton!
    
    //neu eingefügt um die Funktion naechsteFrage schreiben zu können, die beim Laden einer nächsten Frage auch den "Frage melden"-Button zurücksetzt
    @IBOutlet var naechsteFrageButton: UIButton!
    
    
    // Fragen für das Fach werden heruntergeladen und eine wird ausgewählt
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickQuestion(frageKartenLokal: frageKarten)

        
        //Sorgt dafuer, dass der Score beim Schließen der App nicht geloescht wird sondern lokal gespeichert (Muss aus irgendeinem Grund in der viewDidLoad Funktion stehen)
        let ScoreDefault = UserDefaults.standard
        
        if (ScoreDefault.value(forKey: "Score") != nil){
            Score = ScoreDefault.value(forKey: "Score") as! NSInteger!
            ScoreLabel.text = NSString(format: "Score : %i", Score) as String
        }
    }
    
    
    //Wenn die Antwort gewählt wurde, wird sie je nachdem ob sie wahr oder falsch ist, ausgewertet und grün oder rot eingefärbt
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
    
    
    //Wenn die Frage gemeldet wird, wird der Zähler im Server um 1 hochgezählt, dafür muss zunächst die Karte nochmal gedownloadet werden, der Wert verändert werden und dann wieder hochgeladen werden
    @IBAction func FrageBewerten(_ sender: Any){
        downloadFrageKarte()
        uploadFrageKarte()
        
        FrageBewerten.backgroundColor = UIColor.green
        FrageBewerten.setTitle("Frage gemeldet", for: .normal)
        
        //Man kann Button nur einmal klicken
        FrageBewerten.isEnabled = false
        update()
    }
    
    
    //Fragekarte wird vom Server geholt und die Anzahl der Meldungen wird hochgezählt
    func downloadFrageKarte(){
        let projectQuery = PFQuery(className: "Fragekarte")
        projectQuery.includeKey("Fach")
        projectQuery.whereKey("Fach", equalTo: fachName)
        do{
            let results = try projectQuery.findObjects()
            for result in results{
                let encodedData = (result["Frage"] as! NSMutableArray).firstObject as! NSData
                let frageKarteLokal = NSKeyedUnarchiver.unarchiveObject(with: encodedData as Data) as! Fragekarte
                
                if frageKarteLokal == frageKarten[QNumber - 1]{
                    frageKarteLokal.setFrageGemeldet(anzahl: frageKarteLokal.getFrageGemeldet() + 1)
                    frageKarten[QNumber - 1] = frageKarteLokal
                }
                
            }
        }catch{}
    }

    
    //Die veränderte Fragekarte wird wieder im Server hochgeladen
    func uploadFrageKarte(){
        let frageKartenQuery = PFQuery(className: "Fragekarte")
        do{
            let frageKartenPFO = try frageKartenQuery.findObjects()
            for result in frageKartenPFO{
                let encodedData = (result["Frage"] as! NSMutableArray).firstObject as! NSData
                let frageKarteLokal = NSKeyedUnarchiver.unarchiveObject(with: encodedData as Data) as! Fragekarte
                
                if frageKarten[QNumber - 1] == frageKarteLokal{
                    let hochzuladendesObjekt = result
                    
                    hochzuladendesObjekt["Frage"] = NSMutableArray(object: NSKeyedArchiver.archivedData(withRootObject: frageKarten[QNumber - 1]))
                    hochzuladendesObjekt["FrageGemeldet"] = frageKarten[QNumber - 1].getFrageGemeldet()

                    do{
                        try hochzuladendesObjekt.save()
                    }catch let error {
                        print("Fehler beim Upload der FrageKarte!\n\(error)")
                    }
                }
            }
        }catch{}
    }
    
    
    //Falls die Frage weniger als 3 Mal gemeldet wurde, passiert nichts, ansonsten wird sie gelöscht
    func update(){
        if Int(frageKarten[QNumber-1].getFrageGemeldet()) < 3 {
            print("Frage selten gemeldet. Frage wird nicht gelöscht, da \(frageKarten[QNumber-1].getFrageGemeldet()) von 3 Meldungen.")
        }else{
            loescheFragekarte()
            print("Fragekarte gelöscht")
        }
    }
    
    
    //Fragekarte wird bei 3 Meldungen aus dem Server gelöscht
    func loescheFragekarte(){
        let projectQuery = PFQuery(className: "Fragekarte")
        do{
            let frage = try projectQuery.findObjects()
            for result in frage{
                let encodedData = (result["Frage"] as! NSMutableArray).firstObject as! NSData
                let frageKarteLokal = NSKeyedUnarchiver.unarchiveObject(with: encodedData as Data) as! Fragekarte
                
                if frageKarten[QNumber-1] == frageKarteLokal{
                    do {
                        try result.delete()
                    } catch let error {
                        print("Fehler beim löschen der Fragekarte\(error)")
                    }
                }
            }
        }catch{}
    }
    
    
    //Funktion um die Farbe des "Frage melden"-Button auf rot + den Text im Button wieder auf "Fehler melden" zurückzusetzten
    func zuruecksetztenFrageBewertenButton(){
        
        FrageBewerten.backgroundColor = UIColor.red
        FrageBewerten.setTitle("Frage melden", for: [])
        
        //Man kann Button wieder klicken
        FrageBewerten.isEnabled = true
        
    }
}
