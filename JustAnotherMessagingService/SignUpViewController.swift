//
//  SignUpViewController.swift
//  JustAnotherMessagingService
//
//  Created by Dominic Schira on 9/19/16.
//  Copyright © 2016 Dominic Schira. All rights reserved.
//

import UIKit


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    override func viewDidLoad() {
        spinner.hidesWhenStopped = true;
        spinner.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        spinner.center = view.center;
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Sign Up Function
    @IBAction func signUpAction(sender: AnyObject) {
        
        dismissKeyboard()
        self.usernameErrorLabel.isHidden = true
        self.passwordErrorLabel.isHidden = true

        
        let username = self.usernameField.text
        let password = self.passwordField.text
        // TODO: Add email
//        let email = self.emailField.text
        
        // Check username and password fields
        if ((password?.isEmpty)! && (username?.isEmpty)!) {
            self.usernameErrorLabel.text = "Username cannot be empty"
            self.usernameErrorLabel.isHidden = false
            self.passwordErrorLabel.isHidden = false
            print("username && password are empty")
        }// check pasword field
        else if (password?.isEmpty)! {
            self.passwordErrorLabel.isHidden = false
            print("password is empty")
            
        } // check username field
        else if (username?.isEmpty)! {
            self.usernameErrorLabel.text = "Username cannot be empty"
            self.usernameErrorLabel.isHidden = false
            print("username is empty")
            
        }
        else {

            self.spinner.startAnimating()
            
            // MARK: Network Calls
            let request = NSMutableURLRequest(url: NSURL(string: K.URL.CreateUserPath)! as URL)
            let session = URLSession.shared
            request.httpMethod = "POST"
            
            let params = ["username":username!, "password":password!] as Dictionary<String, String>
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in

                // Make all UI calls on the main thread.
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                }
                
                
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {
                    // check for http errors

                    
                    print("statusCode should be 201, but is \(httpStatus.statusCode)")
                    
                    if httpStatus.statusCode == 409 {
                        DispatchQueue.main.async {
                            self.usernameErrorLabel.text = "Username is already taken"
                            self.usernameErrorLabel.isHidden = false
                        }
                        print("username already taken")
                        
                    }
                    print("response = \(response)")
                } else {
                    if data != nil {
                        do {
                            let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                            
                            let userID = object?["Id"] as? String
                            // TODO: Change email
                            let user = User(username: username!, email: "t@tits.com", userID: userID!)
                            print("user = \(user?.description)")
                            
                            
                            // MARK: Segue
                            DispatchQueue.main.async {
                                let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! UITableViewController
                                self.present(login, animated: true)
                            }
                            let responseString = String(data: data!, encoding: .utf8)
                            print("responseString = \(responseString)")

                            
                        } catch {
                            // Handle Error
                            print("User not created")
                        }
                    }
                }
                
            })
            
//            self.usernameErrorLabel.isHidden = true
//            self.passwordErrorLabel.isHidden = true
            task.resume()
            

        }
        
    }
    
    // MARK: Keyboard dismissal
    
    func dismissKeyboard() {
        passwordField.resignFirstResponder()
    }
    
}
