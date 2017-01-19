//
//  CheckBoxView.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit

//Controller fuer die CheckBoxen von AlleFaecher
class CheckBoxView: UIView{
    
    var isChecked :Bool
    var checkBoxImageView :UIImageView
    var checkBoxChanged :() -> () = { }
    
    //NSCoder wird gebraucht, um Instanzen einer Klasse zu en- bzw. decoden
    required init(coder aDecoder: NSCoder){
        
        self.isChecked = false
        self.checkBoxImageView = UIImageView(image: nil)
        
        super.init(coder: aDecoder)!
        
        setup()
    }
    
    //Erstellung der CheckBox und Erkennung der Gesten/ Bewegungen
    func setup() {
        
        //Macht einen Rand
        self.layer.borderWidth = 1.0
        self.isUserInteractionEnabled = true
        
        self.checkBoxImageView.frame = CGRect(x:2,y:2,width:25,height:25)
        self.addSubview(self.checkBoxImageView)
        
        let selector :Selector = #selector(CheckBoxView.checkBoxTapped)
        
        //Erkennung der Beruehrung
        let tapRecognizer = UITapGestureRecognizer(target: self, action: selector)
        
        self.addGestureRecognizer(tapRecognizer)
        
    }
    
    //Wenn Checkbox beruehrt wird, wird sie ab- oder gewaehlt
    func checkBoxTapped() {
        self.checkBoxChanged()
    }
    
    //Wenn Box ausgewaehlt erscheint Bild vom Haken
    func markAsChecked() {
        self.checkBoxImageView.image = UIImage(named: "small-check")
    }
    
    //Wenn Box nicht ausgewaehlt, sieht man nur die leere Box
    func markAsUnChecked() {
        self.checkBoxImageView.image = nil
    }
}
