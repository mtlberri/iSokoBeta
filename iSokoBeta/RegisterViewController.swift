import UIKit


class RegisterViewController: UIViewController {
    
    // MARK: Outlets
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
    
    @IBAction func createAccountButtonPressed(sender: UIButton) {
        
        // check that email and passwords are not empty
        if emailTextField.text == "" || passwordTextField.text == "" {
            // Pop-up (Alert view) to be created here
            displayMessage("Empty Field", message: "Either Email or Password was left empty")
            
            print("email or pwd is empty")
            
        } else {
            
            print("Email and password have been properly filled. email is \(emailTextField.text) and pwd is \(passwordTextField.text)")
            
            // create user on Firebase
            let ref = Firebase(url:"https://isoko.firebaseio.com")
            
            ref.createUser(emailTextField.text, password: passwordTextField.text,
                withValueCompletionBlock: { error, result in
                    
                    if error != nil {
                        // There was an error creating the account
                        self.displayMessage("There was an error creating your account", message: "\(error.description)")
                        
                    } else {
                        
                        let uid = result["uid"] as? String
                        print("Successfully created user account with uid: \(uid)")
                        
                        // create a user in the JSON tree
                        
                        let usersRef = ref.childByAppendingPath("users")
                        let newUserRef = usersRef.childByAppendingPath(uid)
                        newUserRef.childByAppendingPath("email").setValue(self.emailTextField.text)
                        
                        
                        // logging user in
                        ref.authUser(self.emailTextField.text, password: self.passwordTextField.text,
                            withCompletionBlock: { error, authData in
                                
                                if error != nil {
                                    print("There was an error logging in to this account")
                                } else {
                                    print("Account created! and \(self.emailTextField.text) is now logged in")
                                    
                                    // Navigate back to Home Page
                                    let targetViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomePageViewController") as! HomePageViewController
                                    self.navigationController?.pushViewController(targetViewController, animated: true)
                                    
                                    
                                }
                        })
                        
                    }
            })
                        
        }
        
    }
    
    // Alert message display method
    
    func displayMessage(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Create an action for the alert
        let OKaction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(OKaction)
        
        // Present the alert
        self.presentViewController(alert, animated: true, completion: nil)
        
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
