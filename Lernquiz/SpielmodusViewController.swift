//
//  SpielmodusViewController.swift
//  Lernquiz
//
//  Created by Lisa Lohner on 11.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit
import Parse

class SpielmodusViewController: UIViewController, UITextViewDelegate {
    
    // Outlets fuer Buttons und Labels, die mit Storyboard verknuepft sind
    @IBOutlet weak var FrageLabel: UILabel!
    @IBOutlet weak var antwortA: UITextView!
    @IBOutlet weak var antwortB: UITextView!
    @IBOutlet weak var antwortC: UITextView!
    @IBOutlet weak var naechsteFrage: UIButton!
    
    //Gewaehlte Antwort
    var EineAntwort: Bool = true
    //Aktuelle Frage
    var CurrentQuestion: Int = 0
    //Sorgt dafür, dass der Score nicht hochgeht, wenn erst eine falsche Antwort ausgewählt wird
    var hasSelected = false;
    //Nummer der Frage fuer die Erkennung
    var QNumber = Int()
    var frageKarten = [Fragekarte]()
    
    //als Identifikator/Nummerierung für textViewTagging()
    enum TextFieldID : Int { case AntwortA, AntwortB, AntwortC}
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        download()
        
        antwortA.delegate = self
        antwortB.delegate = self
        antwortC.delegate = self
        
        //Textview kann von Nutzer nicht bearbeitet werden
        antwortA.isEditable = false
        antwortB.isEditable = false
        antwortC.isEditable = false
        
        //Text in der Textview wird horizontal zentriert
        antwortA.textAlignment = .center
        antwortB.textAlignment = .center
        antwortC.textAlignment = .center
        
        //Beruehrungserkennung bei anwaehlen der 
        let tapA = UITapGestureRecognizer(target: self, action: #selector(SpielmodusViewController.antwortAuswertenA))
        antwortA.addGestureRecognizer(tapA)
        let tapB = UITapGestureRecognizer(target: self, action: #selector(SpielmodusViewController.antwortAuswertenB))
        antwortB.addGestureRecognizer(tapB)
        let tapC = UITapGestureRecognizer(target: self, action: #selector(SpielmodusViewController.antwortAuswertenC))
        antwortC.addGestureRecognizer(tapC)
    }
    
    
    func antwortAuswertenA(){
        antwortAuswerten(antwort: .A)
    }
    
    
    func antwortAuswertenB(){
        antwortAuswerten(antwort: .B)
    }
    
    
    func antwortAuswertenC(){
        antwortAuswerten(antwort: .C)
    }
    
    //Weist den Textviews den Text zu und laedt die Fragen nacheinander rein bis keine mehr vorhanden sind
    func pickQuestion(){
        //Bei jeder neuen Frage werden die Farben der Antworten wieder auf weiß gesetzt und der Bool wieder auf false gesetzt bevor der erste Antwortbutton gedrückt wird
        hasSelected = false
        
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

    }
    
    
    @IBAction func naechsteFrage(_ sender: Any){
        antwortA.text = ""
        antwortB.text = ""
        antwortC.text = ""
        
        pickQuestion()
    }
    
    //Hier werden die Hintergrundfarben der Antwortbutton je nach richtiger Antwort geändert und der Score erhöht, wenn die richtige Antwort zuerst gedrückt wird.
    enum Antwort : Int { case A ; case B ; case C }
    
    func antwortAuswerten(antwort : Antwort){
        var textView : UITextView!
        switch antwort{ case .A: textView = antwortA; case .B: textView = antwortB; case .C: textView = antwortC}
        if Int(frageKarten[QNumber-1].RichtigeAntwortIndex) == Int(antwort.rawValue){
            textView.backgroundColor = UIColor.green
            hasSelected = true
        }else{
            textView.backgroundColor = UIColor.red
            hasSelected = true
        }
    }
    
    
    //Fragen werden vom Server gedownloadet
    func download(){
        let projectQuery = PFQuery(className: "Fragekarte")
        projectQuery.includeKey("Fach")
        projectQuery.whereKey("Fach", equalTo: fachName)
        
        do{
            let results = try projectQuery.findObjects()
            for result in results{
                let encodedData = (result["Frage"] as! NSMutableArray).firstObject as! NSData
                let frageKarte = NSKeyedUnarchiver.unarchiveObject(with: encodedData as Data) as! Fragekarte
                frageKarten.append(frageKarte)
                print(frageKarte.toString())
            }
        }catch{}
    }
}


