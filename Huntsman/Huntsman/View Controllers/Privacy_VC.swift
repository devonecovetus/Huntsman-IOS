//
//  Privacy_VC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 23/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class Privacy_VC: UIViewController,SWRevealViewControllerDelegate {
    
    @IBOutlet weak var Btn_Menu: UIButton!
    @IBOutlet weak var Btn_ChangePassword: UIButton!

    @IBOutlet weak var lbl_ForLocation: UILabel!
    @IBOutlet weak var Lbl_ForWardrobe: UILabel!

    @IBOutlet weak var Btn_SginoutVerticalSpace: NSLayoutConstraint?
    @IBOutlet weak var toggle_huntsevent: UISwitch!
    @IBOutlet weak var toggle_userevent: UISwitch!
    @IBOutlet weak var toggle_both: UISwitch!

    @IBOutlet weak var toggle_location: UISwitch!
    
    @IBOutlet weak var toggle_wardrobe: UISwitch!

    @IBOutlet weak var Notify_Location: UISwitch!
    
    @IBOutlet weak var Btn_Count: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().delegate = self
        Btn_Menu.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents
            .touchUpInside)
        Btn_ChangePassword.layer.borderWidth = 1
        Btn_ChangePassword.layer.borderColor =  UIColor.lightGray.cgColor
        
        if Device.IS_IPHONE_5 {
            
        } else {
            Btn_SginoutVerticalSpace?.constant = 20 
        }
        
        Call_AllsettingAPI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.Btn_Count.setTitle("\(DiscoverNotificationCount.NotificationCount)", for: .normal)
    }
    
    
    func Call_AllsettingAPI() {
        
        LoderGifView.MyloaderShow(view: view)
        /*ALLSETTING  Notification ,Wardrobe andm location setting*/
        WebserviceUtil.callGet(jsonRequest: URLConstant.API.ALLSETTING ,view:self.view, success: { (response) in
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        
                        LoderGifView.MyloaderHide(view: self.view)
                        let User_Setting = (json.value(forKey: "user_setting")  as! NSDictionary)
                        let msg_setting =  ((User_Setting as AnyObject).value(forKey: "msg_setting") as? String)!
                        if msg_setting == "0"{
                            
                            self.toggle_huntsevent.isOn = false
                            self.toggle_userevent.isOn = false
                            self.toggle_both.isOn = false
                            
                        } else if msg_setting == "1"{
                            
                            self.toggle_huntsevent.isOn = true
                            self.toggle_userevent.isOn = true
                            self.toggle_both.isOn = true
                            
                        } else if msg_setting == "2"{
                            
                            self.toggle_huntsevent.isOn = false
                            self.toggle_userevent.isOn = true
                            self.toggle_both.isOn = false
                            
                        } else{
                            self.toggle_huntsevent.isOn = true
                            self.toggle_userevent.isOn = false
                            self.toggle_both.isOn = false
                        }
                        
                        let location_setting =  ((User_Setting as AnyObject).value(forKey: "location_setting") as? String)!
                        
                        if location_setting == "0"{
                            self.toggle_location.isOn = false
                            self.lbl_ForLocation.text = "YOUR LOCATION IS NOT VISIBLE TO OTHER MEMBERS"

                        } else {
                            self.toggle_location.isOn = true
                            self.lbl_ForLocation.text = "YOUR LOCATION IS VISIBLE TO OTHER MEMBERS"

                        }
                        
                        let wardrobe_setting =  ((User_Setting as AnyObject).value(forKey: "location_setting") as? String)!

                        if wardrobe_setting == "0"{
                            self.toggle_wardrobe.isOn = false
                            self.Lbl_ForWardrobe.text = "YOUR WARDROBE IS NOT VISIBLE TO OTHER MEMBERS"

                        } else {
                            self.toggle_wardrobe.isOn = true
                            self.Lbl_ForWardrobe.text = "YOUR WARDROBE IS VISIBLE TO OTHER MEMBERS"
                        }
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
            LoderGifView.MyloaderHide(view: self.view)
            print(error.localizedDescription)
            if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)" {
                UIUtil.showMessage(title: "No Internet Connection", message:"Make sure your device is connected to the internet.", controller: self, okHandler: nil)
            } else  {
                UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
            }
        }
    }
    
    @IBAction func action_huntsmanevent(_ sender: UISwitch) {
        
        if toggle_huntsevent.isOn{
             /// -- on
            if toggle_userevent.isOn == true && toggle_both.isOn == true {
                toggle_huntsevent.setOn(true, animated: true)
                Call_MsgSettingAPI(str_msg_setting:"1")
            } else if toggle_userevent.isOn == true && toggle_both.isOn == false {
                toggle_huntsevent.setOn(true, animated: true)
                toggle_both.setOn(true, animated: true)
                Call_MsgSettingAPI(str_msg_setting:"1")
            } else {
                toggle_huntsevent.setOn(true, animated: true)
                Call_MsgSettingAPI(str_msg_setting:"3")
            }
           
        } else {
            /// -- off
            if toggle_userevent.isOn == true && toggle_both.isOn == true {
                toggle_huntsevent.setOn(false, animated: true)
                toggle_both.setOn(false, animated: true)
                Call_MsgSettingAPI(str_msg_setting:"2")
            } else if toggle_userevent.isOn == true && toggle_both.isOn == false {
                toggle_huntsevent.setOn(false, animated: true)
                Call_MsgSettingAPI(str_msg_setting:"2")
            } else {
                toggle_huntsevent.setOn(false, animated: true)
                Call_MsgSettingAPI(str_msg_setting:"0")
            }
        }
        
    }
    
    @IBAction func action_userevent(_ sender: UISwitch) {
        
        if toggle_userevent.isOn{
            /// -- on
            if toggle_huntsevent.isOn == true && toggle_both.isOn == true {
                toggle_userevent.setOn(true, animated: true)
                Call_MsgSettingAPI(str_msg_setting:"1")
            } else if toggle_huntsevent.isOn == true && toggle_both.isOn == false {
                toggle_userevent.setOn(true, animated: true)
                toggle_both.setOn(true, animated: true)
                Call_MsgSettingAPI(str_msg_setting:"1")
            }  else {
                toggle_userevent.setOn(true, animated: true)
                Call_MsgSettingAPI(str_msg_setting:"2")
            }
            
        } else {
            /// -- off
            if toggle_huntsevent.isOn == true && toggle_both.isOn == true {
                toggle_userevent.setOn(false, animated: true)
                toggle_both.setOn(false, animated: true)
                Call_MsgSettingAPI(str_msg_setting:"3")
            } else if toggle_huntsevent.isOn == true && toggle_both.isOn == false {
                toggle_userevent.setOn(false, animated: true)
                Call_MsgSettingAPI(str_msg_setting:"3")
            } else {
                toggle_userevent.setOn(false, animated: true)
                Call_MsgSettingAPI(str_msg_setting:"0")
            }
        }
        
    }
    
    @IBAction func action_both(_ sender: UISwitch) {
        
        if toggle_both.isOn{
            /// -- on
            toggle_huntsevent.setOn(true, animated: true)
            toggle_userevent.setOn(true, animated: true)
            toggle_both.setOn(true, animated: true)
            Call_MsgSettingAPI(str_msg_setting:"1")
            
        } else {
            /// -- off
            toggle_huntsevent.setOn(false, animated: true)
            toggle_userevent.setOn(false, animated: true)
            toggle_both.setOn(false, animated: true)
            Call_MsgSettingAPI(str_msg_setting:"0")
        }
    }
    
    func apicall() {
        
        if toggle_huntsevent.isOn == true && toggle_userevent.isOn == true && toggle_both.isOn == true {
            Call_MsgSettingAPI(str_msg_setting:"1")
        }  else if toggle_huntsevent.isOn == true && toggle_userevent.isOn == false && toggle_both.isOn == false {
            Call_MsgSettingAPI(str_msg_setting:"3")
        }  else if toggle_huntsevent.isOn == false && toggle_userevent.isOn == true && toggle_both.isOn == false {
            Call_MsgSettingAPI(str_msg_setting:"2")
        } else if toggle_huntsevent.isOn == false && toggle_userevent.isOn == false && toggle_both.isOn == false {
            Call_MsgSettingAPI(str_msg_setting:"0")
        }
    }
    
    // MARK: API Calls
    func Call_MsgSettingAPI(str_msg_setting:NSString) {
        
        LoderGifView.MyloaderShow(view: self.view)
        let params = [
            URLConstant.Param.MSG_SETTING:str_msg_setting
        ]
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.MSGSETTING,view: self.view, params: params, success: { (response) in

            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK"  {
                        LoderGifView.MyloaderHide(view: self.view)
                    } else {
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
            if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)"  {
                UIUtil.showMessage(title: "No Internet Connection", message:"Make sure your device is connected to the internet.", controller: self, okHandler: nil)
            }  else  {
                UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
            }
        }
    }
    
    @IBAction func action_location(_ sender: UISwitch) {
        
        if toggle_location.isOn{
            /// -- on
            toggle_location.setOn(true, animated: true)
            Call_wardrobe_locationSettingAPI(setting_type: "location", str_setting: "1")
            self.lbl_ForLocation.text = "YOUR LOCATION IS VISIBLE TO OTHER MEMBERS"

        } else {
            /// -- off
            self.lbl_ForLocation.text = "YOUR LOCATION IS NOT VISIBLE TO OTHER MEMBERS"
            toggle_location.setOn(false, animated: true)
            Call_wardrobe_locationSettingAPI(setting_type: "location", str_setting: "0")
        }
    }
    
    @IBAction func action_wardrobe(_ sender: UISwitch) {
        
        if toggle_wardrobe.isOn{
            /// -- on
            toggle_wardrobe.setOn(true, animated: true)
            self.Lbl_ForWardrobe.text = "YOUR WARDROBE IS VISIBLE TO OTHER MEMBERS"
            Call_wardrobe_locationSettingAPI(setting_type: "wardrobe", str_setting: "1")
        } else {
            /// -- off
            toggle_wardrobe.setOn(false, animated: true)
            self.Lbl_ForWardrobe.text = "YOUR WARDROBE IS NOT VISIBLE TO OTHER MEMBERS"
            Call_wardrobe_locationSettingAPI(setting_type: "wardrobe", str_setting: "0")
        }
    }
 
    // MARK: API Calls
    func Call_wardrobe_locationSettingAPI(setting_type:NSString ,str_setting:NSString) {
        
        LoderGifView.MyloaderShow(view: self.view)
        
        let params = [
            URLConstant.Param.SETTING_TYPE:setting_type,
            URLConstant.Param.SETTING:str_setting
        ]
        
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.WARDROBE_LOCATIONSETTING,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        LoderGifView.MyloaderHide(view: self.view)
                    } else {
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
            if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)" {
                UIUtil.showMessage(title: "No Internet Connection", message:"Make sure your device is connected to the internet.", controller: self, okHandler: nil)
            } else {
                UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
            }
        }
    }
    
    @IBAction func Action_SignOut(_ sender: Any) {
        
        let alert = UIAlertController(title: "Huntsman", message: "Do you want to sign out?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: SignOutHandler))
        self.present(alert, animated: true, completion: nil)
    }
    //  App logout
    func SignOutHandler(alert: UIAlertAction!) {
        LoderGifView.MyloaderShow(view: view)
        WebserviceUtil.callGet(jsonRequest: URLConstant.API.USER_Logout ,view:self.view, success: { (response) in
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        LoderGifView.MyloaderHide(view: self.view)
                        let TokenSave = PreferenceUtil.getUserdevicetoken()
                        print(TokenSave)
                        let defaults = UserDefaults.standard
                        let dictionary = defaults.dictionaryRepresentation()
                        dictionary.keys.forEach { key in
                            defaults.removeObject(forKey: key)
                        }
                        print("Device Token: \(TokenSave)")
                        PreferenceUtil.saveUserdevicetoken(token: TokenSave)
                        let TokenSave1 = PreferenceUtil.getUserdevicetoken()
                        print(TokenSave1)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.Call_LoginScreen()
                    } else {
                        LoderGifView.MyloaderHide(view: self.view)
                    }
                }
            }
        }) { (error) in
            LoderGifView.MyloaderHide(view: self.view)
            print(error.localizedDescription)
        }
    }
    // Action notification screen
    @IBAction func Action_notification(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "Notification_VC") as! Notification_VC
        present(profile, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
