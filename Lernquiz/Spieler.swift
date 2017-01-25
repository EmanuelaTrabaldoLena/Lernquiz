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
    var istDranString : String = "false"
    var runden : [[Bool?]] = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil], [nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
    var istDran : Bool = false
        {
        didSet
        {
            if istDran == true {istDranString = "true"}
            if istDran == false {istDranString = "false"}
        }
    }
    
    init(username: String, runden: [[Bool]], istDran : Bool){
        self.username = username
        self.runden = runden
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
        self.istDranString = aDecoder.decodeObject(forKey:"istDranString") as? String ?? "ein fehler ist aufgetreten"
        
        //Der Decoder hat Probleme mit Swift Datenstrukturen, weswegen hier in Obj-C Datenstrukturen umgecastet wird.
        let objC_runden = aDecoder.decodeObject(forKey:"runden") as! NSMutableArray
        self.runden = [objC_runden[0] as! [Bool?], objC_runden[1] as! [Bool?], objC_runden[2] as! [Bool?], objC_runden[3] as! [Bool?], objC_runden[4] as! [Bool?], objC_runden[5] as! [Bool?]]
        
        
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
        aCoder.encode(istDranString, forKey: "istDranString")
        
        //Der Decoder hat Probleme mit Swift Datenstrukturen, weswegen hier in Obj-C Datenstrukturen umgecastet wird.
        aCoder.encode(NSMutableArray(array: runden), forKey: "runden")
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
