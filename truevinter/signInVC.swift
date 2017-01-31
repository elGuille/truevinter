//
//  signInVC.swift
//  truevinter
//
//  Created by Guillermo García on 23/01/2017.
//  Copyright © 2017 Guillermo García. All rights reserved.
//

import UIKit
import Parse

class signInVC: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // font
        label.font = UIFont(name: "Roboto-Black", size: 25)
        label.textColor = UIColor.white
        
        // alignment
        label.frame = CGRect(x: 10, y: 80, width: self.view.frame.size.width - 20, height: 50)
        
        usernameTxt.frame = CGRect(x: 10, y: label.frame.origin.y + 70, width: self.view.frame.width - 20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40 , width: self.view.frame.size.width - 20, height: 30)
        
        forgotBtn.frame = CGRect(x: 10, y: passwordTxt.frame.origin.y + 30, width: self.view.frame.size.width - 20, height: 30)
        signInBtn.frame = CGRect(x: 20, y: forgotBtn.frame.origin.y + 40, width: self.view.frame.size.width / 4, height: 30)
        signUpBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 4 - 20, y: signInBtn.frame.origin.y, width: self.view.frame.size.width / 4, height: 30)
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        bg.contentMode = UIViewContentMode.scaleAspectFill
        self.view.addSubview(bg)

    }
    
    // hide keyboard
    func hideKeyboard(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @IBAction func sigInBtnPressed(_ sender: Any) {
        print("Sign in pressed")
        
        // hide keyboard
        self.view.endEditing(true)
        
        // if textFields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            
            // show alert message
            let alert = UIAlertController(title: "PLEASE", message: "fill in fields", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        // login functions
        PFUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user:PFUser?, error:Error?) -> Void in
            if error == nil {
                
                // remember user or save in App memory if the user login or not
                UserDefaults.standard.set(user!.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                // call login function from AppDelegate.swift class
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
                
            } else {
                
                // show alert message
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)

            }
        }
    }
   
}
