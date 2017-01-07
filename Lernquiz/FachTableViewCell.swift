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
    func configure(fach :Faecher) {
        
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
            } else {
                self.checkbox!.markAsUnChecked()
                fach.isSelected = false
            }
        }
    }
    
    // Haken wird gezeichnet, falls ein Fach gewaehlt wird
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
