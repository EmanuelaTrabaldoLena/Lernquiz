//
//  Fach.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import Foundation
import Parse

class Fach : NSObject, NSCoding, NSCopying {
    
    var name: String
    var isSelected: Bool = false
    var Fragen = [Fragekarte]()
    
    
    //Leerer Konstruktor, der den Namen als String setzt 
    override init(){
        self.name = String()
    }
    
    
    //Konstruktor nur mit uebergebenen Namen
    init(name : String){
        self.name = name
    }
    
    
    //Konstruktor mit uebergebenen Namen und Wert ob das Fach gewählt wurde
    init(name: String, isSelected : Bool){
        self.name = name
        self.isSelected = isSelected
    }
    
    
    //Konstruktor mit uebergebenen Namen und der Fragenkarten selbst
    init(name:String, Fragen: [Fragekarte]){
        self.name = name
        self.Fragen = Fragen
    }
    
    
    //Benoetigter Konstruktor fuer das entpacken der Daten
    required init?(coder aDecoder: NSCoder){
        self.name = aDecoder.decodeObject(forKey:"name") as! String
        self.isSelected = aDecoder.decodeObject(forKey:"isSelected") as? Bool ?? false
        self.Fragen = aDecoder.decodeObject(forKey:"Fragen") as! [Fragekarte]
    }
    
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Fach(name: name, isSelected: isSelected)
        return copy
    }
    
    
    //Lade alle Fragekarten aus dem jeweiligen Fach aus der Tabelle "Fragekarte" herunter und ermittle davon die Anzahl.
    //Hilfsfunktion für Spiel.init(spieler : Spieler, gegner : Spieler, fach : Fach)
    func ermittleMaxID() -> Int{
        let projectQuery = PFQuery(className: "Fragekarte")
        projectQuery.includeKey("Fach")
        projectQuery.whereKey("Fach", equalTo: name)
        
        do{
            let results = try projectQuery.findObjects()
            return results.count
        }catch{}
        return 0
    }
    
    
    //Daten werden verpackt, um an den Server geschickt zu werden
    func encode(with aCoder: NSCoder){
        aCoder.encode(name, forKey: "name")
        aCoder.encode(isSelected, forKey: "isSelected")
        aCoder.encode(Fragen, forKey: "Fragen")
    }
    
    
    //Statische Funktion zum Vergleich der Strings, nicht ob die Objekte identisch sind
    public static func ==(lhs: Fach, rhs: Fach) -> Bool{
        if lhs.name == rhs.name { return true }
        return false
    }
}
