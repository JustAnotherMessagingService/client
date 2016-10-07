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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Sign Up Function
    @IBAction func signUpAction(sender: AnyObject) {
        
//        dismissKeyboard()
        
        let username = self.usernameField.text
        let password = self.passwordField.text
        // TODO: Add email
//        let email = self.emailField.text
        
        // Set up the url
        
        // MARK: Network Calls
        let request = NSMutableURLRequest(url: NSURL(string: K.URL.CreateUserPath)! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let params = ["username":username!, "password":password!] as Dictionary<String, String>
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {
                // check for http errors
                
                print("statusCode should be 201, but is \(httpStatus.statusCode)")
                if httpStatus.statusCode == 409 {
                    let alert = UIAlertController(title: "Alert", message: "Username is already taken", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                    print("username already taken")
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
            else {
                    
            }
                print("response = \(response)")}
            
            // TODO: Check data! != nil
            if data != nil {
                // create user then move to home screen.
                do {
                    
                    // MARK: Save User
                    
                    let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    
                    let userID = object?["Id"] as? String
                    // TODO: Change email
                    let user = User(username: username!, email: "t@tits.com", userID: userID!)
                    print("user = \(user?.description)")
                    
                    
                    // MARK: Segue
                    let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! UITableViewController
                    self.present(login, animated: true)

                    
                    
                } catch {
                    // Handle Error
                    
                    print("User not created")
                }
                let responseString = String(data: data!, encoding: .utf8)
                print("responseString = \(responseString)")
            } else {
                print("Server Unavalible")
            }
        })
        
        task.resume()
        

    }
    
    // MARK: Keyboard dismissal
    
    func dismissKeyboard() {
        passwordField.resignFirstResponder()
    }

}
