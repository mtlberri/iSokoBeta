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
    // Create a reference to a Firebase location
    let ref = Firebase(url:"https://isoko.firebaseio.com")

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Home View Did Load")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("Home View Did Appear")
        
        // monitor if user logged in
        self.ref.observeAuthEventWithBlock({ authData in
            if authData != nil {
                // user is logged in!
                print("user is logged in!")
                self.loginSwitch.setOn(true, animated: true)
                self.loginButton.setTitle("(\(authData.providerData["email"]!))", forState: .Normal)
                
            } else {
                // user is not logged in :(
                print("no user is logged in")
                self.loginSwitch.setOn(false, animated: true)
                self.loginButton.setTitle("Login", forState: .Normal)
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginSwithValueChanged(sender: UISwitch) {
        
        // if switch as been set to ON
        if sender.on {
            // trigger segue to login page
            performSegueWithIdentifier("loginSegue", sender: self)
        } else {
            // swith has been set to OFF
            // log out the user
            self.ref.unauth()
            print("user has been logged out")
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
