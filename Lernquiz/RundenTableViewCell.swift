//
//  RundenTableViewCell.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 15.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit

class RundenTableViewCell: UITableViewCell {

    @IBOutlet weak var rundenLabel: UILabel!
    @IBOutlet weak var duS1: UIButton!
    @IBOutlet weak var duS2: UIButton!
    @IBOutlet weak var duS3: UIButton!
    @IBOutlet weak var gsS1: UIButton!
    @IBOutlet weak var gsS2: UIButton!
    @IBOutlet weak var gsS3: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
