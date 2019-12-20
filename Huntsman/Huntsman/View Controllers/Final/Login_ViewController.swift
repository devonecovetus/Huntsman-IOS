//
//  Login_ViewController.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 27/02/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class Login_ViewController: UIViewController {
    
    @IBOutlet weak var img_bg: UIImageView?
    @IBOutlet weak var ypostion : NSLayoutConstraint!
    @IBOutlet weak var tf_useremail: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet var baseview_sapceconstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (Device.IS_IPHONE_X){ //iPhone X
            baseview_sapceconstraint.constant = 105
            img_bg?.image = UIImage(named:"login-background-x-@3x.png")
        }
        if(Device.IS_IPHONE_6P){ //iPhone Plus
            baseview_sapceconstraint.constant = 105
            ypostion.constant = 135
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func back(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
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
        return isValid
    }
    
    // MARK: IBActions
    @IBAction func loginButtonClick(sender: AnyObject?){
        if isValidInput() {
            view.endEditing(true)
            LoderGifView.MyloaderShow(view: view)
            callLoginAPI()
        }
    }
 
    // MARK: API Calls
    func callLoginAPI() {
        let params = [
            URLConstant.Param.EMAIL: tf_useremail.text!,
            URLConstant.Param.PASSWORD: tf_password.text!,
            URLConstant.Param.DEVICETYPE: "Iphone",
            URLConstant.Param.DEVICEID: PreferenceUtil.getUserdevicetoken()
        ]
        // MARK:URLConstant.API.SIGN_IN Class in api name and params...(user login api)
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.SIGN_IN,view: self.view , params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let data = json.value(forKey: "user_info") as! NSDictionary
                        print(data)
                        let str_isVerifed:String = String(format: "%@",  data.value(forKey:"email_verify") as! CVarArg)
                        
                        if str_isVerifed == "0"
                        {
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let Signup_Verify = storyBoard.instantiateViewController(withIdentifier: "Signup_VerifyVc") as! Signup_VerifyVc
                            Signup_Verify.Str_Flage = "Login_ViewController"
                            Signup_Verify.Str_Email = self.tf_useremail.text!
                            Signup_Verify.Str_password = self.tf_password.text
                            self.navigationController?.pushViewController(Signup_Verify, animated: true)
                        }
                        else
                        {
                            let user = User()
                            if let id = data.value(forKey:"id") as? String, Int(id) != nil {user.id = Int(id)!}
                            if let name = data.value(forKey:"name") as? String {user.name = name}
                            if let lastname = data.value(forKey:"lastname") as? String {user.lastname = lastname}
                            if let token = json.value(forKey:"auth_token") as? String {user.token = token}
                            if let password = self.tf_password.text {user.password = password}
                            
                            if let profileimg = data.value(forKey:"profile_pic") {user.profilepic = profileimg as! String}
                            
                            user.email = self.tf_useremail.text!
                            PreferenceUtil.saveUser(user: user)
                            
                            PreferenceUtil.saveProfileComplete(string:"no")
                            // for get all Industry
                            WebserviceUtil.callGet(jsonRequest: URLConstant.API.ALL_INDUSTRY,view:self.view ,success: { (response) in
                                if let json = response as? NSDictionary {
                                    if let status = json.value(forKey: "status") as? String {
                                        if status == "OK" {
                                            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: json.value(forKey: "industries") as? NSArray as Any)
                                            PreferenceUtil.saveIndustryList(list: encodedData as NSData)
                                            LoderGifView.MyloaderHide(view: self.view)
                                            
                                            if (data.value(forKey:"interest_ids") as? String) == nil || (data.value(forKey:"interest_ids") as? String) == "" {
                                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                                let profile = storyBoard.instantiateViewController(withIdentifier: "ProfileStep2_VC") as! ProfileStep2_VC
                                                self.navigationController?.pushViewController(profile, animated: true)
                                            } else
                                            {
                                                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                                                appdelegate.rootview_views(string: "discover")
                                                PreferenceUtil.saveProfileComplete(string:"yes")
                                            }
                                        }
                                        else {
                                            LoderGifView.MyloaderHide(view: self.view)
                                            UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                                            // parsing status error
                                        }
                                    }
                                }
                            }) { (error) in
                                print("Error in Calling API = \(error.localizedDescription)")
                                LoderGifView.MyloaderHide(view: self.view)
                                if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)"
                                {
                                    UIUtil.showMessage(title: "No Internet Connection", message:"Make sure your device is connected to the internet.", controller: self, okHandler: nil)
                                }
                                else
                                {
                                    UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
                                }
                            }
                            // for get all interest api
                            WebserviceUtil.callGet(jsonRequest: URLConstant.API.ALL_INTEREST,view:self.view, success: { (response) in
                                if let json = response as? NSDictionary {
                                    if let status = json.value(forKey: "status") as? String {
                                        if status == "OK" {
                                            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: json.value(forKey: "interest") as? NSArray as Any)
                                            PreferenceUtil.saveInterestList(list: encodedData as NSData)
                                        }
                                        else {
                                            LoderGifView.MyloaderHide(view: self.view)
                                            UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                                        }
                                    }
                                }
                            }) { (error) in
                                print(error.localizedDescription)
                                LoderGifView.MyloaderHide(view: self.view)
                                if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)"
                                {
                                    UIUtil.showMessage(title: "No Internet Connection", message:"Make sure your device is connected to the internet.", controller: self, okHandler: nil)
                                }
                                else
                                {
                                    UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
                                }
                                
                            }
                        }
                    }
                    else {
                        LoderGifView.MyloaderHide(view: self.view)
                        UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            LoderGifView.MyloaderHide(view: self.view)
            if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)"
            {
                UIUtil.showMessage(title: "No Internet Connection", message:"Make sure your device is connected to the internet.", controller: self, okHandler: nil)
            }
            else
            {
                UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
            }
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension Login_ViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tf_useremail {
            moveTextField(textField, moveDistance: -40, up: true)
        } else {
            moveTextField(textField, moveDistance: -80, up: true)
        }
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tf_useremail {
            moveTextField(textField, moveDistance: -40, up: false)
        } else {
            moveTextField(textField, moveDistance: -80, up: false)
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
