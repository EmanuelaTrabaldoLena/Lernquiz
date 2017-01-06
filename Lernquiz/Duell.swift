//
//  Duell.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import Foundation

class Duell{
    
    var Spieler1: String {
        get {
            return self.Spieler1
        }
        
        set {
            return self.Spieler1 = newValue
        }
    }
    
    var Spieler2: String {
        get {
            return self.Spieler2
        }
        
        set {
            return self.Spieler2 = newValue
        }
    }
    
    var DuellId: String {
        get {
            return self.DuellId
        }
        
        set {
            return self.DuellId = Spieler2
        }
    }
    
    //var Punktestand :Dictionary = [Int: String]
    
    init(Spieler1: String, Spieler2: String) {
        self.Spieler1 = Spieler1
        self.Spieler2 = Spieler2
        self.DuellId = Spieler2
    }
}

