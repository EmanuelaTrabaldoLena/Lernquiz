//
//  Fach.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import Foundation

class Fach{
    
    var name: String
    var isSelected: Bool = false
    var Fragen = [Fragekarte]()
    var VorhandeneFragen: Int = 0
    
    
    init(name : String)
    {
        self.name = name
    }
    
    init(name:String, VorhandeneFragen: Int, Fragen: [Fragekarte]) {
        self.name = name
        self.VorhandeneFragen = VorhandeneFragen
        self.Fragen = Fragen
    }
    
    
    func frageHinzufügen(Frage: Fragekarte){
        Fragen.append(Frage)
        VorhandeneFragen = VorhandeneFragen + 1
    }
    
    
    func frageLöschen(Frage: Fragekarte){
        var counting = 0
        while counting < Fragen.count{
            if Fragen[counting].FragenId ==  Frage.FragenId{
                Fragen.remove(at: counting)
                counting = counting + 1
            }
            else{
                counting = counting + 1
            }
            
        }
        
    }
}
