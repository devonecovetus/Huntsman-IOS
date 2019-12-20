//
//  SignupStep2_VC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 14/07/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit


// SignupStep2_Struct for use store information
struct SignupStep2_Struct {
    static var Struct_Useremail : NSString = ""
    static var Struct_Password : NSString = ""
    static var Str_Confirmpassword : NSString = ""
    static var Struct_firstname : NSString = ""
    static var Struct_lastname : NSString = ""
    static var Struct_Dob : NSString = ""
    static var Struct_DobParams : NSString = ""
}

class SignupStep2_VC: UIViewController {

    @IBOutlet weak var tf_useremail: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var tf_ConfirmPsw: UITextField!
    @IBOutlet weak var img_bg: UIImageView?

    var Str_username = ""
    var Str_lastname = ""
    var Str_dob = ""
    var Str_dobParams = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        if (Device.IS_IPHONE_X){ //iPhone X
            img_bg?.image = UIImage(named:"step-bg-x.png")
        }
        tf_useremail.attributedPlaceholder = NSAttributedString(string: "Email",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        tf_password.attributedPlaceholder = NSAttributedString(string: "Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        tf_ConfirmPsw.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    override func viewDidLayoutSubviews()
    {
        tf_useremail.underlined()
        tf_password.underlined()
        tf_ConfirmPsw.underlined()
    }

    
    @IBAction func nextClick(sender: AnyObject?)
    {
        if isValidInput() {
            view.endEditing(true)
            
            SignupStep2_Struct.Struct_Dob = Str_dob as NSString
            SignupStep2_Struct.Struct_firstname = Str_username as NSString
            SignupStep2_Struct.Struct_lastname = Str_lastname as NSString
            SignupStep2_Struct.Struct_Useremail = tf_useremail.text! as NSString
            SignupStep2_Struct.Struct_Password = tf_password.text! as NSString
            SignupStep2_Struct.Str_Confirmpassword = tf_ConfirmPsw.text! as NSString
            SignupStep2_Struct.Struct_DobParams = Str_dobParams as NSString
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "SignUpStep3_Vc") as! SignUpStep3_Vc
            self.navigationController?.pushViewController(profile, animated: true)
        }
    }
    
    
    // MARK: Helper Methods validations
    func isValidInput() -> Bool {
        var errorMessage = ""
        var isValid = true
     
         if let text = tf_useremail.text, text.isEmpty || !ValidationUtil.isValidEmail(testStr: text) {
            errorMessage = "Invalid Email"
            isValid = false
            UIUtil.showMessage(title: "", message: errorMessage, controller: self, okHandler: nil)
        } else if let password = tf_password.text, password.isEmpty {
            errorMessage = "Password Required"
            isValid = false
            UIUtil.showMessage(title: "", message: errorMessage, controller: self, okHandler: nil)
        }
        else if let password = tf_ConfirmPsw.text, password.isEmpty {
            errorMessage = "Confirm Password Required"
            isValid = false
            UIUtil.showMessage(title: "", message: errorMessage, controller: self, okHandler: nil)
        }
            
        else if tf_password.text != tf_ConfirmPsw.text
        {
            errorMessage = "Please check your password"
            isValid = false
            UIUtil.showMessage(title: "", message: errorMessage, controller: self, okHandler: nil)
        }
        
        
        return isValid
    }
    
    
    
    @IBAction func PreviousClick(sender: AnyObject?)
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
extension SignupStep2_VC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if Device.IS_IPHONE_5 {
            if textField == tf_ConfirmPsw {
                moveTextField(textField, moveDistance: -105, up: true)
            }
            else if textField == tf_useremail {
                moveTextField(textField, moveDistance: -75, up: true)
            }
            else if textField == tf_password {
                moveTextField(textField, moveDistance: -95, up: true)
            }
        } else {
            if textField == tf_ConfirmPsw {
                moveTextField(textField, moveDistance: -160, up: true)
            }
            else if textField == tf_useremail {
                moveTextField(textField, moveDistance: -120, up: true)
            }
            else if textField == tf_password {
                moveTextField(textField, moveDistance: -135, up: true)
            }
        }
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        if Device.IS_IPHONE_5 {
            if textField == tf_ConfirmPsw {
                moveTextField(textField, moveDistance: -105, up: false)
            }
            else if textField == tf_useremail {
                moveTextField(textField, moveDistance: -75, up: false)
            }
            else if textField == tf_password {
                moveTextField(textField, moveDistance: -95, up: false)
            }
        }
        else
        {
            if textField == tf_ConfirmPsw {
                moveTextField(textField, moveDistance: -160, up: false)
            }
            else if textField == tf_useremail {
                moveTextField(textField, moveDistance: -120, up: false)
            }
            else if textField == tf_password {
                moveTextField(textField, moveDistance: -135, up: false)
            }
        }
    }
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}



