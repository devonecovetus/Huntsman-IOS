//
//  ChangePassword_VC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 09/05/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class ChangePassword_VC: UIViewController {

    // iboutlet here
    @IBOutlet weak var old_password: UITextField!
    @IBOutlet weak var new_password: UITextField!
    @IBOutlet weak var confirm_password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func Action_changepassword(_ sender: Any) {
        
        if isValidInput() {
            callLoginAPI()
        }
    }
    
    func callLoginAPI() {
        LoderGifView.MyloaderShow(view: self.view)
        
        let params = [
            URLConstant.Param.OLDPASSWORD:old_password.text!,
            URLConstant.Param.NEWPASSWORD:new_password.text!,
            URLConstant.Param.CONFIRMPASSWORD:confirm_password.text!
        ]
        /* CHANGEPASSWORD  for change password */
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.CHANGEPASSWORD,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        
                        let user = User()
                        
                        let tokenn = PreferenceUtil.getUser().token
                        let id = PreferenceUtil.getUser().id
                        let name = PreferenceUtil.getUser().name
                        let lastname = PreferenceUtil.getUser().lastname
                        let email = PreferenceUtil.getUser().email
                        let password = self.new_password.text!
                        let proflepic = PreferenceUtil.getUser().profilepic

                        user.token = tokenn
                        user.id = id
                        user.name = name
                        user.lastname = lastname
                        user.email = email
                        user.password = password
                        user.profilepic = proflepic

                        PreferenceUtil.saveUser(user: user)
                        
                        LoderGifView.MyloaderHide(view: self.view)
                        
                        let alertController = UIAlertController(title: "Huntsman", message: (json.value(forKey: "message") as? String)!, preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
                            self.dismiss(animated: true, completion: nil)
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else {
                        LoderGifView.MyloaderHide(view: self.view)
                        if let msg = json.value(forKey:"message") as? String, msg == "Invalid auth token."{
                            UIUtil.showLogout(title: "", message:"It seems you logged-in on other device with same user. To continue with same device please log-in again.", controller: self, okHandler: nil)
                        } else {
                            UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                        }
                        
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
    
    @IBAction func Action_dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helper Methods
    func isValidInput() -> Bool {
        var errorMessage = ""
        var isValid = true
        
       let oldpassword = PreferenceUtil.getUser().password
         
         if let text = old_password.text, text.isEmpty  {
         errorMessage = "Please enter old password"
         isValid = false
         UIUtil.showMessage(title: "", message: errorMessage, controller: self, okHandler: nil)
         }
         else if let text = new_password.text, text.isEmpty  {
         errorMessage = "Please enter new password"
         isValid = false
         UIUtil.showMessage(title: "", message: errorMessage, controller: self, okHandler: nil)
         }
         else if let text = confirm_password.text, text.isEmpty  {
         errorMessage = "Please enter confirm password"
         isValid = false
         UIUtil.showMessage(title: "", message: errorMessage, controller: self, okHandler: nil)
         }
         else if new_password.text != confirm_password.text {
         errorMessage = "Confirm password not same as old password"
         isValid = false
         UIUtil.showMessage(title: "", message: errorMessage, controller: self, okHandler: nil)
         }
         else if oldpassword != old_password.text {
         errorMessage = "Please enter correct old password"
         isValid = false
         UIUtil.showMessage(title: "", message: errorMessage, controller: self, okHandler: nil)
         }
        return isValid
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ChangePassword_VC:UITextFieldDelegate
{
    // textfiled methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

