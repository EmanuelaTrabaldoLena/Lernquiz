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
    @IBOutlet weak var belSpieler: UIButton!
    @IBAction func beliebigerSpieler(_ sender: Any){
        searchController.isActive = false
        performSegue(withIdentifier: "NeuesSpiel2DuellMenue", sender: belSpieler)
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.spielerSuchen.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.placeholder = "Welchen Spieler suchst du?"
        self.spielerSuchen.reloadData()
        
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) in
            if (error != nil){
                print(error!)
            }
                
            else if  let users = objects {
                self.usernames.removeAll()
                
                for object in users{
                    if let user = object as? PFUser{
                        
                        //schneidet den Usernamen vor dem @Zeichen ab
                        let usernameArray = user.username!.components(separatedBy: "@")
                        //Eigener Username wird nicht angezeigt
                        for i in 0 ..< self.usernames.count {
                            if(self.usernames[i] != eigenerName) {
                                self.usernames.append(usernameArray[0])
                            }
                        }
                    }
                }
            }
            self.spielerSuchen.reloadData()
        })
        
    }
    
    
    func updateSearchResults(for searchController: UISearchController){
        self.gefilterterInhalt.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.usernames as NSArray).filtered(using: searchPredicate)
        self.gefilterterInhalt = array as! [String]
        self.spielerSuchen.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.searchController.isActive{
            return self.gefilterterInhalt.count
        }else{
            return self.usernames.count
        }
    }
    
    
    //Beim auswaehlen eines Spielers aus der Suchtableview, wird man direkt in das DuellMenue weitergeleitet und das Spiel steht bei "Du bist dran"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if let userCell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? GegenspielerTableViewCell{
            
            let row = indexPath.row
            userCell.textLabel?.text = usernames[row]
            
            if self.searchController.isActive{
                userCell.textLabel!.text = self.gefilterterInhalt[indexPath.row]
                return userCell
            }else{
                userCell.textLabel?.text = self.usernames[indexPath.row]
                return userCell
            }
        }else{
            return GewaehltesFachTableViewCell()
        }
    }
    
    
    //Spiel wird im Server hochgeladen
    func upload(spiel: Spiel){
        let hochzuladendesObjekt = PFObject(className: "Spiele")
        hochzuladendesObjekt["Spiel"] = NSMutableArray(object: NSKeyedArchiver.archivedData(withRootObject: spiel))
        hochzuladendesObjekt["Spieler"] = eigenerName
        hochzuladendesObjekt["Gegner"] = gegnerName
        do{
            try hochzuladendesObjekt.save()
        }catch{
            print("Fehler beim Upload der Spieldateien!")
        }
    }
    
    
    //Beim Auswaehlen eines Fachs aus der TableView wird man direkt zum Menue weitergeleitet
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        gegnerName = usernames[row]
        let mitSpieler = Spieler(username: gegnerName, istDran: false)
        
        print("Gewaehlter Gegenspieler: \(mitSpieler.username)")
        
        searchController.isActive = false
        let erstesSpiel = Spiel.init()
        upload(spiel: erstesSpiel)
        performSegue(withIdentifier: "NeuesSpiel2DuellMenue", sender: mitSpieler)
    }
}
