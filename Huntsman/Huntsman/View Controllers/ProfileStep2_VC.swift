//
//  ProfileStep2_VC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 05/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class ProfileStep2_VC: UIViewController,UIGestureRecognizerDelegate {

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
    @objc func CategoryReceivedNotification(notification: NSNotification)
    {
        let myDict = notification.object as? [String: Any]
        
        Industy_Id = (myDict! ["SubCategoryId"] as? String)!
        Industy_Title = (myDict! ["SubCategoryTitle"] as? String)!
        
        btnSelectIndstry.setTitleColor(UIColor.white, for: .normal)
        btnSelectIndstry.setTitle(Industy_Title, for: .normal)
    }
    
    // MARK: Helper Methods validation
    func isValidInput() -> Bool {
        var errorMessage = ""
        var isValid = true
        
        if let textindustry = btnSelectIndstry.titleLabel?.text, textindustry == "SELECT INDUSTRY" {
            errorMessage = "Please select industry"
            isValid = false
            UIUtil.showMessage(title: "Alert!", message: errorMessage, controller: self, okHandler: nil)
        } else if let jobtitle = tfJobTitle.text, jobtitle.isEmpty {
            errorMessage = "Job title required"
            isValid = false
            UIUtil.showMessage(title: "Alert!", message: errorMessage, controller: self, okHandler: nil)
        } else if let companyname = tfCompanyName.text, companyname.isEmpty {
            errorMessage = "Company name required"
            isValid = false
            UIUtil.showMessage(title: "Alert!", message: errorMessage, controller: self, okHandler: nil)
        }

        return isValid
    }
    
    // MARK: IBActions
    @IBAction func nextClick(sender: AnyObject?){
        if isValidInput() {
            LoderGifView.MyloaderShow(view: view)
            callProfileStep1API()
        }
    }
   
    // MARK: API Calls
    func callProfileStep1API() {
  
        let params = [
            URLConstant.Param.INDUSTRYID: Industy_Id,
            URLConstant.Param.INDUSTRYTITLE: Industy_Title,
            URLConstant.Param.JOBTITLE: tfJobTitle.text!,
            URLConstant.Param.COMPANYNAME: tfCompanyName.text!
        ]
        
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
                        UIUtil.showMessage(title: "Alert!", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                    }
                    LoderGifView.MyloaderHide(view: self.view)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            LoderGifView.MyloaderHide(view: self.view)
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
        }
        else{
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
