//
//  FragenErstellenViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit

class FragenErstellenViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet var frageErstellen: UITextView!
    
    @IBOutlet var antwortAerstellen: UITextView!
    
    @IBOutlet var antwortBerstellen: UITextView!
    
    @IBOutlet var antwortCerstellen: UITextView!
    
    @IBOutlet var frageErstellenButton: UIButton!
    
    //textfield: keyboard
    @nonobjc func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "/n"){
            textView.resignFirstResponder()
            return false
        }
        return true
        
    }
    
    //textfield: placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if(frageErstellen.text == "Schreibe deine Frage rein.")
        {
            frageErstellen.text = ""
        }
        frageErstellen.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if(frageErstellen.text == "")
        {
            frageErstellen.text = "Schreibe deine Frage rein."
        }
        frageErstellen.resignFirstResponder()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}
