import UIKit

class NeedAnOfferTableViewController: UITableViewController {

    // MARK: Properties
    var ref: Firebase!
    var handle: UInt!
    var offer: [Offer] = [Offer(provider: "None", monthlyRate: 0.0)] {
        //property observer that will refresh table
        didSet{
            print("offer array did change")
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ref = Firebase(url:"https://isoko.firebaseio.com")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Need and Offer table view will appear")
        
        // load offers 0 and 1 from Firebase
        self.loadOffersFromFirebase(["0","1"])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.offer.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OfferTableViewCell", forIndexPath: indexPath) as! OfferTableViewCell

        // Configure the cell...
        cell.rate.text = String("\(self.offer[indexPath.item].monthlyRate)$")

        return cell
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        // self.ref.removeObserverWithHandle(self.handle)
        // print("offer event listener handle removed")
    }
    
    // MARK: functions
    
    func loadOffersFromFirebase(offersIDArray: [String]) {
        
        let firebaseOffers = self.ref.childByAppendingPath("offers")
        
        for offerID in offersIDArray {
            
            firebaseOffers.childByAppendingPath("\(offerID)").observeEventType(.Value, withBlock: { snapshot in
                
                print("test offer \(offerID) snaphot value is: \(snapshot.value)")
                
                // append additional Offer to the Array of Offers
                self.offer.append(Offer(provider: snapshot.value["provider"] as! String, monthlyRate: snapshot.value["monthlyRate"] as! Float))
                
            })
            
            
        }
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
