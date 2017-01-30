//
//  Spieler.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 16.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import Foundation

class Spieler : NSObject, NSCoding {
    
    var username : String
    var runden : [[Bool?]] = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil], [nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
    var istDranString = "false"
    var rundeBeendetString = "false"
    
    
    init(username: String, runden: [[Bool]], istDran : Bool){
        self.username = username
        self.runden = runden
        super.init()
        setIstDran(istDran)
    }
    
    
    init(username: String, istDran : Bool){
        self.username = username
        super.init()
        setIstDran(istDran)
    }
    
    
    //Leerer Konstruktor, der den Usernamen leer setzt
    override init(){
        self.username = ""
    }
    
    
    //Benoetigter Konstruktor fuer das entpacken der Daten
    required init?(coder aDecoder: NSCoder){
        self.username = aDecoder.decodeObject(forKey:"username") as? String ?? ""
        self.istDranString = aDecoder.decodeObject(forKey:"istDranString") as! String
        self.rundeBeendetString = aDecoder.decodeObject(forKey:"rundeBeendetString") as! String
        
        //Der Decoder hat Probleme mit Swift Datenstrukturen, weswegen hier in Obj-C Datenstrukturen umgecastet wird.
        let objC_runden = aDecoder.decodeObject(forKey:"runden") as! NSMutableArray
        self.runden = [objC_runden[0] as! [Bool?], objC_runden[1] as! [Bool?], objC_runden[2] as! [Bool?], objC_runden[3] as! [Bool?], objC_runden[4] as! [Bool?], objC_runden[5] as! [Bool?]]
    }
    
    
    //Gibt den Wert zurück, ob der Spieler dran ist
    func getIstDran() -> Bool{
        if istDranString == "true" { return true }
        return false
    }
    
    
    //Setzt den Wert, falls der Spieler dran ist
    func setIstDran(_ istDran : Bool){
        if istDran == true{
            self.istDranString = "true"
        } else if istDran == false {
            self.istDranString = "false"
        }
    }
    
    
    //Gibt den Wert für eine beendete Runde zurück
    func getRundeBeendet() -> Bool{
        if rundeBeendetString == "true" { return true }
        return false
    }
    
    
    //Setzt den Wert einer beendeten Runde
    func setRundeBeendet(_ rundeBeendet : Bool){
        if rundeBeendet == true{
            self.rundeBeendetString = "true"
        } else if rundeBeendet == false {
            self.rundeBeendetString = "false"
        }
    }
    
    
    //Daten werden verpackt, um an den Server geschickt zu werden
    func encode(with aCoder: NSCoder){
        aCoder.encode(username, forKey: "username")
        aCoder.encode(istDranString, forKey: "istDranString")
        aCoder.encode(rundeBeendetString, forKey: "rundeBeendetString")
        
        //Der Decoder hat Probleme mit Swift Datenstrukturen, weswegen hier in Obj-C Datenstrukturen umgecastet wird.
        aCoder.encode(NSMutableArray(array: runden), forKey: "runden")
    }
    
    
    //Statische Funktion zum Vergleich der Strings, nicht ob die Objekte identisch sind
    static func == (lhs : Spieler, rhs : Spieler) -> Bool{
        if (lhs.username == rhs.username){
            return true
        }
        return false
    }
    
}
