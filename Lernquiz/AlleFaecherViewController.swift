//
//  AlleFaecherViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit
import Parse

//Controller fuer die gesamte View von AlleFaecher
class AlleFaecherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var meineFaecherVC: MeineFaecherViewController!
    var gefilterterInhalt = [Fach]()
    
    @IBOutlet weak var alleFaecher: UITableView!
    @IBOutlet weak var faecherHinzufuegen: UIButton!

    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        alleFaecher.dataSource = self
        alleFaecher.delegate = self
    }
    
    
    //Ausgewaehlte Faecher werden gespeichert und man wird auf die MeineFaecherView weitergeleitet
    @IBAction func hinzufuegen(_ sender: Any){
        save(fachArray: gewaehlteVorlesungen)
        performSegue(withIdentifier: "AlleFaecher2MeineFaecher", sender: faecherHinzufuegen)
    }
    
    
    //Zeilen werden gezaehlt, Anzahl der Zeilen wird zurueckgegeben
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return vorlesungsverzeichnis.count
    }
    
    
    //Vorlesungsverzeichnis in einzelne Zellen geladen, Checkboxen anwaehlbar und TableView scrollbar
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //Ansonsten ganz normal die gesamte Liste
        if let fachCell = tableView.dequeueReusableCell(withIdentifier: "FachTableViewCell", for: indexPath) as? FachTableViewCell{
            
            let fach = vorlesungsverzeichnis[indexPath.row]
            fachCell.configure(fach: fach)
            //Falls bereits Faecher ausgewaehlt sind, werden die Checkboxen gefuellt
            fachCell.gewaehlt(cellFach: fach)
            return fachCell
        }else{
            return FachTableViewCell()
        }
    }
    
    
    //Gewaehlte Faecher werden in Parse hochgeladen und lokal im Systemspeicher abgelegt
    func save(fachArray: [Fach]){
        allgemein.gewaehlteVorlesungenLS = gewaehlteVorlesungen as NSObject?
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.saveContext()
        
        if let currentUser = PFUser.current(){
            currentUser ["MeineFaecher"] = NSMutableArray(object: NSKeyedArchiver.archivedData(withRootObject: gewaehlteVorlesungen))
            currentUser.saveInBackground()
                    do{
                        print("Versuche gewaehlteVorlesungen in User hochzuladen")
                        try currentUser.save()
                    }catch{
                        print("Fehler beim Hochladen!")
                    }
        }
    }
    
    
    //Um nur den Namen eines Facharrays auszugeben
    func getName(fach: [Fach]) -> [String]{
        var nameArray = [String]()
        for i in 0 ..< vorlesungsverzeichnis.count{
            nameArray.append(vorlesungsverzeichnis[i].name)
        }
        return nameArray
    }
}
