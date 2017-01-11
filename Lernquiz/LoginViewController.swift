//
//  LoginViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//

import UIKit
import Parse


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    var signupMode = false
    
    @IBOutlet var loginView: UIView!
    @IBOutlet var emailTextField: UITextField! {
        didSet{emailTextField.delegate = self}
    }
    @IBOutlet var passwordTextField: UITextField! {
        didSet{passwordTextField.delegate = self}
    }
    
    //Methode, die eine Fehlermeldung anzeigt wenn irgendwo etwas falsches eigegeben wurde z.B. Passwort, Emailadresse
    func createAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        //es passiert nichts neues wenn man die Fehlermeldung beseitigt hat
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        //wenn die Warnung erscheint, passiert nichts
        self.present(alert, animated: true, completion: nil);
        
    }
    
    @IBOutlet var signupOrLogin: UIButton!
    @IBAction func signupOrLogin(_ sender: AnyObject) {
        
        /* als Test
         print(signupMode)
         */
        
        //Test ob Username oder Passwort fehlen
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            //Die Methode die eine Fehlermeldung anzeigt wird aufgerufen
            createAlert(title: "Fehler", message: "Bitte gebe deine Emailadress und Passwort an")
            
        }
            
            //nachdem Username und Passwort eingegeben sind, jetzt eigentliche Anmeldung (weil wir Parse importiert haben, müssen wir nicht extra checken ob die Mailadresse gültig ist, das macht Parse für uns)
            
        else{
            
            //das passiert wenn man im Registrieren-Modus ist
            if signupMode{
                
                //im folgenden passiert die Registrierung
                
                //als erstes Erstellen eines users vom Typ "PFUser" (ist speziell geeignet für Emailaccounts)
                let user = PFUser()
                
                user.username = emailTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text
                
                //jetzt nimmt man den user und meldet ihn im Hintergrund an (dabei gibt es zwei Booleanwerte, entweder success/error je nachdem ob erfolgreich oder nicht
                user.signUpInBackground(block:{ (success, error) in
                    
                    //zuerst checken ob es einen Fehler während der Registrierung gibt
                    if let e = error{
                        
                        //-allgemeine- Fehlermeldung
                        var displayErrorMessage = "Bitte versuche es später nochmal."
                        
                        //-spezielle- Fehlermeldung
                        displayErrorMessage = e.localizedDescription
                        
                        self.createAlert(title: "Fehler bei der Registrierung", message: displayErrorMessage)
                    }
                        
                        //für den Fall dass es keine Fehler gibt
                    else{
                        print("Registrierung erfolgreich.")
                    }
                })
            }
                //das passiert wenn man nicht im Registriern-Modus (Anmelden-Modus) ist
            else{
                
                //im folgenden passiert die Anmeldung
                
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: {(user, error) in
                    
                    //zuerst checken ob es einen Fehler während der Registrierung gibt
                    if let e = error {
                        
                        //-allgemeine- Fehlermeldung
                        var displayErrorMessage = "Bitte versuche es später nochmal."
                        
                        
                        //-spezielle- Fehlermeldung
                        displayErrorMessage = e.localizedDescription
                        
                        self.createAlert(title: "Fehler bei der Anmledung", message: displayErrorMessage)
                        
                    }
                        
                        //für den Fall dass es keine Fehler gibt
                    else{
                        self.performSegue(withIdentifier: "LoginView2MeineFaecher", sender: nil)
                        print("Anmeldung erfolgreich.")
                    }
                })
                
            }
        }
    }
    
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var changeSignupModeButton: UIButton!
    
    //Methode, die den changeSignupModeButton verändert, je nachdem in welchem Modus man sich befindet
    @IBAction func changeSignupMode(_ sender: Any) {
        
        //das soll passieren wenn man im Registrieren-Modus ist
        if signupMode {
            
            //Wechsel in den Anmelden-Modus
            
            //nehme den signupOrLogin Button und ändere den Text
            signupOrLogin.setTitle("Anmelden", for:[])
            
            //nehme den changeSignupModeButton und ändere den Text
            changeSignupModeButton.setTitle("Registrieren", for: [])
            
            //ändere das messageLabel
            messageLabel.text = "Du hast noch kein Konto?"
            
            //aktualisiere den Registrieren-Modus nun als falsch
            signupMode = false
            
        }
            
            //das soll passieren wenn man nicht im Registriern-Modus (Anmelden) ist
        else {
            
            //Wechsel in den Registrieren-Modus (genau umgekehrt)
            
            //nehme den signupOrLogin Button und ändere den Text
            signupOrLogin.setTitle("Registrieren", for:[])
            
            //nehme den changeSignupModeButton und ändere den Text
            changeSignupModeButton.setTitle("Anmelden", for: [])
            
            //ändere das messageLabel
            messageLabel.text = "Du hast bereits ein Konto?"
            
            //aktualisiere den Registrieren-Modus nun wieder als richtig
            signupMode = true
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Berührungserkennung um das Keyboard verschwinden zu lassen
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 100)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 100)
    }
    
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }

}
