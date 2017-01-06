//
//  Frage.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import Foundation

class Frage{
    
    var FragenId : Int
    var Fragentext : String = ""
    var AntwortA : String = ""
    var AntwortB : String = ""
    var AntwortC : String = ""
    var RichtigeAntwort : String = ""
    
  
    init(FragenId: Int,Fragentext:String, AntwortA: String, AntwortB: String, AntwortC: String, RichtigeAntwort:String) {
        self.FragenId = FragenId
        self.Fragentext = Fragentext
        self.AntwortA = AntwortA
        self.AntwortB = AntwortB
        self.AntwortC = AntwortC
        self.RichtigeAntwort = RichtigeAntwort
    }
}
