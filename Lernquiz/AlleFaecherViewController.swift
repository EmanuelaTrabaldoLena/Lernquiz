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
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        alleFaecher.dataSource = self
        alleFaecher.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        alleFaecher.reloadData()
    }
    
    
    
    //Ausgewaehlte Faecher werden gespeichert und man wird auf die MeineFaecherView weitergeleitet
    @IBAction func hinzufuegen(_ sender: Any){
        upload(fachArray: gewaehlteVorlesungen)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    //Zeilen werden gezaehlt, Anzahl der Zeilen wird zurueckgegeben
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return vorlesungsverzeichnis.count
    }
    
    
    //Vorlesungsverzeichnis in einzelne Zellen geladen, Checkboxen anwaehlbar und TableView scrollbar
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //Ansonsten ganz normal die gesamte Liste
        if let fachCell = tableView.dequeueReusableCell(withIdentifier: "FachTableViewCell", for: indexPath) as? FachTableViewCell
        {
            let fach = vorlesungsverzeichnis[indexPath.row]
            fachCell.configure(fach: fach)
            return fachCell
        }else{
            return FachTableViewCell()
        }
    }
    
    func upload(fachArray: [Fach])
    {
        if let currentUser = PFUser.current()
        {
            currentUser["MeineFaecher"] = NSMutableArray(object: NSKeyedArchiver.archivedData(withRootObject: fachArray))
            do {
                print("Versuche gewaehlteVorlesungen in User hochzuladen")
                try currentUser.save()
            } catch {
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
