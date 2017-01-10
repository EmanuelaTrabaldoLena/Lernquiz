//
//  DuellViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit

class DuellViewController {
    
    // Schleife basteln, damit pro Runde 3 zufällige Fragen gestellt werden, für die jeweils ein Countdown von 60 Sekunden läuft
    
    // Wir brauchen eine Function, die die richtig beantworteten Frage in der Runde zusammenzählt
    // Alle 3 Fragen wurden beantwortet, jetzt muss man zur Übersicht mit den Spielständen gelangen
    
    // Timer gebastelt, der pro Frage 60 Sekunden runterzählt um die Frage zu beantworten
    
    var count: Int = 60
    
    // Wir brauchen einen Befehl, der bei einem Event (Drücken der Antwort, egal ob richtig oder falsch) den Timer abbricht.
    
     func viewDidLoad() {
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(DuellViewController.update), userInfo: nil, repeats: true)
        
        for _ in 0..<3
        {
            // -Function Frage beantworten wird durchlaufen
            // - Timer läuft von 60 Sekunden abwärts
            // - Wir brauchen eine Funktion, die die Frage als falsch auswertet, wenn der Timer abgelaufen ist
            
        }
    }
    
    @objc func update() {
        
        if(count > 0){
            
            _ = String(count % 60)
            //countDownLabel.text = seconds abh. machen von progress view (TimeD)
            count-=1
        }
        
    }
}
