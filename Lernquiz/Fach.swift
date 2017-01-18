//
//  Fach.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import Foundation

class Fach : NSObject, NSCoding {
    
    var name: String
    var isSelected: Bool = false
    var Fragen = [Fragekarte]()
    var VorhandeneFragen: Int = 0
    
    
    // Konstruktor nur mit uebergebenen Namen
    init(name : String) {
        self.name = name
    }
    
    
    // Konstruktor mit uebergebenen Namen, Anzahl der Fragen und der Fragenkarten selbst
    init(name:String, VorhandeneFragen: Int, Fragen: [Fragekarte]) {
        self.name = name
        self.VorhandeneFragen = VorhandeneFragen
        self.Fragen = Fragen
    }
    
    
    // Benoetigter Konstruktor fuer das entpacken der Daten
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey:"name") as! String
        self.isSelected = aDecoder.decodeObject(forKey:"isSelected") as? Bool ?? false
        self.VorhandeneFragen = aDecoder.decodeObject(forKey:"VorhandeneFragen") as? Int ?? 0
        self.Fragen = aDecoder.decodeObject(forKey:"Fragen") as! [Fragekarte]
    }
    
    
    // Daten werden verpackt, um an den Server geschickt zu werden
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(isSelected, forKey: "isSelected")
        aCoder.encode(Fragen, forKey: "Fragen")
        aCoder.encode(VorhandeneFragen, forKey: "VorhandeneFragen")
    }
    
    
    // Sobald eine Frage hinzugefuegt wird, wird die Anzahl der Fragen hochgezaehlt
    func frageHinzufügen(Frage: Fragekarte){
        Fragen.append(Frage)
        VorhandeneFragen = VorhandeneFragen + 1
    }
    
    
    func frageLöschen(Frage: Fragekarte){
        var counting = 0
        while counting < Fragen.count{
            if Fragen[counting].FragenId ==  Frage.FragenId{
                Fragen.remove(at: counting)
                counting = counting + 1
            }
            else{
                counting = counting + 1
            }
            
        }
        
    }
}
