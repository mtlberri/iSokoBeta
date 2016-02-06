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
        print("Home View Did Load")
        
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
            // performSegueWithIdentifier("loginSegue", sender: self)
            
            let targetController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            
            self.navigationController?.pushViewController(targetController, animated: true)
            
        } else {
            // swith has been set to OFF
            // log out the user
            let ref = Firebase(url:"https://isoko.firebaseio.com")
            ref.unauth()
            self.loginButton.setTitle("Login", forState: .Normal)
            print("user has been logged out")
        }
    }

    
    @IBAction func loginButtonPressed(sender: UIButton) {
        
        let ref = Firebase(url:"https://isoko.firebaseio.com")
        
        // if user logged in: do nothing
        if ref.authData != nil {
            print("user already logged in. do nothing")
            
        } else {
            print("go to login page!")
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
