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
    
    var frageKarte : Frage = Frage()
    
    //textfield: keyboard
    @nonobjc func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "/n"){
            textView.resignFirstResponder()
            return false
        }
        return true
        
    }
    
    func speichernFrage (){
        // Objekte werden im Server erstellt und gespeichert
        let testObject = PFObject(className: "Fragekarte")
        testObject["Name"] = "bar"
        do{
            try testObject.save()
        } catch {}
    }

    // Erkennung in welchem Textfeld man sich gerade befindet
    func textViewTagging()
    {
        frageErstellen.tag = FrageKartenID.Frage.rawValue;
        antwortAerstellen.tag = FrageKartenID.AntwortA.rawValue;
        antwortBerstellen.tag = FrageKartenID.AntwortB.rawValue;
        antwortCerstellen.tag = FrageKartenID.AntwortC.rawValue;
    }
    

    // textfield: placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        
       
        //textView.text = ""
        frageErstellen.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        
        switch textView.tag
        {
        case 0: frageKarte.Fragentext = frageErstellen.text
        case 1: frageKarte.AntwortA = antwortAerstellen.text
        case 2: frageKarte.AntwortB = antwortBerstellen.text
        case 3: frageKarte.AntwortC = antwortCerstellen.text
        default: fatalError("Fehler in FrageErstellenVC - textViewShouldEndEditing - switch - wrong case")
        }
        
        print(frageKarte.toString())
        frageErstellen.resignFirstResponder()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        print("HAllO")
        return true
    }
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        frageErstellen.delegate = self
        antwortAerstellen.delegate = self
        antwortBerstellen.delegate = self
        antwortCerstellen.delegate = self
        
        //Berührungserkennung um das Keyboard verschwinden zu lassen
        let tap = UITapGestureRecognizer(target: self, action: #selector(FragenErstellenViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
}
extension UITextView
{
    //var idS : FrageKartenID {get set}
}

//als Identifikator/Nummerierung für textViewDidEndEditing
enum FrageKartenID : Int
{
    case Frage
    case AntwortA
    case AntwortB
    case AntwortC
}
