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
                self.usernames.removeAll()
                
                for object in users {
                    if let user = object as? PFUser{
                        //schneidet den usernamen vor dem @Zeichen ab
                        let usernameArray = user.username!.components(separatedBy: "@")
                        self.usernames.append(usernameArray[0])
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
    
    // Beim Auswaehlen eines Fachs aus der TableView wird man direkt zum Menue weitergeleitet
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        
        let duellSpielstandVC = self.storyboard?.instantiateViewController(withIdentifier: "DuellSpielstand") as! DuellSpielstandViewController
        
        // Label Gegenspieler in DuellSpielstandView wird auf gewaehlten Mitspieler aus der TableView gesetzt
        mitSpieler = usernames[row]
        print("Gewaehlter Gegenspieler: \(mitSpieler)")
        
        self.navigationController?.pushViewController(duellSpielstandVC, animated: true)
    }
    
}
