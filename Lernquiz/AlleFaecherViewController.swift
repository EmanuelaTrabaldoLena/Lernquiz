//
//  AlleFaecherViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit

class AlleFaecherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var alleFaecher: UITableView!
    @IBAction func hinzufuegen(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // Erweiterbares Array vom Vorlesungsverzeichnis
    let vorlesungsverzeichnis = NSMutableArray()
    
    
    override func viewDidLoad() {
        alleFaecher.dataSource = self
        alleFaecher.delegate = self
        
        super.viewDidLoad()
        
        tableFuellen()
    }
    
    
    // Zeilen der TableView mit dem Vorlesungsverzeichnis fuellen
    func tableFuellen() {
        
        // Array mit Vorlesungsverzeichnis
        let verzeichnis = ["Einführung in die Programmierung", "Digitale Medien", "Betriebssysteme", "Grundlagen der Analysis", "Softwaretechnik", "Datenbanksysteme", "Zeichnen und Skizzieren",  "Concept Development", "Softwareentwicklungspraktikum", "Systempraktikum", "Projektkompetenz Multimedia", "Lineare Algebra für Informatiker", "Statistik für Medieninformatiker", "Javakurs für Anfänger", "IT Sicherheit", "Mobilkommunikation", "Automatentheorie", "Codierungstheorie", "Mensch-Maschine-Interaktion", "Multimedia im Netz" ]
        
        // Ueber die Laenge des Arrays iterieren und die Namen des Verzeichnisses in den einzelnen Zellen einfuegen
        for i in 0 ..< verzeichnis.count {
            
            let fach = Faecher()
            fach.name = verzeichnis[i]
            
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
            
            let fach = vorlesungsverzeichnis[indexPath.row] as! Faecher
            fachCell.configure(fach: fach)
            
            return fachCell
            
        } else {
            
            return FachTableViewCell()
            
        }
    }
    
    
    // Alle ausgewaehlten Faecher in ein Array speichern
    func saveSelectedItems(fach :Faecher) -> NSMutableArray{
        let gewaehlteFaecher = NSMutableArray()
        
        for index in 0 ..< vorlesungsverzeichnis.count {
            
            if (fach.isSelected == true) {
                gewaehlteFaecher.add(vorlesungsverzeichnis[index])
            }
        }
        print(gewaehlteFaecher)
        return gewaehlteFaecher
    }
    
    
    // Ausgewaehlte Zeile in Console ausgeben
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as! FachTableViewCell
        print((currentCell.name?.text)! as String)
    }
}
