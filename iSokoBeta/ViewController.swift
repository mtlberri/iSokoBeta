//
//  ViewController.swift
//  iSokoBeta
//
//  Created by Joffrey Armellini on 2016-01-30.
//  Copyright © 2016 Joffrey Armellini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create a reference to a Firebase location
        var myRootRef = Firebase(url:"https://<YOUR-FIREBASE-APP>.firebaseio.com")
        // Write data to Firebase
        myRootRef.setValue("Do you have data? You'll love Firebase.")
        
        //test Github
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

