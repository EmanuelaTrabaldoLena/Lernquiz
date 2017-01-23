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
    
    
    override init(){
    }
    
    init(spieler : Spieler, gegner : Spieler){
        self.spieler = spieler
        self.gegner = gegner
    }
    
    
    required init?(coder aDecoder: NSCoder){
        self.spieler = aDecoder.decodeObject(forKey:"spieler") as? Spieler ?? Spieler()
        self.gegner = aDecoder.decodeObject(forKey:"gegner") as? Spieler ?? Spieler()
    }
    
    
    //Daten werden verpackt, um an den Server geschickt zu werden
    func encode(with aCoder: NSCoder){
        aCoder.encode(spieler, forKey: "spieler")
        aCoder.encode(gegner, forKey: "gegner")
    }
    
    static func == (lhs : Spiel, rhs: Spiel) -> Bool
    {
        if lhs.spieler == rhs.spieler
        {
            if lhs.gegner == rhs.gegner
            {
                return true
            }
        }
        return false
    }
    
    
}
