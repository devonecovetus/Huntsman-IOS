//
//  Signup_VerifyVc.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 14/07/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class Signup_VerifyVc: UIViewController
{
    @IBOutlet weak var Tf_Verify:UITextField!
    @IBOutlet weak var img_bg: UIImageView?
    @IBOutlet weak var lbl_ResendAgain: UILabel!

    var Str_Flage = ""
    var Str_Email = ""
    var Str_password: String? = ""


    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("Emailid \(Str_Email)")
        print("Str_password \(Str_password ?? "")")

        if (Device.IS_IPHONE_X){ //iPhone X
            img_bg?.image = UIImage(named:"step-bg-x.png")
        }
        
        let wholeStr = "Resend the code"
        let rangeToUnderLine = NSRange(location: 0, length: 15)
        let underLineTxt = NSMutableAttributedString(string: wholeStr, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(1.0)])
        underLineTxt.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: rangeToUnderLine)
        lbl_ResendAgain.attributedText = underLineTxt
        
        Tf_Verify.attributedPlaceholder = NSAttributedString(string: "**   **",
               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
    }
      @IBAction func Action_Resend(_ sender: Any) {
         callResendOtp()
    }
    
 
    override func viewDidLayoutSubviews() {
      Tf_Verify.underlined()
    }
    
    @IBAction func Action_Verify(_ sender: Any) {
        if let verify = Tf_Verify.text, verify.isEmpty {
          
            UIUtil.showMessage(title: "", message: "Please enter verification code", controller: self, okHandler: nil)
        }
        else
        {
            callVerify()
        }
    }
    
    // MARK: API Calls verify user
    func callVerify() {
        LoderGifView.MyloaderShow(view: self.view)
        let params = [
            URLConstant.Param.EMAIL_OTP: Tf_Verify.text!,
            ] as [String : Any]
        
        // MARK:URLConstant.API.SIGN_EMAILVERIFY Class in api name and params...(user  SIGN_EMAILVERIFY  api)
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.SIGN_EMAILVERIFY,view: self.view, params: params, success: { (response) in
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK"
                    {
                        LoderGifView.MyloaderHide(view: self.view)
                        let alert = UIAlertController(title: "", message: (json.value(forKey: "message") as? String)!, preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                            LoderGifView.MyloaderShow(view: self.view)
                            self.callLoginAPI()

                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        LoderGifView.MyloaderHide(view: self.view)
                        UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                    }
                }
            }
        }) { (error) in
            LoderGifView.MyloaderHide(view: self.view)
            print(error.localizedDescription)
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
   
    
    // MARK: API callResendOtp
    func callResendOtp() {
        LoderGifView.MyloaderShow(view: self.view)
        let params = [
            URLConstant.Param.EMAIL:Str_Email as String,
            ] as [String : Any]
        
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.RESEND_OTP,view: self.view, params: params, success: { (response) in
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK"
                    {
                        LoderGifView.MyloaderHide(view: self.view)
                        UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                    }
                    else {
                        LoderGifView.MyloaderHide(view: self.view)
                        UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                    }
                }
            }
        }) { (error) in
            LoderGifView.MyloaderHide(view: self.view)
            print(error.localizedDescription)
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
    
    
    // MARK: API Calls callLoginAPI
    func callLoginAPI() {
        let params = [
            URLConstant.Param.EMAIL: Str_Email as String,
            URLConstant.Param.PASSWORD: Str_password ?? "" ,
            URLConstant.Param.DEVICETYPE: "Iphone",
            URLConstant.Param.DEVICEID: PreferenceUtil.getUserdevicetoken()
        ]  as [String : Any]
        // MARK:URLConstant.API.SIGN_IN Class in api name and params...(user login api)
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.SIGN_IN,view: self.view , params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let data = json.value(forKey: "user_info") as! NSDictionary
                        print(data)
                        let user = User()
                        if let id = data.value(forKey:"id") as? String, Int(id) != nil {user.id = Int(id)!}
                        if let name = data.value(forKey:"name") as? String {user.name = name}
                        if let lastname = data.value(forKey:"lastname") as? String {user.lastname = lastname}
                        if let token = json.value(forKey:"auth_token") as? String {user.token = token}
                        if let password = self.Str_password {user.password = password}
                        
                        if let profileimg = data.value(forKey:"profile_pic") {user.profilepic = profileimg as! String}
                        
                        user.email = self.Str_Email as String
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
    
    
    @IBAction func back(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension Signup_VerifyVc:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == Tf_Verify {
            moveTextField(textField, moveDistance: -60, up: true)
        }
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == Tf_Verify {
            moveTextField(textField, moveDistance: -60, up: false)
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
