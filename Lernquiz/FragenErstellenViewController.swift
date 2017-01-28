//
//  FragenErstellenViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit
import Parse

class FragenErstellenViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var frageErstellen: UITextView!
    @IBOutlet var antwortAerstellen: UITextView!
    @IBOutlet var antwortBerstellen: UITextView!
    @IBOutlet var antwortCerstellen: UITextView!
    @IBOutlet var frageErstellenButton: UIButton!
    
    var frageKarte : Fragekarte = Fragekarte()
    //als Identifikator/Nummerierung für textViewTagging()
    enum FrageKartenID : Int { case Frage, AntwortA, AntwortB, AntwortC}
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        frageErstellen.delegate = self
        antwortAerstellen.delegate = self
        antwortBerstellen.delegate = self
        antwortCerstellen.delegate = self
        
        //Erster Buchstabe im Feld wird nicht gezwungenermaßen groß geschrieben
        frageErstellen.autocapitalizationType = UITextAutocapitalizationType.none
        antwortAerstellen.autocapitalizationType = UITextAutocapitalizationType.none
        antwortBerstellen.autocapitalizationType = UITextAutocapitalizationType.none
        antwortCerstellen.autocapitalizationType = UITextAutocapitalizationType.none
        
        textViewTagging()
        
        //Berührungserkennung um das Keyboard verschwinden zu lassen
        let tap = UITapGestureRecognizer(target: self, action: #selector(FragenErstellenViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    // Frage wird erstellt und wenn auf den Button geklickt wird, werden überall die Texteingaben beendet und hochgeladen
    @IBAction func upload_A(_ sender: UIButton) {
        textViewDidEndEditing(frageErstellen)
        textViewDidEndEditing(antwortAerstellen)
        textViewDidEndEditing(antwortBerstellen)
        textViewDidEndEditing(antwortCerstellen)
        
        frageKarte.swap()
        frageKarte.ermittleRichtigeAntwortIndex()
        upload()
        performSegue(withIdentifier: "FrageErstellen2ES/Duell/Frage", sender: nil)
    }
    
    
    // Erkennung in welchem Textfeld man sich gerade befindet
    func textViewTagging(){
        frageErstellen.tag = FrageKartenID.Frage.rawValue;
        antwortAerstellen.tag = FrageKartenID.AntwortA.rawValue;
        antwortBerstellen.tag = FrageKartenID.AntwortB.rawValue;
        antwortCerstellen.tag = FrageKartenID.AntwortC.rawValue;
    }
    
    //Zeichenbeschränkung ist jetzt bei Frage auf 200 und bei Antworten auf 100
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.tag == frageErstellen.tag{
            return textView.text.characters.count + (text.characters.count - range.length) <= 200
        }else{
            return textView.text.characters.count + (text.characters.count - range.length) <= 100
        }
    }
    
    
    /* Loescht den Text im Feld, sobald dieses angewaehlt wird, sobald das Keyboard erscheint, schreibt
     man im ausgewaehlten Feld */
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView.tag{
        case 0: frageErstellen.text = ""; frageErstellen.becomeFirstResponder()
        case 1: antwortAerstellen.text = ""; antwortAerstellen.becomeFirstResponder()
        case 2: antwortBerstellen.text = ""; antwortBerstellen.becomeFirstResponder()
        case 3: antwortCerstellen.text = ""; antwortCerstellen.becomeFirstResponder()
        default: fatalError("Fehler in FrageErstellenVC - textViewShouldEndEditing - switch - wrong case")
        }
    }
    
    
    /* Der Text wird in der zu erstellenden Fragekarte gespeichert und man wird anschliessend von der
     ausgewaehlten Textview abgemeldet */
    func textViewDidEndEditing(_ textView: UITextView)
    {
        
        switch textView.tag{
        case 0: frageKarte.Fragentext = frageErstellen.text; frageErstellen.resignFirstResponder()
        case 1: frageKarte.AntwortA = antwortAerstellen.text; frageKarte.RichtigeAntwort = antwortAerstellen.text ; antwortAerstellen.resignFirstResponder()
        case 2: frageKarte.AntwortB = antwortBerstellen.text; antwortBerstellen.resignFirstResponder()
        case 3: frageKarte.AntwortC = antwortCerstellen.text; antwortCerstellen.resignFirstResponder()
        default: fatalError("Fehler in FrageErstellenVC - textViewShouldEndEditing - switch - wrong case")
        }
        frageKarte.fachName = fachName
        print(frageKarte.toString())
    }
    
    
    // Fragekarte wird im Server hochgeladen, wird ausgefuehrt wenn frageErstellenButton ausgewaehlt wird
    func upload(){
        let hochzuladendesObjekt = PFObject(className: "Fragekarte")
        hochzuladendesObjekt["Frage"] = NSMutableArray(object: NSKeyedArchiver.archivedData(withRootObject: frageKarte))
        hochzuladendesObjekt["Fach"] = fachName
        hochzuladendesObjekt["FrageGemeldet"] = frageGemeldet
        hochzuladendesObjekt.saveInBackground()
    }
    
    
    // Keyboard verschwindet, nach Ende der Textbearbeitung
    func dismissKeyboard(){
        view.endEditing(true)
    }
}
