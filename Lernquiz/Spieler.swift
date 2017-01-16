//
//  Spieler.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 16.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import Foundation

class Spieler {
    
    var username : String
    var runden = [Bool]()
    var einzelrunde = [Bool]()
    
    init(username: String, runden: [Bool], einzelrunde: [Bool]) {
        self.username = username
        self.runden = runden
        self.einzelrunde = einzelrunde
    }
    
    init(username: String)
    {
        self.username = username
    }
    
    init()
    {
        self.username = ""
    }
    
}
