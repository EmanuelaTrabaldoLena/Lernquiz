//
//  EinzelSpielerViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit

class EinzelSpielerViewController: UIViewController {
    // Outlets fuer Buttons und Labels, die mit Storyboard verknuepft sind
    @IBOutlet weak var HighscoreLabel: UILabel!
    @IBOutlet weak var FrageLabel: UILabel!
    @IBOutlet weak var AntwortAButton: UIButton!
    @IBOutlet weak var AntwortBButton: UIButton!
    @IBOutlet weak var AntwortCButton: UIButton!
    
    // var gewaehltesFach : Fach = Fach(Titel:"Medientechnik", DozentName: "Manninger", VorhandeneFragen: 0, Fragen: [])
    var gewaehltesFach = [Fach]()
    var vorhandeneFächer = [Fach]()
    
    // Counter fuer Highscore, wird lokal gespeichert
    var Highscore: Int = 0
    
    // Gewaehlte Antwort
    var EineAntwort: Bool = true
    // Aktuelle Frage
    var CurrentQuestion: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Folgender Code noch fehlerhaft, was genau soll er tun? Wie koennen wir das fixen?
        // self.FrageLabel.text = gewaehltesFach[0].Fragen[0].Fragentext
        // self.AntwortAButton.setTitle(gewaehltesFach[0].Fragen[0].AntwortA, for: .normal)
        // self.AntwortBButton.setTitle(gewaehltesFach[0].Fragen[0].AntwortB, for: .normal)
        // self.AntwortCButton.setTitle(gewaehltesFach[0].Fragen[0].AntwortC, for: .normal)
    }
    
    // Beispielfragen erstellen und zu den Faechern hinzufuegen
}
