//
//  ViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit
import Parse

//Controller fuer die gesamte View MeineFaecher
class MeineFaecherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var meineFaecher: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        meineFaecher.dataSource = self
        meineFaecher.delegate = self
        meineFaecher.register(GewaehltesFachTableViewCell.self, forCellReuseIdentifier: "GewaehltesFachTableViewCell")
    }
    
    
    //User kann sich ausloggen und landet wieder auf der LoginView
    @IBAction func logout(_ sender: Any){
        PFUser.logOut()
        ausgeloggt = true
        gewaehlteVorlesungen.removeAll()
        performSegue(withIdentifier: "MeineFaecher2Login", sender: self)
    }
    
    
    //Durch klicken auf den hinzufuegen Button, wird man auf AlleFaecher weitergeleitet
    @IBAction func hinzufuegen(_ sender: UIButton){
        performSegue(withIdentifier: "MeineFaecher2AlleFaecher", sender: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        meineFaecher.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if gewaehlteVorlesungen != nil{
            return gewaehlteVorlesungen.count
        }
        return 0
    }
    
    
    //Gewaehlte Faecher in einzelne Zellen geladen und TableView scrollbar
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let fachCell = meineFaecher.dequeueReusableCell(withIdentifier: "GewaehltesFachTableViewCell", for: indexPath) as? GewaehltesFachTableViewCell{
            let row = indexPath.row
            fachCell.textLabel?.text = gewaehlteVorlesungen[row].name
            
            return fachCell
        }else{
            return GewaehltesFachTableViewCell()
        }
    }
    
    
    //Beim Auswaehlen eines Fachs aus der TableView wird man direkt zum Menue weitergeleitet
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        let menueVC = self.storyboard?.instantiateViewController(withIdentifier: "Menue") as! MenueViewController
        
        //Label in MenueView wird auf gewaehltes Fach aus der TableView gesetzt
        fachName = gewaehlteVorlesungen[row].name
        print("Gewaehltes Fach: \(fachName)")
        
        self.navigationController?.pushViewController(menueVC, animated: true)
    }
    
}
