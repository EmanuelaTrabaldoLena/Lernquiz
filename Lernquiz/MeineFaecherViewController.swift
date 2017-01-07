//
//  ViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit

var gewaehlteFaecher = [String]()

// Controller fuer die gesamte View MeineFaecher
class MeineFaecherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBAction func auswaehlen(_ sender: UIButton) {
         
    }
    @IBOutlet weak var meineFaecher: UITableView! {
        didSet {
            meineFaecher.dataSource = self
            meineFaecher.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        meineFaecher.dataSource = self
        meineFaecher.delegate = self
        meineFaecher.register(GewaehltesFachTableViewCell.self, forCellReuseIdentifier: "GewaehltesFachTableViewCell")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        meineFaecher.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gewaehlteFaecher.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fachCell = meineFaecher.dequeueReusableCell(withIdentifier: "GewaehltesFachTableViewCell", for: indexPath) as! GewaehltesFachTableViewCell
        
        fachCell.textLabel?.text = gewaehlteFaecher[indexPath.item]
        
        return fachCell
    }
}

