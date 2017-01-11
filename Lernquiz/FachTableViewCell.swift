//
//  FachTableViewCell.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit

// Controller fuer die TableViewCell von AlleFaecher
class FachTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name :UILabel?
    @IBOutlet weak var checkbox :CheckBoxView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Ueberpruefung und Umsetzung des Anwaehlens der Checkboxen
    func configure(fach :Fach) {
        
        if(fach.isSelected) {
            self.checkbox!.markAsChecked()
        } else {
            self.checkbox!.markAsUnChecked()
        }
        
        self.name?.text = fach.name
        
        self.checkbox?.checkBoxChanged = {
            
            if(!fach.isSelected) {
                self.checkbox!.markAsChecked()
                fach.isSelected = true
                
                // Angewaehlte Faecher in Array speichern
                if gewaehlteFaecher.contains(fach.name!) {
                    self.checkbox!.markAsChecked()
                    print(gewaehlteFaecher)
                } else {
                    gewaehlteFaecher.append(fach.name!)
                    print(gewaehlteFaecher)
                }
            } else {
                self.checkbox!.markAsUnChecked()
                fach.isSelected = false
                
                // Abgewaehlte Faecher aus Array entfernen
                if gewaehlteFaecher.contains(fach.name!) {
                    self.entfernen(id: [fach.name!])
                }
                print(gewaehlteFaecher)
            }
        }
    }
    
    // Falls Faecher bereits gespeichert sind, sollen die Checkboxen bereits ausgewaehlt sein, wenn man auf AlleFaecher kommt
    func gewaehlt(gewaehltesFach :NSMutableArray) {
        if (vorlesungsverzeichnis.contains(gewaehltesFach)){
            self.checkbox?.markAsChecked()
        }
    }
    
    
    // Haken wird gezeichnet, falls ein Fach gewaehlt wird
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Funktion, um Elemente korrekt aus Array zu entfernen
    func entfernen (id: [String]) {
        for i in id.indices {
            for j in gewaehlteFaecher.indices.reversed() {
                if gewaehlteFaecher[j] == id[i] {
                    gewaehlteFaecher.remove(at: j)
                }
            }
        }
    }
    
}
