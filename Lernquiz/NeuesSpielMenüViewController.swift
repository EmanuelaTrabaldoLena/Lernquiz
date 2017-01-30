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
        
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.spielerSuchen.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.placeholder = "Welchen Spieler suchst du?"
        self.spielerSuchen.reloadData()
        
        dowloadUser()
        
    }
    
    func dowloadUser()
    {
        let query = PFUser.query()
        let spiele = downloadSpiele()
        query?.findObjectsInBackground(block: { (objects, error) in
            if (error != nil){
                print(error!)
            }
                
            else if let users = objects {
                //Damit die erste Zeile nicht leer ist
                self.usernames.removeAll()
                
                loop_Users: for object in users{
                    if let user = object as? PFUser{
                        let usernameString = user.username ?? ""
                        
                        //überprüft ob spiel schon vorhanden ist (ob mit diesem spieler in diesem fach bereits ein aktives spiel vorhanden ist)
                        for spiel in spiele{
                            if ((usernameString == spiel.gegner.username) && (eigenerName == spiel.spieler.username) && (fachName == spiel.fachName))
                                ||
                                ((usernameString == spiel.spieler.username) && (eigenerName == spiel.gegner.username) && (fachName == spiel.fachName))
                            {
                                continue loop_Users //skip dieses Spiel da es schon vorhanden ist...
                            }
                        }
                        
                        print(eigenerName)
                        if(usernameString != eigenerName) {
                            // Es werden nur die User angezeigt, die auch mein gewaehltes Fach in ihrem FaecherArray haben
                            let meinFaecherHuelle = user["MeineFaecher"] as? NSMutableArray ?? NSMutableArray()
                            
                            //wir wollen überprüfen ob wir überhaupt jemals was hochgleaden haben, wenn ja dann führt aus wenn nein, dann skip
                            if let data = meinFaecherHuelle.firstObject as? Data
                            {
                                let meineFaecherl = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Fach] ?? [Fach]()
                                //as ? "if-Bedinungung" schaut ob man zu Fach casten kann, dann wird es zu Fach gecastet
                                //as ?? : "else-Bedinung" wenn casten nicht geht, erstellen wir ein neues leeres Fach
                                
                                for mitSpielerFach in meineFaecherl{
                                    if fachName == mitSpielerFach.name{
                                        self.usernames.append(usernameString)
                                    }
                                }
                            } else {
                                print("Keine Daten für Spieler \(usernameString) vorhanden.")
                            }
                        }
                    }
                }
            }
            self.spielerSuchen.reloadData()
        })
    }
    
    
    func downloadSpiele () -> [Spiel]{
        var output : [Spiel] = [Spiel]()
        let projectQuery = PFQuery(className: "Spiele")
        
        do{
            let spiele = try projectQuery.findObjects()
            for result in spiele{
                let encodedData = (result["Spiel"] as! NSMutableArray).firstObject as! NSData
                let spiel = NSKeyedUnarchiver.unarchiveObject(with: encodedData as Data) as! Spiel
                output.append(spiel)
            }
        }catch{}
        return output
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
        hochzuladendesObjekt["Fach"] = fachName
        do{
            try hochzuladendesObjekt.save()
        }catch{
            print("Fehler beim Upload der Spieldateien!")
        }
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
    
    //Beim Auswaehlen eines Fachs aus der TableView wird man direkt zum Menue weitergeleitet
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        gegnerName = usernames[row]
        let mitSpieler = Spieler(username: gegnerName, istDran: false)
        let dieserSpieler = Spieler(username: eigenerName, istDran: true)
        
        print("Gewaehlter Gegenspieler: \(mitSpieler.username)")
        
        searchController.isActive = false
        let erstesSpiel = Spiel(spieler: dieserSpieler, gegner: mitSpieler, fach: Fach(name: fachName), runde: 0)
        upload(spiel: erstesSpiel)
        _ = self.navigationController?.popViewController(animated: true)
    }
}
