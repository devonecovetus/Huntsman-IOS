//
//  ProfileStep2_VC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 05/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class ProfileStep2_VC: UIViewController,UIGestureRecognizerDelegate {

    // iboutlet here
    @IBOutlet weak var img_bg: UIImageView?
    @IBOutlet weak var btnSelectIndstry: UIButton!
    @IBOutlet weak var tfJobTitle: UITextField!
    @IBOutlet weak var tfCompanyName: UITextField!
    
    var Industy_Id = ""
    var Industy_Title = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (Device.IS_IPHONE_X){ //iPhone X
            img_bg?.image = UIImage(named:"step-bg-x.png")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileStep2_VC.CategoryReceivedNotification), name: NSNotification.Name(rawValue: "NotificationCategory"), object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    // ---- catch notificationcenter
    @objc func CategoryReceivedNotification(notification: NSNotification) {
        let myDict = notification.object as? [String: Any]
        
        Industy_Id = (myDict! ["SubCategoryId"] as? String)!
        Industy_Title = (myDict! ["SubCategoryTitle"] as? String)!
        
        btnSelectIndstry.setTitleColor(UIColor.white, for: .normal)
        btnSelectIndstry.setTitle(Industy_Title, for: .normal)
    }
    
    // MARK: Helper Methods
    func isValidInput() -> Bool {
        var errorMessage = ""
        var isValid = true
        
        if let textindustry = btnSelectIndstry.titleLabel?.text, textindustry == "SELECT INDUSTRY" {
            errorMessage = "Please select industry"
            isValid = false
            UIUtil.showMessage(title: "", message: errorMessage, controller: self, okHandler: nil)
        } else if let jobtitle = tfJobTitle.text, jobtitle.isEmpty {
            errorMessage = "Job title required"
            isValid = false
            UIUtil.showMessage(title: "", message: errorMessage, controller: self, okHandler: nil)
        } else if let companyname = tfCompanyName.text, companyname.isEmpty {
            errorMessage = "Company name required"
            isValid = false
            UIUtil.showMessage(title: "", message: errorMessage, controller: self, okHandler: nil)
        }

        return isValid
    }
    
    // MARK: IBActions
    @IBAction func nextClick(sender: AnyObject?){
        if isValidInput() {
            LoderGifView.MyloaderShow(view: view)
            callLoginAPI()
        }
    }
   
    // MARK: API Calls
    func callLoginAPI() {
  
        let params = [
            URLConstant.Param.INDUSTRYID: Industy_Id,
            URLConstant.Param.INDUSTRYTITLE: Industy_Title,
            URLConstant.Param.JOBTITLE: tfJobTitle.text!,
            URLConstant.Param.COMPANYNAME: tfCompanyName.text!
        ]
        // MARK: URLConstant.API.PROFILE_STEP1 class in base url with api name and params..
        // update profile step one 
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.PROFILE_STEP1,view:self.view , params: params as Any as? [String : Any], success: { (response) in
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let profile = storyBoard.instantiateViewController(withIdentifier: "ProfileStep3_VC") as! ProfileStep3_VC
                        self.navigationController?.pushViewController(profile, animated: true)
                    }
                    else {
                        // parsing status error
                        if let msg = json.value(forKey:"message") as? String, msg == "Invalid auth token."{
                            UIUtil.showLogout(title: "", message:"It seems you logged-in on other device with same user. To continue with same device please log-in again.", controller: self, okHandler: nil)
                        } else {
                            UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                        }
                    }
                    LoderGifView.MyloaderHide(view: self.view)
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
        // Dispose of any resources that can be recreated.
    }
    
}

extension ProfileStep2_VC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if Device.IS_IPHONE_X{
            if textField == tfJobTitle {
                moveTextField(textField, moveDistance: -190, up: true)
            } else {
                moveTextField(textField, moveDistance: -240, up: true)
            }
        } else{
            if textField == tfJobTitle {
                moveTextField(textField, moveDistance: -150, up: true)
            } else {
                moveTextField(textField, moveDistance: -180, up: true)
            }
        }
    }

    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        if Device.IS_IPHONE_X{
            if textField == tfJobTitle {
                moveTextField(textField, moveDistance: -190, up: false)
            } else {
                moveTextField(textField, moveDistance: -240, up: false)
            }
        }else{
            if textField == tfJobTitle {
                moveTextField(textField, moveDistance: -150, up: false)
            } else {
                moveTextField(textField, moveDistance: -180, up: false)
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
