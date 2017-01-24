    //
    //  AppDelegate.swift
    //  Lernquiz
    //
    //  Created by Emanuela Trabaldo Lena on 06.01.17.
    //  Copyright © 2017 iOS Praktikum. All rights reserved.
    //
    import UIKit
    import Parse
    import Bolts
    import CoreData
    import FBSDKLoginKit
    
    
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate{
        
        var window: UIWindow?
        //var mpcHandler: MCPHandler = MPCHandler()
        
        
        //Wird gebraucht, wemm die App zum ersten Mal gespeichert wird
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool{
            
            FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
            
            //Damit Fehler fuer Constraints nicht immer in der Konsole angezeigt werden
            UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            IQKeyboardManager.sharedManager().enable = true
            
            //ssh -i "/Users/emanuela/Downloads/LernquizKey.pem" ubuntu@35.157.28.174
            //cd parse/htdocs
            //nano server.js startet Server mit richtigen Einstellungen, Daten daraus bezogen
            let configuration = ParseClientConfiguration {
                $0.applicationId = "8d3d7dc06b8564d24d7e478756f41390a0508ed2"
                $0.clientKey = "341bee5061a2266364917e7c1d80b05c3ddf1a9a"
                $0.server = "http://ec2-35-157-28-174.eu-central-1.compute.amazonaws.com:80/parse"
            }
            Parse.initialize(with: configuration)
            
            //Wird fuer Login benoetigt, setzt Standardrechte fuer User
            PFUser.enableAutomaticUser()
            let defaultACL = PFACL()
            defaultACL.getPublicReadAccess = true
            PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)
            
            //AlleFaecherTV wird gefuellt
            tableFuellen()
            //Erstellt das erste Speicherobjekt beim erstmaligen Ausfuehren der App
            initiateDefaultValues()
            //Laedt bereits gespeicherte Daten wieder rein
            localFetch()
            return true
        }
        
        
        //Zeilen der TableView mit dem Vorlesungsverzeichnis fuellen
        func tableFuellen(){
            //Ueber die Laenge des Arrays iterieren und die Namen des Verzeichnisses in den einzelnen Zellen einfuegen
            for i in verzeichnis{
                vorlesungsverzeichnis.append(Fach(name: i))
            }
        }
        
        
        func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool{
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        
        //Core Data Setup:
        
        //Erstelle das erste Speicherobjekt, worauf später zugegriffen wird. Diese Methode wird effektiv nur beim ersten App-Start seit der Installation ausgeführt, sonst passiert nichts.
        //Metaphorisch: Nimm deinen leeren Block und füge eine neue leere Seite hinzu mit der du später arbeiten möchtest.
        func initiateDefaultValues(){
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Allgemein")
            
            //Überprüfe ob jemals ein Element abgespeichert wurde
            do{
                let count = try persistentContainer.viewContext.count(for: fetchRequest)
                if count > 0 { return }
            }catch{}
            
            //Erstelle ein neues Speicherelement
            let entity = NSEntityDescription.entity(forEntityName: "Allgemein", in: persistentContainer.viewContext)
            allgemein = Allgemein(entity: entity!, insertInto: persistentContainer.viewContext)
            
            allgemein.gewaehlteVorlesungenLS = [Fach]() as NSObject?
        }
        
        
        //Hiermit wird alles was auf der Notizblockseite verändert wurde gespeichert.
        //Diese Methode sollte aus Effizienzgründen nur dann ausgeführt werden wenn der User die App verlässt, beendet etc.
        func saveContext(){
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    fatalError("Unresolved error \((error as NSError)), \((error as NSError).userInfo)")
                }
            }
        }
        
        
        public func localFetch(){
            //Erstelle Suche welche Notizblockseiten der Kategorie "Allgemein finden soll.
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Allgemein")
            //Greife auf den Hauptnotizblock zu
            let context = persistentContainer.viewContext
            //Lade unsere gefunden Hauptnotizblockseiten hier herein
            var result = [Allgemein]()
            
            do{
                //Führe nun die Suche durch und speichere das Resultat
                result = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [Allgemein]
            }catch let error as NSError{
                NSLog(error.domain, error.localizedDescription)
            }
            
            //Da wir immer nur mit einer Seite arbeiten interessiert uns immer das erste Element des Resultats, da schlichtweg keine anderen vorhanden sind.
            allgemein = result.first!
            
            //Greife nun auf den Inhalt der geladenen Seite zu, indem unsere globalen Variablen jeweils die Werte zugeschrieben bekommen:
            gewaehlteVorlesungen = allgemein.gewaehlteVorlesungenLS as! [Fach]
        }
        
        
        // Core Data Stack (oberstes Stack Element)
        lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Model") //Verknüpfung zu unserem Model
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError?{
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
        //@End: CoreData Setup
        
        func applicationWillResignActive(_ application: UIApplication) {
            // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
            // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        }
        
        func applicationDidEnterBackground(_ application: UIApplication) {
            // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
            // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
            self.saveContext()
        }
        
        func applicationWillEnterForeground(_ application: UIApplication) {
            // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        }
        
        func applicationDidBecomeActive(_ application: UIApplication) {
            FBSDKAppEvents.activateApp()
        }
        
        func applicationWillTerminate(_ application: UIApplication) {
            // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
            self.saveContext()
        }
    }
