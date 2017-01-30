//
//  Allgemein+CoreDataProperties.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 18.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import Foundation
import CoreData


//Ursprünglich zur lokalen Speicherung der Fächer angedacht, nun aber für Cachen des Usernamen und des Passwortes
extension Allgemein{

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Allgemein>{
        return NSFetchRequest<Allgemein>(entityName: "Allgemein");
    }

    @NSManaged public var gewaehlteVorlesungenLS: NSObject?

}
