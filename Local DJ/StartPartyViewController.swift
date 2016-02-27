//
//  StartPartyViewController.swift
//  Local DJ
//
//  Created by Kirill Kudaev, Jami Wissman on 1/26/16.
//  Copyright © 2016 Kirill Kudaev, Jami Wissman. All rights reserved.
//

import UIKit
//import Parse

class StartPartyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startPressed(sender: AnyObject) {
        
//        let testObject = PFObject(className: "Parties")
//        testObject["name"] = "WILL BE FROM TEXTFIELD"
//        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//        }

    }
    
    // Close keyboard when touched outside.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Close keyboard when "return" is touched.
    func textFieldShouldReturn(textfield: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
