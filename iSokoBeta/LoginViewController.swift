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
                    }
            })

            
        }
        
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
