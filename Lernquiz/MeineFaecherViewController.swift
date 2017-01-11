//
//  ViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit

var gewaehlteFaecher = [String]()

// Erweiterbares Array vom Vorlesungsverzeichnis
let gewaehlteVorlesungen = NSMutableArray()

// Controller fuer die gesamte View MeineFaecher
class MeineFaecherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBAction func hinzufuegen(_ sender: UIButton) {
        performSegue(withIdentifier: "MeineFaecher2AlleFaecher", sender: nil)
    }
    
    @IBOutlet weak var meineFaecher: UITableView! {
        didSet {
            meineFaecher.dataSource = self
            meineFaecher.delegate = self
        }
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableFuellen()
        
        meineFaecher.dataSource = self
        meineFaecher.delegate = self
        meineFaecher.register(GewaehltesFachTableViewCell.self, forCellReuseIdentifier: "GewaehltesFachTableViewCell")
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        meineFaecher.reloadData()
    }
    
    
    // Zeilen der TableView mit dem Array der gewaehlten Vorlesungen fuellen
    func tableFuellen() {
        
        // Ueber die Laenge des Arrays iterieren und die Namen der Vorlesungen in den einzelnen Zellen einfuegen
        for i in 0 ..< gewaehlteFaecher.count {
            
            let fach = Fach()
            fach.name = gewaehlteFaecher[i]
            
            gewaehlteVorlesungen.add(fach)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gewaehlteFaecher.count
    }
    
    // Gewaehlte Faecher in einzelne Zellen geladen und TableView scrollbar
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let fachCell = meineFaecher.dequeueReusableCell(withIdentifier: "GewaehltesFachTableViewCell", for: indexPath) as? GewaehltesFachTableViewCell {

            fachCell.textLabel?.text = gewaehlteFaecher[indexPath.item]
            
            return fachCell
            
        } else {
            
            return GewaehltesFachTableViewCell()
            
        }
    }
}
