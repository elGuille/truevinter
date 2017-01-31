//
//  resetPasswordVC.swift
//  truevinter
//
//  Created by Guillermo García on 23/01/2017.
//  Copyright © 2017 Guillermo García. All rights reserved.
//

import UIKit
import Parse

class resetPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // alignment 
        emailTxt.frame = CGRect(x: 10, y: 120, width: self.view.frame.size.width - 20, height: 30)
        resetBtn.frame = CGRect(x: 20, y: emailTxt.frame.origin.y + 50, width: self.view.frame.size.width / 4, height: 30)
        cancelBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 4 - 20, y: resetBtn.frame.origin.y , width: self.view.frame.size.width / 4, height: 30)
        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        bg.contentMode = UIViewContentMode.scaleAspectFill
        self.view.addSubview(bg)

    }
    
    
    @IBAction func resetBtnPressed(_ sender: Any) {
        
        // hide keyboard
        self.view.endEditing(true)
        
        if emailTxt.text!.isEmpty {
            
            // show alert message
            let alert = UIAlertController(title: "Email field", message: "is empty", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        PFUser.requestPasswordResetForEmail(inBackground: emailTxt.text!) { (success: Bool, error: Error?) -> Void in
            if success {
                
                let alert = UIAlertController(title: "Email for reseting password", message: "has being sent", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                print(error?.localizedDescription)
            }
        }
        
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        // hide keyboard when pressing Cancel
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }

    
}
