//
//  AlleFaecherViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit
import Parse

// Controller fuer die gesamte View von AlleFaecher
class AlleFaecherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var alleFaecher: UITableView!
    @IBAction func hinzufuegen(_ sender: Any) {
        save()
        _ = navigationController?.popViewController(animated: true)
    }

    var meineFaecherVC: MeineFaecherViewController!
    
    
    override func viewDidLoad() {
        alleFaecher.dataSource = self
        alleFaecher.delegate = self
        
        super.viewDidLoad()
        
        tableFuellen()
        
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "meineFaecherVC" {
            meineFaecherVC = segue.destination as! MeineFaecherViewController
        }
    }
    
    
    // Zeilen der TableView mit dem Vorlesungsverzeichnis fuellen
    func tableFuellen() {
        
        // Array mit Vorlesungsverzeichnis
        let verzeichnis = ["Einführung in die Programmierung", "Digitale Medien", "Betriebssysteme", "Grundlagen der Analysis", "Softwaretechnik", "Datenbanksysteme", "Zeichnen und Skizzieren",  "Concept Development", "Softwareentwicklungspraktikum", "Systempraktikum", "Projektkompetenz Multimedia", "Lineare Algebra für Informatiker", "Statistik für Medieninformatiker", "Javakurs für Anfänger", "IT Sicherheit", "Mobilkommunikation", "Automatentheorie", "Codierungstheorie", "Mensch-Maschine-Interaktion", "Multimedia im Netz" ]
        
        // Ueber die Laenge des Arrays iterieren und die Namen des Verzeichnisses in den einzelnen Zellen einfuegen
        for i in 0 ..< verzeichnis.count {
            
            let fach = Fach(name: verzeichnis[i])
            
            vorlesungsverzeichnis.add(fach)
        }
    }
    
    
    // Zeilen werden gezaehlt, Anzahl der Zeilen wird zurueckgegeben
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vorlesungsverzeichnis.count
    }
    
    
    // Vorlesungsverzeichnis in einzelne Zellen geladen, Checkboxen anwaehlbar und TableView scrollbar
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let fachCell = tableView.dequeueReusableCell(withIdentifier: "FachTableViewCell", for: indexPath) as? FachTableViewCell {
            
            let fach = vorlesungsverzeichnis[indexPath.row] as! Fach
            // Falls bereits Faecher ausgewaehlt sind, werden die Checkboxen gefuellt
            
            fachCell.gewaehlt(gewaehltesFach: gewaehlteVorlesungen)
            fachCell.configure(fach: fach)
            
            return fachCell
            
        } else {
            
            return FachTableViewCell()
            
        }
    }
    
    // Gewaehlte Faecher werden in Parse hochgeladen und lokal im Systemspeicher abgelegt
    func save() {
        
        let meineFaecherDefault = UserDefaults.standard
        meineFaecherDefault.set(gewaehlteFaecher, forKey: "gewaehlteFaecher")
        meineFaecherDefault.synchronize()
        
        
        let userTable = PFObject(className: "User")
        userTable ["MeineFaecher"] = gewaehlteFaecher
        userTable.saveInBackground()
        do {
            try userTable.save()
        } catch {
            print("Fehler beim Hochladen!")
        }
        
    }
    
}
