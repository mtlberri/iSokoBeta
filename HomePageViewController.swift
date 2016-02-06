//
//  HomePageViewController.swift
//  iSokoBeta
//
//  Created by Joffrey Armellini on 2016-01-30.
//  Copyright © 2016 Joffrey Armellini. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a reference to a Firebase location
        let myRootRef = Firebase(url:"https://isoko.firebaseio.com")
        
        // Read data and react to changes
        /*
        myRootRef.observeEventType(.Value, withBlock: {
            snapshot in
            print("\(snapshot.key) -> \(snapshot.value)")
        })
        */
        
        // check if user logged in
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
