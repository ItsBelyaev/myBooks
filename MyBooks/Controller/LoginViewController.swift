//
//  ViewController.swift
//  MyBooks
//
//  Created by Daniil Belyaev on 05.07.2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warnLabel.alpha = 0
        emailTF.delegate = self
        passwordTF.delegate = self
        
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "goToBooks", sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTF.text = ""
        passwordTF.text = ""
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTF.text, let password = passwordTF.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if error != nil {
                self.warnLabel.text = "Some error happened."
                self.warnLabel.alpha = 1
                print(error)
                print("Error")
                
            }
            if user == nil {
                    self.warnLabel.text = "Info is incorrect"
                    self.warnLabel.alpha = 1
                    print("User is nil")
            }
            if error == nil, user != nil {
                // go to tableVC
                self.performSegue(withIdentifier: "goToBooks", sender: self)
                print("logged in")
            }
        }
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let email = emailTF.text, let password = passwordTF.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error != nil {
                self.warnLabel.text = "Some error happened."
                self.warnLabel.alpha = 1
                print(error)
                print("Error")
            }
            if user == nil {
                self.warnLabel.text = "Info is incorrect"
                self.warnLabel.alpha = 1
                print("User is nil")
            }
            if error == nil, user != nil {
                self.warnLabel.text = "Successfully registered!"
                self.warnLabel.textColor = .green
                self.warnLabel.alpha = 1
            }
            
            
        }
    }
}

