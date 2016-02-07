import UIKit

// Table View Controller for UI where the user is defining its need
// Conforms to protocol UIPicker
// Conforms to protocol UIPickerViewDelegate
// Conforms to protocol UIPickerViewDataSource
class NeedDefinitionTableViewController: UITableViewController {

    // MARK: properties
    // User need being defined (implicitly unwrapped)
    var userNeed: UserNeed! = UserNeed(unlimitedNationwideMinutes: true, monthlyCellularDataAmount: 0.5, newDeviceRequired: nil)
    
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
        print("Need Definition view did load")
        
        // loading of saved user need (optional binding). Or initiating a blank one if none saved
        if let savedUserNeed = loadUserNeed() {
            self.userNeed = savedUserNeed
            print("User Need loaded from memory successfully")
            print("...saved choice nationwide minutes: \(userNeed.unlimitedNationwideMinutes)")
            print("...saved choice of data: \(userNeed.monthlyCellularDataAmount)")
            print("...saved choice of device: \(userNeed.newDeviceRequired)")
        } else {
            print("User Need could not be loaded from memory")
        }
        
        // initiate state of the switches and labels based on userNeed
        // unlimited nationwide minutes switch
        unlimitedNationwideMinutesSwitch.setOn(userNeed.unlimitedNationwideMinutes, animated: false)
        // mobile data slider
        dataSlider.value = userNeed.monthlyCellularDataAmount / Float(UserNeed.maxProposedMobileData)
        // mobile data text label
        mobileDataLabel.text = stringForExactValue(userNeed.monthlyCellularDataAmount)
        // if there is a chosen device
        if let chosenDevice = userNeed.newDeviceRequired {
            // switch is set on
            deviceSwitch.on = true
            // cell is active and shown
            deviceSelectionCell.userInteractionEnabled = true
            deviceSelectionCell.hidden = false
            // and label set to appropriate device
            chosenDeviceLabel.text = chosenDevice
            
        } else {
            deviceSwitch.on = false
            deviceSelectionCell.userInteractionEnabled = false
            deviceSelectionCell.hidden = true
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
            userNeed.unlimitedNationwideMinutes = true
        } else {
            userNeed.unlimitedNationwideMinutes = false
        }
        print("You want unlimited nationwide minutes: \(userNeed.unlimitedNationwideMinutes)")
    }
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        // save the user need locally on the device
        saveUserNeed()
        
        // save the user need on Firebase
        saveInFirebase()
        
    }
    
    @IBAction func dataSliderValueChanged(sender: UISlider) {
        let exactValue = (sender.value) * Float(UserNeed.maxProposedMobileData)
        
        // if exact value is in between 0.5 and 1GB, display the intermediary 0.5GB
        if (exactValue > Float(0.1)) && (exactValue <= Float(1)) {
            mobileDataLabel.text = "500MB"
            userNeed.monthlyCellularDataAmount = Float(0.5)
        } else if exactValue == Float(UserNeed.maxProposedMobileData) {
            // else if exact value is reaching max proposed, then display max proposed GB+
            mobileDataLabel.text = "\(UserNeed.maxProposedMobileData)GB+"
            userNeed.monthlyCellularDataAmount = Float(UserNeed.maxProposedMobileData)
        } else {
            // else Int just rounds down the float
            let displayedValue = Int(exactValue)
            mobileDataLabel.text = "\(displayedValue)GB"
            userNeed.monthlyCellularDataAmount = Float(displayedValue)
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
            deviceSelectionCell.userInteractionEnabled = false
            deviceSelectionCell.hidden = true
            userNeed.newDeviceRequired = nil
            print("Device Cell interaction disabled, and hidden. Device selected set to nil.")
        }
    }
    
    // MARK: unwind methods
    @IBAction func unwindToNeedDefinition(sender: UIStoryboardSegue) {
        // if the sender source is the DeviceTableViewController
        // we retrieve the source view controller from which we unwind
        if let deviceViewController = sender.sourceViewController as? DeviceTableViewController {

            // if the selected index path is not empty (meaning the user did select a device)
            if let selectedDeviceIndexPath = deviceViewController.selectedDeviceIndexPath {
                // we retrieve the chosen device from the source device view controller
                let chosenDevice = DeviceTableViewController.deviceChoice2DArray[selectedDeviceIndexPath.section][selectedDeviceIndexPath.item + 1]
                // we update the user need
                self.userNeed.newDeviceRequired = chosenDevice
                chosenDeviceLabel.text = self.userNeed.newDeviceRequired
                print("You want a new device: \(self.userNeed.newDeviceRequired)")
            }
        }
    }
    
    // MARK: methods
    func saveUserNeed() {
        
        // Method that attempts to archive the userNeed object to a specific location. Returns true if successful
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(userNeed, toFile: UserNeed.ArchiveURL.path!)
        // print console for debugging
        if !isSuccessfulSave {
            print("Failed to save the userNeed...")
        } else {
            print("userNeed has been saved successfully")
        }
    }
    
    // Saving the data in Firebase
    func saveInFirebase() {
        // create path to a new firebase need
        let ref = Firebase(url:"https://isoko.firebaseio.com")
        let needsRef = ref.childByAppendingPath("needs")
        let userNeedRef = needsRef.childByAutoId()
        
        // set the user need dictionary
        let firebaseUserNeed: [String: AnyObject] = ["unlimitedNationwideMinutes": self.userNeed.unlimitedNationwideMinutes, "monthlyCellularDataAmountKey": self.userNeed.monthlyCellularDataAmount]
        
        // set the values in Firebase
        userNeedRef.setValue(firebaseUserNeed)
        
        // (on the need) index the user issuing the need
        userNeedRef.childByAppendingPath(ref.authData.uid).setValue(true)
        
        // (on the user) index the need issued by the user
        let userRef = Firebase(url:"https://isoko.firebaseio.com/users/\(ref.authData.uid)")
        userRef.updateChildValues(["needsIssued/\(userNeedRef.key)": true])
        
        //
        
        print("The need \(userNeedRef.key) has been created in Firebase!")
    }
    
    func loadUserNeed() -> UserNeed? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(UserNeed.ArchiveURL.path!) as? UserNeed
    }
    
    // Function returning string corresponding to data amount chosen by user
    func stringForExactValue(exactValue: Float) -> String {
        // if exact value is in between 0.5 and 1GB, display the intermediary 0.5GB
        if (exactValue > Float(0.1)) && (exactValue <= Float(1)) {
            return "500MB"
        } else if exactValue == Float(UserNeed.maxProposedMobileData) {
            // else if exact value is reaching max proposed, then display max proposed GB+
            return "\(UserNeed.maxProposedMobileData)GB+"
        } else {
            // else Int just rounds down the float
            return "\(Int(exactValue))GB"
        }
    }
    
}
