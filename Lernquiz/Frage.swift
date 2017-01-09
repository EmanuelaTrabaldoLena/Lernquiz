//
//  Frage.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import Foundation

class Frage{
    
    var FragenId : Int = 0
    var Fragentext : String = ""
    var AntwortA : String = ""
    var AntwortB : String = ""
    var AntwortC : String = ""
    var RichtigeAntwort : String = ""
    
    
    func toString () -> String {
        return "Fragentext: \(Fragentext)  |  AntwortA: \(AntwortA) | AntwortB: \(AntwortB) | AntwortC: \(AntwortC)"
    }
  
    init()
    {
        
    }
    
    init(FragenId: Int,Fragentext:String, AntwortA: String, AntwortB: String, AntwortC: String, RichtigeAntwort:String) {
        self.FragenId = FragenId
        self.Fragentext = Fragentext
        self.AntwortA = AntwortA
        self.AntwortB = AntwortB
        self.AntwortC = AntwortC
        self.RichtigeAntwort = RichtigeAntwort
    }
    
    convenience init(FragenId: Int,Fragentext:String, AntwortA: String, AntwortB: String, AntwortC: String) {
        self.init(FragenId: FragenId, Fragentext: Fragentext, AntwortA: AntwortA, AntwortB: AntwortB, AntwortC: AntwortC, RichtigeAntwort: AntwortA)
    }

    
    
}
