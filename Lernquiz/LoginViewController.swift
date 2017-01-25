//
//  LoginViewController.swift
//  Lernquiz
//
//  Created by Emanuela Trabaldo Lena on 06.01.17.
//  Copyright © 2017 iOS Praktikum. All rights reserved.
//


import UIKit
import Parse
import FBSDKLoginKit


class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    
    var signupMode = false
    
    @IBOutlet var loginView: UIView!
    
    @IBOutlet var usernameTextField: UITextField! {
        didSet{usernameTextField.delegate = self}
    }
    @IBOutlet var passwordTextField: UITextField! {
        
        didSet{passwordTextField.delegate = self}
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        usernameTextField.autocapitalizationType = UITextAutocapitalizationType.none
        passwordTextField.autocapitalizationType = UITextAutocapitalizationType.none
        
        
        if (FBSDKAccessToken.current() != nil){
            print("Du bist eingeloggt")
        } else {
            let loginButton = FBSDKLoginButton()
            loginButton.center = self.view.center
            loginButton.readPermissions = ["public_profile", "email"]
            loginButton.delegate = self
            self.view.addSubview(loginButton)
        }
        
        //Beruehrungserkennung um das Keyboard verschwinden zu lassen
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //ist zuständlich für den automatischen Login
    override func viewDidAppear(_ animated: Bool) {
        //vergleicht ob man schon vorher auf logout geklickt hat
        if ausgeloggt == false && PFUser.current() != nil{
            eigenerName = self.usernameTextField.text!
            performSegue(withIdentifier: "LoginView2MeineFaecher", sender: nil)
        }
        self.navigationController?.navigationBar.isHidden = true
        ausgeloggt = false
    }
    
    
    //Methode fuer den FacebookLoginButton
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
        }else if result.isCancelled {
            print("User cancelled login")
        }else {
            if result.grantedPermissions.contains("email"){
                if let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"]){
                    graphRequest.start(completionHandler: { (connection, result, error) in
                        if error != nil {
                            print(error!)
                        }else {
                            self.performSegue(withIdentifier: "LoginView2MeineFaecher", sender: nil)
                            if let userDetails = result as? [String: String] {
                                print(userDetails["email"]!)
                            }
                        }
                    })
                }
            }
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print ("Ausgeloggt")
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
        //Test ob Username oder Passwort fehlen
        if usernameTextField.text == "" || passwordTextField.text == "" {
            
            //Die Methode die eine Fehlermeldung anzeigt wird aufgerufen
            createAlert(title: "Fehler", message: "Bitte gebe deinen Usernamen und dein Passwort an")
        }
            //nachdem Username und Passwort eingegeben sind, jetzt eigentliche Anmeldung (weil wir Parse importiert haben, müssen wir nicht extra checken ob die Mailadresse gültig ist, das macht Parse für uns)
            
        else {
            //das passiert wenn man im Registrieren-Modus ist
            if signupMode{
                //im folgenden passiert die Registrierung
                //als erstes Erstellen eines users vom Typ "PFUser" (ist speziell geeignet für Emailaccounts)
                let user = PFUser()
                
                user.username = usernameTextField.text
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
                    else {
                        print("Registrierung erfolgreich.")
                    }
                })
            }
                //das passiert wenn man nicht im Registriern-Modus (Anmelden-Modus) ist
            else {
                //im folgenden passiert die Anmeldung
                PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: {(user, error) in
                    
                    //zuerst checken ob es einen Fehler während der Registrierung gibt
                    if let e = error {
                        
                        //-allgemeine- Fehlermeldung
                        var displayErrorMessage = "Bitte versuche es später nochmal."
                        
                        
                        //-spezielle- Fehlermeldung
                        displayErrorMessage = e.localizedDescription
                        
                        self.createAlert(title: "Fehler bei der Anmeldung", message: displayErrorMessage)
                    }
                        
                        //für den Fall dass es keine Fehler gibt
                    else{
                        
                        self.performSegue(withIdentifier: "LoginView2MeineFaecher", sender: nil)
                        //In der globalen Variable eigenerName wird der eingegebene Username gespeichert
                        eigenerName = self.usernameTextField.text!
                        print("Anmeldung mit Usernamen \(eigenerName) erfolgreich.")
                        ausgeloggt = false
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
            
            //nehme den signupOrLogin Button und aendere den Text
            signupOrLogin.setTitle("Anmelden", for:[])
            
            //nehme den changeSignupModeButton und aendere den Text
            changeSignupModeButton.setTitle("Registrieren", for: [])
            
            //aendere das messageLabel
            messageLabel.text = "Du hast noch kein Konto?"
            
            //aktualisiere den Registrieren-Modus nun als falsch
            signupMode = false
        }
            
            //das soll passieren wenn man nicht im Registriern-Modus (Anmelden) ist
        else {
            
            //Wechsel in den Registrieren-Modus (genau umgekehrt)
            
            //nehme den signupOrLogin Button und aendere den Text
            signupOrLogin.setTitle("Registrieren", for:[])
            
            //nehme den changeSignupModeButton und aendere den Text
            changeSignupModeButton.setTitle("Anmelden", for: [])
            
            //aendere das messageLabel
            messageLabel.text = "Du hast bereits ein Konto?"
            
            //aktualisiere den Registrieren-Modus nun wieder als richtig
            signupMode = true
            
        }
    }
    
    
    //    // Sorgt dafür, dass der User direkt in der App ist, falls er schon registriert und angemeldet ist
    //    override func viewDidAppear(_ animated: Bool) {
    //        if PFUser.current() != nil{
    //            performSegue(withIdentifier: "LoginView2MeineFaecher", sender: nil)
    //        }
    //        self.navigationController?.navigationBar.isHidden = true
    //    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        animateViewMoving(up: true, moveValue: 100)
    //    }
    //
    //
    //    func textFieldDidEndEditing(_ textField: UITextField) {
    //        animateViewMoving(up: false, moveValue: 100)
    //    }
    //
    //
    //    func animateViewMoving (up:Bool, moveValue :CGFloat){
    //        let movementDuration:TimeInterval = 0.3
    //        let movement:CGFloat = ( up ? -moveValue : moveValue)
    //        UIView.beginAnimations("animateView", context: nil)
    //        UIView.setAnimationBeginsFromCurrentState(true)
    //        UIView.setAnimationDuration(movementDuration)
    //        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
    //        UIView.commitAnimations()
    //    }
    
}
