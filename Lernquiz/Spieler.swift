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
    var runden : Int = 0
    var istDran : Bool
    var einzelrunde : [Bool?]? = [nil, nil, nil]
    
    init(username: String, runden: Int, einzelrunde: [Bool], istDran : Bool) {
        self.username = username
        self.runden = runden
        self.einzelrunde = einzelrunde
        self.istDran = istDran
    }
    
    init(username: String, istDran : Bool)
    {
        self.username = username
        self.istDran = istDran
    }
    
    override init()
    {
        self.username = ""
        self.istDran = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.username = aDecoder.decodeObject(forKey:"username") as? String ?? ""
        self.runden = aDecoder.decodeObject(forKey:"runden") as? Int ?? 0
        self.istDran = aDecoder.decodeObject(forKey:"istDran") as? Bool ?? false
        self.einzelrunde = aDecoder.decodeObject(forKey:"einzelrunde") as? [Bool?]? ??  [nil, nil, nil]
    }
    
    // Daten werden verpackt, um an den Server geschickt zu werden
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: "username")
        aCoder.encode(runden, forKey: "runden")
        aCoder.encode(istDran, forKey: "istDran")
        aCoder.encode(einzelrunde, forKey: "einzelrunde")
    }
    
}
