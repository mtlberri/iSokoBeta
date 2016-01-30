import UIKit

class DeviceTableViewController: UITableViewController {

    // List of Devices
    static let deviceChoice2DArray: [[String]] = [["iPhone", "iPhone 6s Plus", "iPhone 6s", "iPhone 6 Plus", "iPhone 6", "iPhone 5s"], ["Samsung", "Samsung Galaxy S6 edge+", "Samsung Galaxy Note5", "Samsung Galaxy Grand Prime", "Samsung Galaxy S6 edge", "Samsung Rugby 4", "Samsung Galaxy S6", "Samsung Galaxy A5", "Samsung Galaxy Grand Prime", "Samsung Galaxy Note 4", "Samsung Galaxy Core LTE", "Samsung Galaxy S5 Neo"]]
    // note: first element of each sub-array is the title of the section of the table view (e.g.: iPhone)

    // Outlets
    @IBOutlet weak var saveButton: UIButton!
    
    // Index path to store the index path of the table view cell checked (with a checkmark)
    var selectedDeviceIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return as many sections as sub-arrays in the deviceChoice2DArray
        return DeviceTableViewController.deviceChoice2DArray.count
        
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return as many devices as items in the sub-array (-1 because the first item in the list is the section title)
        return DeviceTableViewController.deviceChoice2DArray[section].count - 1
    }

    // Populate Table VIew with cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("deviceCell", forIndexPath: indexPath)

        // Configure the cell...
        // cell is filled with the device name at the given sectionm, and at index + 1 (because first element is not a device, but the section title)
        cell.textLabel?.text = DeviceTableViewController.deviceChoice2DArray[indexPath.section][indexPath.item + 1]
        
        // set an accessory checkmark on the cell if the cell corresponds to the selected device
        if indexPath == selectedDeviceIndexPath {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // title for header per section (the title is stored in the first element of each sub-array
        return DeviceTableViewController.deviceChoice2DArray[section][0]
    }

    // method called when user select a cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // store the index path in dedicated property
        selectedDeviceIndexPath = indexPath
        // Reload the table
        tableView.reloadData()
    }
    

    // MARK: Naviagtion
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // No Specific action required to configure the object before segue. Properties are already set up and record the user choice
        print("Prepared for segue = OK")
        
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
