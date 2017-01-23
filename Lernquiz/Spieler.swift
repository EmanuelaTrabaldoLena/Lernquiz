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
    var istDran : Bool = false
    {
        didSet
        {
            if istDran == true {istDranString = "true"}
            if istDran == false {istDranString = "false"}
        }
    }
    var istDranString : String = "false"
    var einzelrunde : [Bool?]? = [nil, nil, nil]
    
    init(username: String, runden: Int, einzelrunde: [Bool], istDran : Bool){
        self.username = username
        self.runden = runden
        self.einzelrunde = einzelrunde
        self.istDran = istDran
        if self.istDran == true
        {
            self.istDranString = "true"
        } else {
            self.istDranString = "false"
        }
    }
    
    init(username: String, istDran : Bool){
        self.username = username
        self.istDran = istDran
        if self.istDran == true
        {
            self.istDranString = "true"
        } else {
            self.istDranString = "false"
        }
    }
    
    override init(){
        self.username = ""
        self.istDran = false
    }
    
    required init?(coder aDecoder: NSCoder){
        self.username = aDecoder.decodeObject(forKey:"username") as? String ?? ""
        self.runden = aDecoder.decodeObject(forKey:"runden") as? Int ?? 0
        self.istDranString = aDecoder.decodeObject(forKey:"istDranString") as? String ?? "ein fehler ist aufgetreten"
        self.einzelrunde = aDecoder.decodeObject(forKey:"einzelrunde") as? [Bool?]? ??  [nil, nil, nil]
        if self.istDranString == "true"
        {
            self.istDran = true
        } else if self.istDranString == "false" {
            self.istDran = false
        }
    }

    
    //Daten werden verpackt, um an den Server geschickt zu werden
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: "username")
        aCoder.encode(runden, forKey: "runden")
        aCoder.encode(istDranString, forKey: "istDranString")
        aCoder.encode(einzelrunde, forKey: "einzelrunde")
    }
    
     static func == (lhs : Spieler, rhs : Spieler) -> Bool
    {
        if (lhs.username == rhs.username)
        {
            return true
        }
        return false
    }
    
}
