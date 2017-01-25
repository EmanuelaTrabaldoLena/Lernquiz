//
//  Spiel.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 16.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import Foundation

class Spiel : NSObject, NSCoding {
    
    var spieler = Spieler()
    var gegner = Spieler()
    var fachName = String()
    var fragenKartenID = [Int]()
    
    
    override init(){
    }
    
    
    //Initialisiere ein Spiel mit einem Gegner und sich selbst, wobei gleichzeitig 3 gleiche Fragen ausgewaehlt werden.
    init(spieler : Spieler, gegner : Spieler, fach : Fach)
    {
        self.spieler = spieler
        self.gegner = gegner
        self.fachName = fach.name
        
        
        let maxID4Fach =  fach.ermittleMaxID()
        
        
        let zufaelligeID1 = Int(arc4random_uniform(UInt32(maxID4Fach)))
        let zufaelligeID2 = Int(arc4random_uniform(UInt32(maxID4Fach)))
        let zufaelligeID3 = Int(arc4random_uniform(UInt32(maxID4Fach)))
        
        fragenKartenID = [zufaelligeID1, zufaelligeID2, zufaelligeID3]
    }
    
    
    
    required init?(coder aDecoder: NSCoder){
        self.spieler = aDecoder.decodeObject(forKey:"spieler") as? Spieler ?? Spieler()
        self.gegner = aDecoder.decodeObject(forKey:"gegner") as? Spieler ?? Spieler()
        self.fachName = aDecoder.decodeObject(forKey: "fachName") as? String ?? ""
        self.fragenKartenID = aDecoder.decodeObject(forKey: "fragenKartenID") as! [Int]
    }
    
    
    //Daten werden verpackt, um an den Server geschickt zu werden
    func encode(with aCoder: NSCoder){
        aCoder.encode(spieler, forKey: "spieler")
        aCoder.encode(gegner, forKey: "gegner")
        aCoder.encode(fachName, forKey: "fachName")
        aCoder.encode(fragenKartenID, forKey: "fragenKartenID")

        
    }
    
    static func == (lhs : Spiel, rhs: Spiel) -> Bool
    {
        if lhs.spieler == rhs.spieler
        {
            if lhs.gegner == rhs.gegner
            {
                if lhs.fachName == rhs.fachName
                {
                    return true
                }
            }
        }
        return false
    }
    
    
}
