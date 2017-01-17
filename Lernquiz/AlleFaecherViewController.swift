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
class AlleFaecherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var alleFaecher: UITableView!
    @IBAction func hinzufuegen(_ sender: Any) {
        save()
        _ = navigationController?.popViewController(animated: true)
    }
    
    // Array mit Vorlesungsverzeichnis
    var verzeichnis = ["Einführung in die Programmierung", "Digitale Medien", "Betriebssysteme", "Grundlagen der Analysis", "Softwaretechnik", "Datenbanksysteme", "Zeichnen und Skizzieren",  "Concept Development", "Softwareentwicklungspraktikum", "Systempraktikum", "Projektkompetenz Multimedia", "Lineare Algebra für Informatiker", "Statistik für Medieninformatiker", "Javakurs für Anfänger", "IT Sicherheit", "Mobilkommunikation", "Automatentheorie", "Codierungstheorie", "Mensch-Maschine-Interaktion", "Multimedia im Netz" ]
    
    var meineFaecherVC: MeineFaecherViewController!
    var searchController = UISearchController()
    var gefilterterInhalt = [String]()
    
    override func viewDidLoad() {
        alleFaecher.dataSource = self
        alleFaecher.delegate = self
        
        super.viewDidLoad()
        
        tableFuellen()
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.alleFaecher.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.placeholder = "Welches Fach suchst du?"
        self.alleFaecher.reloadData()
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "meineFaecherVC" {
            meineFaecherVC = segue.destination as! MeineFaecherViewController
        }
    }
    
    
    // Zeilen der TableView mit dem Vorlesungsverzeichnis fuellen
    func tableFuellen() {
        // Ueber die Laenge des Arrays iterieren und die Namen des Verzeichnisses in den einzelnen Zellen einfuegen
        for i in 0 ..< verzeichnis.count {
            
            let fach = Fach(name: verzeichnis[i])
            vorlesungsverzeichnis.add(fach)
        }
    }
    
    
    // Zeilen werden gezaehlt, Anzahl der Zeilen wird zurueckgegeben
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive {
            return self.gefilterterInhalt.count
        } else {
            return vorlesungsverzeichnis.count
        }
    }
    
    
    // Vorlesungsverzeichnis in einzelne Zellen geladen, Checkboxen anwaehlbar und TableView scrollbar
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ansonsten ganz normal die gesamte Liste
        if let fachCell = tableView.dequeueReusableCell(withIdentifier: "FachTableViewCell", for: indexPath) as? FachTableViewCell {
            
            let fach = vorlesungsverzeichnis[indexPath.row] as! Fach
            // Falls bereits Faecher ausgewaehlt sind, werden die Checkboxen gefuellt
            fachCell.gewaehlt(gewaehltesFach: gewaehlteVorlesungen)
            fachCell.configure(fach: fach)

            // Falls man in der Searchbar ist, wird nur der gefilterte Inhalt angezeigt
            if self.searchController.isActive {
                fachCell.textLabel!.text = self.gefilterterInhalt[indexPath.row]
                fachCell.gewaehlt(gewaehltesFach: gewaehlteVorlesungen)
                fachCell.configure(fach: fach)
                return fachCell
            }
            
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
    
    
    // Sobald die Searchbar angewaehlt wird, leert sich die TableView und nur noch Ergebnisse, die mit geschriebenen Text teilweise uebereinstimmen, werden angezeigt
    func updateSearchResults(for searchController: UISearchController) {
        self.gefilterterInhalt.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.verzeichnis as NSArray).filtered(using: searchPredicate)
        self.gefilterterInhalt = array as! [String]
        self.alleFaecher.reloadData()
    }
    
}
