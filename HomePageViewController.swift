//
//  HomePageViewController.swift
//  iSokoBeta
//
//  Created by Joffrey Armellini on 2016-01-30.
//  Copyright © 2016 Joffrey Armellini. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("Home View Did Appear")
        let ref = Firebase(url:"https://isoko.firebaseio.com")
        
        // monitor if user logged in
        if ref.authData != nil {
                // user is logged in!
                print("user is logged in!")
                self.loginSwitch.setOn(true, animated: true)
                self.loginButton.setTitle("(\(ref.authData.providerData["email"]!))", forState: .Normal)
                
            } else {
                // user is not logged in :(
                print("no user is logged in")
                self.loginSwitch.setOn(false, animated: true)
                self.loginButton.setTitle("Login", forState: .Normal)
            }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginSwithValueChanged(sender: UISwitch) {
        
        // if switch as been set to ON
        if sender.on {
            // trigger segue to login page
            goToLogin()
            
        } else {
            // swith has been set to OFF
            // log out the user
            
            let alert = UIAlertController(title: "Log out?", message: "Are you sure you want to Log Out?", preferredStyle: .Alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .Default, handler: {(action: UIAlertAction!) in
                let ref = Firebase(url:"https://isoko.firebaseio.com")
                ref.unauth()
                self.loginButton.setTitle("Login", forState: .Normal)
                print("user has been logged out")
            })
            
            let noAction = UIAlertAction(title: "No", style: .Default, handler: {(action: UIAlertAction!) in
                self.loginSwitch.on = true
                print("no do not log me out")
            })
            
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            

        }
    }

    
    @IBAction func loginButtonPressed(sender: UIButton) {
        
        let ref = Firebase(url:"https://isoko.firebaseio.com")
        
        // if user logged in: do nothing
        if ref.authData != nil {
            print("user already logged in. do nothing")
            
        } else {
            print("go to login page!")
            goToLogin()
        }
        
        
    }

    // Go to login page method
    func goToLogin() {
        
        // create a constant pointing to the target view controller
        let targetController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        
        // go to the navigation controller of the view and push to target view from there
        self.navigationController?.pushViewController(targetController, animated: true)
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
