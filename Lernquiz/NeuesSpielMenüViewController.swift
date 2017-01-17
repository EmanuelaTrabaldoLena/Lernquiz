//
//  UserTableViewController.swift
//  Lernquiz
//
//  Created by Lisa Lohner on 12.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit
import Parse

class NeuesSpielMenüViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating{

    var searchController = UISearchController()
    var usernames = [String]()
    var gefilterterInhalt = [String]()
    var solltegefilterteErgebnissezeigen = false
    
    @IBOutlet weak var spielerSuchen: UITableView!{
        didSet {
            spielerSuchen.dataSource = self
            spielerSuchen.delegate = self
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.gefilterterInhalt.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.usernames as NSArray).filtered(using: searchPredicate)
        self.gefilterterInhalt = array as! [String]
        self.spielerSuchen.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.spielerSuchen.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.placeholder = "Welchen Spieler suchst du?"
        self.spielerSuchen.reloadData()
        
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                print(error!)
            }
            else if let users = objects {
                self.usernames.removeAll()
                
                for object in users {
                    if let user = object as? PFUser{
                        //schneidet den usernamen vor dem @Zeichen ab
                        let usernameArray = user.username!.components(separatedBy: "@")
                        self.usernames.append(usernameArray[0])
                    }
                }
                //Ausnahme: eigener Username darf natürlich nicht auftauchen
            }
            self.spielerSuchen.reloadData()
        })

    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive{
            return self.gefilterterInhalt.count
        }else{
            return self.usernames.count
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        if self.searchController.isActive{
           cell.textLabel!.text = self.gefilterterInhalt[indexPath.row]
            return cell
        }
        else{
        cell.textLabel?.text = self.usernames[indexPath.row]
        return cell
        }
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
