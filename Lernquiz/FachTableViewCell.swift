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
                if gewaehlteVorlesungen.contains(fach) {
                    self.checkbox!.markAsChecked()
                    print(gewaehlteVorlesungen)
                } else {
                    gewaehlteVorlesungen.append(fach)
                    print(gewaehlteVorlesungen)
                }
            } else {
                self.checkbox!.markAsUnChecked()
                fach.isSelected = false
                
                // Abgewaehlte Faecher aus Array entfernen
                if gewaehlteVorlesungen.contains(fach) {
                    self.entfernen(id: fach)
                }
                print(gewaehlteVorlesungen)
            }
        }
    }
    
    
    // Falls Faecher bereits gespeichert sind, sollen die Checkboxen bereits ausgewaehlt sein, wenn man auf AlleFaecher kommt
    func gewaehlt(cellFach : Fach) {
        for fach in gewaehlteVorlesungen {
            if fach.name == cellFach.name {
                self.checkbox?.markAsChecked()
            }
        }
    }
    
    
    // Ausgabe der gewaehlten markierten Faecher in Konsole
    func printAr(_ gewVor : [Fach]) {
        var str = "[ "
        for i in gewVor {
            str += i.name + "; "
        }
        print(str + " ]")
    }
    
    
    // Haken wird gezeichnet, falls ein Fach gewaehlt wird
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Funktion, um Elemente korrekt aus Array zu entfernen
    func entfernen (id: Fach) {
        for j in gewaehlteVorlesungen.indices.reversed() {
            if (gewaehlteVorlesungen[j].name == id.name) {
                gewaehlteVorlesungen.remove(at: j)
            }
        }
    }
    
}
