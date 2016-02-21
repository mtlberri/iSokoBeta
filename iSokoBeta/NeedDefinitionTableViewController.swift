import UIKit

class NeedDefinitionTableViewController: UITableViewController {

    // MARK: properties
    var ref: Firebase!
    var userNeed: [String: AnyObject] = ["unlimitedNationwideMinutes": Bool(true), "monthlyCellularDataAmount": Float(0.5), "newDeviceRequired": NSNull()] {
        // property observer after each time the propoerty is changed
        didSet {
            print("user need did change")
            self.reconfigureViewWIthUserNeed()
        }
    }
    let maxDataAmount: Float = 15
    
    // MARK: Outlets
    @IBOutlet weak var unlimitedNationwideMinutesSwitch: UISwitch!
    @IBOutlet weak var chosenDeviceLabel: UILabel!
    @IBOutlet weak var dataSlider: UISlider!
    @IBOutlet weak var mobileDataLabel: UILabel!
    @IBOutlet weak var deviceSwitch: UISwitch!
    @IBOutlet weak var deviceSelectionCell: UITableViewCell!
    
    // MARK: functions override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Firebase(url:"https://isoko.firebaseio.com")
        
        // if the user is logged in, initiate the user need based on Firebase
        if self.ref.authData != nil {
            
            // going to the user needs issued
            let refUserNeedsIssued = self.ref.childByAppendingPath("users/\(self.ref.authData.uid)/needsIssued")
            
            // retrieving the key for the last user need issued
            refUserNeedsIssued.queryLimitedToLast(1).observeSingleEventOfType(.ChildAdded, withBlock: { snapshot in
                let lastUserNeedIssuedKey: String = snapshot.key
                print("The last user need issued had key: \(lastUserNeedIssuedKey)")
                
                // initialize the user need with the last need
                self.initializeUserNeedWithKey(lastUserNeedIssuedKey)
                
            })
            
        } else {
            // just configure the view with default user need
            self.reconfigureViewWIthUserNeed()
        }
    }
    
    
    // MARK: prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Segue towards DeviceTableViewController
        // setting properties of destination controller
        /*
        if segue.identifier == "deviceSegue" {
            let myDeviceController = segue.destinationViewController
            // do something
        }
        */
    }
    
    // MARK: Actions
    @IBAction func unlimitedNationwideMinutesSwitchValueChanged(sender: UISwitch) {
        // set the userNeed property to appropriate value
        if sender.on {
            userNeed["unlimitedNationwideMinutes"] = true
        } else {
            userNeed["unlimitedNationwideMinutes"] = false
        }
        print("You want unlimited nationwide minutes: \(userNeed["unlimitedNationwideMinutes"] as! Bool)")
    }
    
    @IBAction func dataSliderValueChanged(sender: UISlider) {
        let exactValue = (sender.value) * maxDataAmount
        
        // if exact value is in between 0.5 and 1GB, display the intermediary 0.5GB
        if (exactValue > Float(0.1)) && (exactValue <= Float(1)) {
            //mobileDataLabel.text = "500MB"
            userNeed["monthlyCellularDataAmount"] = Float(0.5)
        } else if exactValue == maxDataAmount {
            // else if exact value is reaching max proposed, then display max proposed GB+
            //mobileDataLabel.text = "\(maxDataAmount)GB+"
            userNeed["monthlyCellularDataAmount"] = maxDataAmount
        } else {
            // else Int just rounds down the float
            let displayedValue = Int(exactValue)
            //mobileDataLabel.text = "\(displayedValue)GB"
            userNeed["monthlyCellularDataAmount"] = Float(displayedValue)
        }
    }
    
    @IBAction func deviceSwitchValueChanged(sender: UISwitch) {
        // if switch is on, cell editing is enabled and cell is shown
        if sender.on {
            deviceSelectionCell.userInteractionEnabled = true
            deviceSelectionCell.hidden = false
            chosenDeviceLabel.text = "Go chose your device"
            }
        else {
            // deviceSelectionCell.userInteractionEnabled = false
            // deviceSelectionCell.hidden = true
            userNeed["newDeviceRequired"] = NSNull()
            print("Device Cell interaction disabled, and hidden. Device selected set to nil.")
        }
    }
    
    
    @IBAction func unwindToNeedDefinition(sender: UIStoryboardSegue) {
        // if the sender source is the DeviceTableViewController
        // we retrieve the source view controller from which we unwind
        if let deviceViewController = sender.sourceViewController as? DeviceTableViewController {

            // if the selected index path is not empty (meaning the user did select a device)
            if let selectedDeviceIndexPath = deviceViewController.selectedDeviceIndexPath {
                // we retrieve the chosen device from the source device view controller
                let chosenDevice = DeviceTableViewController.deviceChoice2DArray[selectedDeviceIndexPath.section][selectedDeviceIndexPath.item + 1]
                // we update the user need
                userNeed["newDeviceRequired"] = chosenDevice
                // chosenDeviceLabel.text = chosenDevice
                print("You want a new device: \(userNeed["newDeviceRequired"])")
            }
        }
    }
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        
        // check if the user is logged in
        if self.ref.authData != nil {
            //user is authenticated and data can be saved to Firebase
            print("user \(ref.authData) is authenticated and data can is saved to Firebase")
            // save the user need on Firebase
            saveInFirebase()
        } else {
            print("user is not logged in and data cannot be saved in Firebase")
        }
        
    }
    
    // MARK: methods
    
    // Saving the data in Firebase
    func saveInFirebase() {
        
        let needsRef = self.ref.childByAppendingPath("needs")
        let userNeedRef = needsRef.childByAutoId()
        // set the values in Firebase
        userNeedRef.setValue(self.userNeed)
        // (on the need) index the user issuing the need
        userNeedRef.childByAppendingPath(ref.authData.uid).setValue(true)
        // (on the user) index the need issued by the user
        let userRef = Firebase(url:"https://isoko.firebaseio.com/users/\(ref.authData.uid)")
        userRef.updateChildValues(["needsIssued/\(userNeedRef.key)": true])
        print("The need \(userNeedRef.key) has been created in Firebase!")
    }
    
    // Initializing the user need thanks to the user need stored in Firebase at a given key
    func initializeUserNeedWithKey(key: String) {
        
        let UserNeedRef = self.ref.childByAppendingPath("needs/\(key)")
        UserNeedRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            let firebaseUserNeed = snapshot.value as! [String: AnyObject]
            print("The firebase user need we are attempting to init is \(firebaseUserNeed)")
            // check if the firebase need has the key - and if yes, use the unwrapped value to init user need
            if let x1 = firebaseUserNeed["unlimitedNationwideMinutes"] {
                self.userNeed["unlimitedNationwideMinutes"] = x1
            }
            if let x2 = firebaseUserNeed["monthlyCellularDataAmount"] {
                self.userNeed["monthlyCellularDataAmount"] = x2
            }
            if let x3 = firebaseUserNeed["newDeviceRequired"] {
                self.userNeed["newDeviceRequired"] = x3
            }
            
        })
        
    }
    
    // reconfigure switches, labels, buttons in line with the user need
    func reconfigureViewWIthUserNeed() {
        unlimitedNationwideMinutesSwitch.setOn(userNeed["unlimitedNationwideMinutes"] as! Bool, animated: false)
        dataSlider.value = userNeed["monthlyCellularDataAmount"] as! Float / maxDataAmount
        mobileDataLabel.text = stringForExactValue(userNeed["monthlyCellularDataAmount"] as! Float)
        
        // Depending if chosen device or not...
        if userNeed["newDeviceRequired"] is NSNull {
            deviceSwitch.on = false
            deviceSelectionCell.userInteractionEnabled = false
            deviceSelectionCell.hidden = true
        } else {
            // switch is set on
            deviceSwitch.on = true
            // cell is active and shown
            deviceSelectionCell.userInteractionEnabled = true
            deviceSelectionCell.hidden = false
            chosenDeviceLabel.text = userNeed["newDeviceRequired"] as! String
        }
    }
    
    // Function returning string corresponding to data amount chosen by user
    func stringForExactValue(exactValue: Float) -> String {
        // if exact value is in between 0.5 and 1GB, display the intermediary 0.5GB
        if (exactValue > Float(0.1)) && (exactValue <= Float(1)) {
            return "500MB"
        } else if exactValue == maxDataAmount {
            // else if exact value is reaching max proposed, then display max proposed GB+
            return "\(maxDataAmount)GB+"
        } else {
            // else Int just rounds down the float
            return "\(Int(exactValue))GB"
        }
    }
    
}
