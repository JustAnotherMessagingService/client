//
//  ViewController.swift
//  JustAnotherMessagingService
//
//  Created by Dominic Schira on 9/18/16.
//  Copyright © 2016 Dominic Schira. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToLogInScreen(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        dismissKeyboard()
        
        
        
    }
    // MARK: Keyboard dismissal
    
    func dismissKeyboard() {
        passwordField.resignFirstResponder()
    }

}

    
