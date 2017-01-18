//
//  GlobalVariables.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 16.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import Foundation

// Erweiterbares Array vom Vorlesungsverzeichnis
var vorlesungsverzeichnis = [Fach]()

// Erweiterbares Array von eigenen gewaehlten Faechern
var gewaehlteVorlesungen : [Fach]!

// Name des Faches, dass man zum Spielen ausgewaehlt hat
var fachName = String()

// Name des gewaehlten Gegenspielers
var mitSpieler = String()

// Eigener Username
var eigenerName = String()

//"Notizblockseite" vgl. Metaphorische Erklärung in AppDelegate localFetch()
var allgemein : Allgemein!
