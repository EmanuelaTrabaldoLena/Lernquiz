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
    
    var meineFaecherVC: MeineFaecherViewController!
    var searchController = UISearchController()
    var gefilterterInhalt = [String]()
    
    @IBOutlet weak var alleFaecher: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alleFaecher.dataSource = self
        alleFaecher.delegate = self
        
        tableFuellen()
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.alleFaecher.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.placeholder = "Welches Fach suchst du?"
        self.alleFaecher.reloadData()
    }
    
    
    //
    @IBAction func hinzufuegen(_ sender: Any) {
        save()
        _ = navigationController?.popViewController(animated: true)
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
        for i in verzeichnis {
            vorlesungsverzeichnis.append(Fach(name: i))
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
            
            let fach = vorlesungsverzeichnis[indexPath.row]
            fachCell.configure(fach: fach)
            // Falls bereits Faecher ausgewaehlt sind, werden die Checkboxen gefuellt
            fachCell.gewaehlt(cellFach: fach)

            // Falls man in der Searchbar ist, wird nur der gefilterte Inhalt angezeigt
            if self.searchController.isActive {
                for i in 0 ..< gewaehlteVorlesungen.count {
                    fachCell.textLabel!.text = self.gefilterterInhalt[indexPath.row]
                    fachCell.gewaehlt(cellFach: gewaehlteVorlesungen[i])
                    fachCell.configure(fach: fach)
                    return fachCell
                }
            }
            
            return fachCell
            
        } else {
            return FachTableViewCell()
        }
    }
    
    // Gewaehlte Faecher werden in Parse hochgeladen und lokal im Systemspeicher abgelegt
    func save() {
        allgemein.gewaehlteVorlesungenLS = gewaehlteVorlesungen as NSObject?
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.saveContext()
        
        
        let userTable = PFObject(className: "User")
        userTable ["MeineFaecher"] = NSMutableArray(object: NSKeyedArchiver.archivedData(withRootObject: gewaehlteVorlesungen))
        userTable.saveInBackground()
        do {
            print("Versuche gewaehlteVorlesungen in User hochzuladen")
            try userTable.save()
        } catch {
            print("Fehler beim Hochladen!")
        }
    }
    
    
    // Sobald die Searchbar angewaehlt wird, leert sich die TableView und nur noch Ergebnisse, die mit geschriebenen Text teilweise uebereinstimmen, werden angezeigt
    func updateSearchResults(for searchController: UISearchController) {
        self.gefilterterInhalt.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (gewaehlteVorlesungen as NSArray).filtered(using: searchPredicate)
        self.gefilterterInhalt = array as! [String]
        self.alleFaecher.reloadData()
    }
    
}
