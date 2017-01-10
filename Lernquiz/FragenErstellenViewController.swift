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
  

    @IBOutlet var frageErstellen: UITextView!
    
    @IBOutlet var antwortAerstellen: UITextView!
    
    @IBOutlet var antwortBerstellen: UITextView!
    
    @IBOutlet var antwortCerstellen: UITextView!
    
    @IBOutlet var frageErstellenButton: UIButton!
    
    var frageKarte : Fragekarte = Fragekarte()
    var fach = String()
    
    //als Identifikator/Nummerierung für textViewTagging()
    enum FrageKartenID : Int { case Frage, AntwortA, AntwortB, AntwortC}

    
    // Erkennung in welchem Textfeld man sich gerade befindet
    func textViewTagging()
    {
        frageErstellen.tag = FrageKartenID.Frage.rawValue;
        antwortAerstellen.tag = FrageKartenID.AntwortA.rawValue;
        antwortBerstellen.tag = FrageKartenID.AntwortB.rawValue;
        antwortCerstellen.tag = FrageKartenID.AntwortC.rawValue;
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
        switch textView.tag
        {
        case 0: frageKarte.Fragentext = frageErstellen.text; frageErstellen.resignFirstResponder()
        case 1: frageKarte.AntwortA = antwortAerstellen.text; frageKarte.RichtigeAntwort = antwortAerstellen.text ; antwortAerstellen.resignFirstResponder()
        case 2: frageKarte.AntwortB = antwortBerstellen.text; antwortBerstellen.resignFirstResponder()
        case 3: frageKarte.AntwortC = antwortCerstellen.text; antwortCerstellen.resignFirstResponder()
        default: fatalError("Fehler in FrageErstellenVC - textViewShouldEndEditing - switch - wrong case")
        }
        
        print(frageKarte.toString())
        
    }
    
    // Fragekarte wird im Server hochgeladen, wird ausgefuehrt wenn frageErstellenButton ausgewaehlt wird
    func upload()
    {
        let hochzuladendesObjekt = PFObject(className: "Fragekarte")
        hochzuladendesObjekt["Frage"] = NSMutableArray(object: NSKeyedArchiver.archivedData(withRootObject: frageKarte))
        hochzuladendesObjekt["Fach"] = fach
        hochzuladendesObjekt.saveInBackground()
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        frageErstellen.delegate = self
        antwortAerstellen.delegate = self
        antwortBerstellen.delegate = self
        antwortCerstellen.delegate = self
        
        textViewTagging()
        
        //Berührungserkennung um das Keyboard verschwinden zu lassen
        let tap = UITapGestureRecognizer(target: self, action: #selector(FragenErstellenViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // Keyboard verschwindet, nach Ende der Textbearbeitung
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
