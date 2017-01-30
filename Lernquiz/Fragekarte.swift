//
//  Frage.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import Foundation

class Fragekarte : NSObject, NSCoding{
    
    var FragenId : Int = 0
    var Fragentext : String = ""
    var AntwortA : String = ""
    var AntwortB : String = ""
    var AntwortC : String = ""
    var RichtigeAntwort : String = ""
    var RichtigeAntwortIndex : NSNumber = 0
    var fachName = String()
    private var frageGemeldetString : String = "0"
    
    
    func toString () -> String{
        return "Fragentext: \(Fragentext)  |  AntwortA: \(AntwortA) | AntwortB: \(AntwortB) | AntwortC: \(AntwortC)"
    }
    
    //Der Index wird anhand der richtigen Antwort ermittelt
    func ermittleRichtigeAntwortIndex(){
        let array = [AntwortA, AntwortB, AntwortC]
        loop: for (index, element) in array.enumerated(){
            if element == RichtigeAntwort{
                RichtigeAntwortIndex = NSNumber(value: index)
                break loop
            }
        }
    }
    

    //Antwortmoeglichkeiten werden vertauscht/ neu angeordnet (Algorithmus nicht sehr schoen)
    func swap(){
        let iniArray = [AntwortA, AntwortB, AntwortC]
        var array = [AntwortA, AntwortB, AntwortC]
        var array2 : [Int] = [10]
        var i = 0
        
        loop1: while i < 3 {
            i = i + 1

            let randomNumber = Int(arc4random_uniform(3))

            for element in array2 {
                if (element == randomNumber){
                    i = i - 1
                    continue loop1
                }
            }
            array[randomNumber] = iniArray[i-1]
            array2.append(randomNumber)
        }
        AntwortA = array[0]
        AntwortB = array[1]
        AntwortC = array[2]
    }
  
    override init(){
        
    }
    
    
    //Standard Initializer
    init(FragenId: Int,Fragentext:String, AntwortA: String, AntwortB: String, AntwortC: String, RichtigeAntwort:String, frageGemeldet: Int)
    {
        self.FragenId = FragenId
        self.Fragentext = Fragentext
        self.AntwortA = AntwortA
        self.AntwortB = AntwortB
        self.AntwortC = AntwortC
        self.RichtigeAntwort = RichtigeAntwort
        super.init()
        self.setFrageGemeldet(anzahl: frageGemeldet)
    }
    
    //Die folgenden 2 Methoden sind wichtig um die Daten in Parse zu speichern
    //Daten, die bereits vom Server gezogen wurden, werden ausgepackt
    required init?(coder aDecoder: NSCoder){
        self.FragenId = aDecoder.decodeObject(forKey:"FragenId") as? Int ?? 0
        self.Fragentext = aDecoder.decodeObject(forKey:"Fragentext") as? String ?? ""
        self.AntwortA = aDecoder.decodeObject(forKey:"AntwortA") as? String ?? ""
        self.AntwortB = aDecoder.decodeObject(forKey:"AntwortB") as? String ?? ""
        self.AntwortC = aDecoder.decodeObject(forKey:"AntwortC") as? String ?? ""
        self.RichtigeAntwort = aDecoder.decodeObject(forKey:"RichtigeAntwort") as? String ?? ""
        self.RichtigeAntwortIndex = aDecoder.decodeObject(forKey:"RichtigeAntwortIndex") as? NSNumber ?? 11
        self.fachName = aDecoder.decodeObject(forKey: "fachName") as? String ?? ""
        self.frageGemeldetString = aDecoder.decodeObject(forKey:"frageGemeldet") as? String ?? String()
    }
    
    //Daten werden verpackt, um an den Server geschickt zu werden
    func encode(with aCoder: NSCoder){
        aCoder.encode(FragenId, forKey: "FragenId")
        aCoder.encode(Fragentext, forKey: "Fragentext")
        aCoder.encode(AntwortA, forKey: "AntwortA")
        aCoder.encode(AntwortB, forKey: "AntwortB")
        aCoder.encode(AntwortC, forKey: "AntwortC")
        aCoder.encode(RichtigeAntwort, forKey: "RichtigeAntwort")
        aCoder.encode(RichtigeAntwortIndex, forKey: "RichtigeAntwortIndex")
        aCoder.encode(fachName, forKey : "fachName")
        aCoder.encode(frageGemeldetString, forKey: "frageGemeldet")
    }
    
    
    func getFrageGemeldet() -> Int
    {
        return Int(frageGemeldetString)!
    }
    
    func setFrageGemeldet(anzahl : Int)
    {
        frageGemeldetString = String(anzahl)
    }
    
    
    
    //Schwaecherer Initializierer, der einen Parameter weniger hat
    convenience init(FragenId: Int,Fragentext:String, AntwortA: String, AntwortB: String, AntwortC: String, frageGemeldet: Int){
        self.init(FragenId: FragenId, Fragentext: Fragentext, AntwortA: AntwortA, AntwortB: AntwortB, AntwortC: AntwortC, RichtigeAntwort: AntwortA, frageGemeldet: frageGemeldet)
    }
    
    static func == (lhs : Fragekarte, rhs : Fragekarte) -> Bool
    {
        if (lhs.Fragentext == rhs.Fragentext)
        {
            return true
        }
        return false
    }

}
