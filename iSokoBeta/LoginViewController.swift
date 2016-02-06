//
//  LoginViewController.swift
//  iSokoBeta
//
//  Created by Joffrey Armellini on 2016-01-31.
//  Copyright © 2016 Joffrey Armellini. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        
        // check that email and passwords are not empty
        if emailTextField.text == "" || passwordTextField.text == "" {
            print("email or pwd is empty")
            displayMessage("Empty Field", message: "Either Email or Password was left empty")
            
        } else {
            
            print("email is \(emailTextField.text) and pwd is \(passwordTextField.text)")
            
            // create user on Firebase
            let ref = Firebase(url:"https://isoko.firebaseio.com")
            
            // logging user in
            ref.authUser(self.emailTextField.text, password: self.passwordTextField.text,
                withCompletionBlock: { error, authData in
                    
                    if error != nil {
                        print("There was an error logging in to this account")
                    } else {
                        print("\(self.emailTextField.text) is now logged in")
                        // Navigate back to Home Page
                        self.goToHome()
                    }
            })

            
        }
        
    }
    
    // Alert message display method
    func displayMessage(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Create an action for the alert
        let OKaction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(OKaction)
        
        // Present the alert
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func goToHome() {
        // Navigate back to Home Page
        let targetViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomePageViewController") as! HomePageViewController
        self.navigationController?.pushViewController(targetViewController, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
