//
//  UserTableViewController.swift
//  Lernquiz
//
//  Created by Lisa Lohner on 12.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit
import Parse

class NeuesSpielMenüViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var usernames = [String]()
    
    @IBOutlet weak var spielerSuchen: UITableView!{
        didSet {
            spielerSuchen.dataSource = self
            spielerSuchen.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                print(error!)
            }
            else if let users = objects {
                for object in users {
                    if let user = object as? PFUser{
                        self.usernames.append(user.username!)
                    }
                }
            }
            self.spielerSuchen.reloadData()
        })

    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return usernames.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        cell.textLabel?.text = usernames[indexPath.row]

        return cell
    }
    
    // Fragekarte wird im Server hochgeladen, wird ausgefuehrt wenn frageErstellenButton ausgewaehlt wird
    func upload(spiel: Spiel)
    {
        let hochzuladendesObjekt = PFObject(className: "Spiele")
        hochzuladendesObjekt["Spiel"] = NSMutableArray(object: NSKeyedArchiver.archivedData(withRootObject: spiel))
        do {
            try hochzuladendesObjekt.save()
        } catch {
            print("Fehler beim Upload der Spieldateien!")
        }
    }
    
    // Beim Auswaehlen eines Fachs aus der TableView wird man direkt zum Menue weitergeleitet
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        
        //let duellSpielstandVC = self.storyboard?.instantiateViewController(withIdentifier: "DuellSpielstand") as! DuellSpielstandViewController
        
        // Label Gegenspieler in DuellSpielstandView wird auf gewaehlten Mitspieler aus der TableView gesetzt
        
        let mitSpieler = Spieler(username: usernames[row], istDran: false)
        
        print("Gewaehlter Gegenspieler: \(mitSpieler.username)")
        
        
        performSegue(withIdentifier: "NeuesSpielMenüVC2DuellSpielstandVC", sender: mitSpieler)
        
        //self.navigationController?.pushViewController(duellSpielstandVC, animated: true)
    }
    
    
    // Beim Viewwechsel werden die
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "NeuesSpielMenüVC2DuellSpielstandVC"
        {
            let destination = segue.destination as! DuellSpielstandViewController
            let spiel = Spiel(spieler: Spieler(username: "Du", istDran: true), gegner: sender as! Spieler)
            destination.spiel = spiel
            upload(spiel: spiel)
        }
    }
    
}
