//
//  FachTableViewCell.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit
import Parse

//Controller fuer die TableViewCell von AlleFaecher
class FachTableViewCell: UITableViewCell{
    
    @IBOutlet weak var name : UILabel?
    @IBOutlet weak var checkbox : CheckBoxView?
    
    var fach : Fach = Fach()
    
    
    //Ueberpruefung und Umsetzung des Anwaehlens der Checkboxen
    func configure(fach : Fach){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FachTableViewCell.tap))
        checkbox!.addGestureRecognizer(gestureRecognizer)
        
        self.fach = fach.copy() as! Fach
        if compareFach(in: gewaehlteVorlesungen, for: fach){
            self.fach.isSelected = true
        }
        self.name!.text = fach.name
        
        
        if(self.fach.isSelected){
            self.checkbox!.markAsChecked()
        } else {
            self.checkbox!.markAsUnChecked()
        }
    }
    
    
    //Falls eine Box markiert ist, wird sie durch anwählen wieder frei, falls sie nicht markiert ist, wird sie durch anwählen markiert
    func tap(){
        //
        if self.fach.isSelected{
            checkbox?.markAsUnChecked()
            self.fach.isSelected = false
            for f in gewaehlteVorlesungen{
                if f == self.fach{
                    f.isSelected = false
                }
            }
            self.entfernen(id: fach)
        } else {
            checkbox?.markAsChecked()
            self.fach.isSelected = true
            for f in gewaehlteVorlesungen{
                if f == self.fach{
                    f.isSelected = true
                }
            }
            gewaehlteVorlesungen.append(fach)
        }
        upload(fachArray: gewaehlteVorlesungen)
    }
    
    
    // Funktion, um Elemente korrekt aus Array zu entfernen
    func entfernen (id: Fach){
        for j in gewaehlteVorlesungen.indices.reversed(){
            if (gewaehlteVorlesungen[j].name == id.name){
                gewaehlteVorlesungen.remove(at: j)
            }
        }
    }
    
    
    //Fächer werden in den User im Server hochgeladen
    func upload(fachArray: [Fach]){
        if let currentUser = PFUser.current(){
            currentUser["MeineFaecher"] = NSMutableArray(object: NSKeyedArchiver.archivedData(withRootObject: fachArray))
            do {
                print("Versuche gewaehlteVorlesungen in User hochzuladen")
                try currentUser.save()
            } catch {
                print("Fehler beim Hochladen!")
            }
        }
    }
    
    
    //Vergleich, ob sich das Fach in den Fächern befindet
    func compareFach(in faecher : [Fach], for fach : Fach) -> Bool{
        for f in faecher{
            if f == fach{
                return true
            }
        }
        return false
    }
    
    
    //Ausgabe der gewaehlten markierten Faecher in Konsole
    func printAr(_ gewVor : [Fach]){
        var str = "["
        for i in gewVor{
            str += i.name + ", "
        }
        print(str + "]")
    }
}
