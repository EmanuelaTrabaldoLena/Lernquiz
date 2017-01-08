//
//  EinzelSpielerViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit

struct Question {
    var Question : String!
    var Answers : [String]!
    var Answer : Int!
}

class EinzelSpielerViewController: UIViewController {
    
    // Counter fuer Score, wird lokal gespeichert
    var Score: Int = 0
    
    // Sorgt dafür, dass der Score nicht hochgeht, wenn erst eine falsche Antwort ausgewählt wird
    var hasSelected = false;
    
    // Outlets fuer Buttons und Labels, die mit Storyboard verknuepft sind
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var FrageLabel: UILabel!
    @IBOutlet weak var AntwortAButton: UIButton!
    @IBOutlet weak var AntwortBButton: UIButton!
    @IBOutlet weak var AntwortCButton: UIButton!
    @IBOutlet var FrageBewerten: UIButton!
    @IBOutlet weak var NaechsteFrage: UIButton!
    
    var Questions = [Question]()
    var QNumber = Int()
    var AnswerNumber = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Questions = [Question(Question: "Welchen Dezimalwert hat 10011?", Answers: ["19", "23" ,"31" ], Answer: 0),
                     Question(Question: "Wieviel Bit haben IPv6-Adressen?", Answers: ["12", "6" ,"128" ], Answer: 2),
                     Question(Question: "Wieviele Schichten hat das ISO/OSI Modell?", Answers: ["4", "7" ,"6" ], Answer: 1),
                     Question(Question: "Wieviel Byte hat der IPv6 Header?", Answers: ["Beliebig viele", "32" ,"40" ], Answer: 2),
                     Question(Question: "Zu welcher Schicht gehört das Protokoll TCP?", Answers: ["Transportschicht", "Vermittlungsschicht" ,"Anwendungsschicht" ], Answer: 0)]
        
        //Sorgt dafuer, dass der Score beim Schließen der App nicht geloescht wird sondern lokal gespeichert (Muss aus irgendeinem Grund in der viewDidLoad Funktion stehen)
        let ScoreDefault = UserDefaults.standard
        
        if (ScoreDefault.value(forKey: "Score") != nil){
            Score = ScoreDefault.value(forKey: "Score") as! NSInteger!
            ScoreLabel.text = NSString(format: "Score : %i", Score) as String
        }
        
        PickQuestion()
    }
    
    
    //Weist den Buttons den Text zu und laedt die Fragen nacheinander rein bis keine mehr vorhanden sind
    func PickQuestion(){
        
        //Bei jeder neuen Frage werden die Farben der Antworten wieder auf weiß gesetzt und der Bool wieder auf false gesetzt bevor der erste Antwortbutton gedrückt wird
        
        hasSelected = false
        
        AntwortAButton.backgroundColor = UIColor.white
        AntwortBButton.backgroundColor = UIColor.white
        AntwortCButton.backgroundColor = UIColor.white
        
        if Questions.count > 0 {
            QNumber = 0
            FrageLabel.text = Questions[QNumber].Question
            
            AnswerNumber = Questions[QNumber].Answer
            
            AntwortAButton.setTitle(Questions[QNumber].Answers[0], for: UIControlState.normal)
            AntwortBButton.setTitle(Questions[QNumber].Answers[1], for: UIControlState.normal)
            AntwortCButton.setTitle(Questions[QNumber].Answers[2], for: UIControlState.normal)
            
            Questions.remove(at: QNumber)
        }
        else{
            NSLog("Keine weiteren Fragen")
        }
    }
    
    @IBAction func naechsteFrage(_ sender: Any) {
        PickQuestion()
    }
    
    //Hier werden die Hintergrundfarben der Antwortbutton je nach richtiger Antwort geändert und der Score erhöht, wenn die richtige Antwort zuerst gedrückt wird.
    
    @IBAction func AntwortA(_ sender: Any) {
        if AnswerNumber == 0 {
            if (hasSelected != true) {Score += 1
            ScoreLabel.text = NSString(format: "Score : %i", Score) as String
            let ScoreDefault = UserDefaults.standard
            ScoreDefault.set(Score, forKey: "Score")
            ScoreDefault.synchronize()
            }
            AntwortAButton.backgroundColor = UIColor.green
            hasSelected = true
        }else{
            AntwortAButton.backgroundColor = UIColor.red
            hasSelected = true
        }
    }
    
    @IBAction func AntwortB(_ sender: Any) {
        if AnswerNumber == 1 {
            if (hasSelected != true) {Score += 1
            ScoreLabel.text = NSString(format: "Score : %i", Score) as String
            let ScoreDefault = UserDefaults.standard
            ScoreDefault.set(Score, forKey: "Score")
            ScoreDefault.synchronize()
            }
            AntwortBButton.backgroundColor = UIColor.green
            hasSelected=true
        }else{
            AntwortBButton.backgroundColor = UIColor.red
            hasSelected = true
        }
    }
    
    @IBAction func AntwortC(_ sender: Any) {
        if AnswerNumber == 2 {
            if (hasSelected != true) { Score += 1;
            ScoreLabel.text = NSString(format: "Score : %i", Score) as String
            let ScoreDefault = UserDefaults.standard
            ScoreDefault.set(Score, forKey: "Score")
            ScoreDefault.synchronize()
            }
            
            AntwortCButton.backgroundColor = UIColor.green
            hasSelected=true
        }else{
            AntwortCButton.backgroundColor = UIColor.red
            hasSelected = true
        }
    }
    
    
    // var gewaehltesFach : Fach = Fach(Titel:"Medientechnik", DozentName: "Manninger", VorhandeneFragen: 0, Fragen: [])
    var gewaehltesFach = [Fach]()
    var vorhandeneFächer = [Fach]()
    
    // Frage bewerten (oder vllt nennen wir es eher Frage melden bzw schlechte Frage?): Auf dem Server muss gespeichert werden, wie oft er gedrückt wurde, bei 5 Mal von unterschiedlichen Usern wird die Frage aus dem System genommen
    
    
    // Gewaehlte Antwort
    var EineAntwort: Bool = true
    // Aktuelle Frage
    var CurrentQuestion: Int = 0
    
    //override func viewDidLoad() {
    //  super.viewDidLoad()
    // Folgender Code noch fehlerhaft, was genau soll er tun? Wie koennen wir das fixen?
    // self.FrageLabel.text = gewaehltesFach[0].Fragen[0].Fragentext
    // self.AntwortAButton.setTitle(gewaehltesFach[0].Fragen[0].AntwortA, for: .normal)
    // self.AntwortBButton.setTitle(gewaehltesFach[0].Fragen[0].AntwortB, for: .normal)
    // self.AntwortCButton.setTitle(gewaehltesFach[0].Fragen[0].AntwortC, for: .normal)
    
    
    // Beispielfragen erstellen und zu den Faechern hinzufuegen
}
