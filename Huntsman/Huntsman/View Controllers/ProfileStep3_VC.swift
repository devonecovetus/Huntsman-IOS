//
//  ProfileStep3_VC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 09/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class ProfileStep3_VC: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var img_bg: UIImageView?
    @IBOutlet weak var btnSelectYourInterest: UIButton!
    
    var Interest_Id = ""
    var Interest_Title = ""
    var Interest_TitleZero = ""
    var Interest_count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        btnSelectYourInterest.titleLabel?.minimumScaleFactor = 0.5
        btnSelectYourInterest.titleLabel?.adjustsFontSizeToFitWidth = true

        if (Device.IS_IPHONE_X){ //iPhone X
            img_bg?.image = UIImage(named:"step-bg-x.png")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileStep3_VC.InterestReceivedNotification), name: NSNotification.Name(rawValue: "NotificationInterest"), object: nil)
    }
    
    // --- action interestbutton
    @IBAction func selectInterestClick(sender: AnyObject?){
        // Safe Present
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Table_VC") as?Table_VC
        {
            if Interest_Id.isEmpty || Interest_Id == ""{
            }else{
                vc.InterestPassedTitle = Interest_Title
                vc.InterestPassedId = Interest_Id
            }
            present(vc, animated: true, completion: nil)
        }
    }
  
    // catch notification center
    @objc func InterestReceivedNotification(notification: NSNotification)
    {
        let myDict = notification.object as? [String: Any]
        
        Interest_Id = (myDict! ["InterestId"] as? String)!
        Interest_Title = (myDict! ["InterestTitle"] as? String)!
        Interest_count = myDict! ["InterestCount"] as! Int
        Interest_TitleZero = (myDict! ["ZeroInterest"] as? String)!
        
        selectinterest()
    }
    
    func selectinterest() {
        
        if Interest_count == 0 {
            btnSelectYourInterest.setTitle("SELECT YOUR INTERESTS",for: .normal)
            return
        }
        else{
            btnSelectYourInterest.setTitleColor(UIColor.white, for: .normal)
            if Interest_count == 1 {
                btnSelectYourInterest.setTitle(Interest_Title,for: .normal)
            }
            else{
                Interest_TitleZero = Interest_TitleZero + " & " + String(Interest_count - 1) + " more"
                btnSelectYourInterest.setTitle(Interest_TitleZero,for: .normal)
            }
        }
    }
    
    // MARK: IBActions
    @IBAction func nextClick(sender: AnyObject?){
        if isValidInput() {
            LoderGifView.MyloaderShow(view: view)
            callProfileStep2API()
        }
    }
    
    // MARK: API Calls
    func callProfileStep2API() {
        
        let params = [
            URLConstant.Param.INTERESTID: Interest_Id,
            URLConstant.Param.INTERESTTITLE: Interest_Title
        ]
        
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.PROFILE_STEP2,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        LoderGifView.MyloaderHide(view: self.view)
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let profile = storyBoard.instantiateViewController(withIdentifier: "ProfileStep4_VC") as! ProfileStep4_VC
                        self.navigationController?.pushViewController(profile, animated: true)
                    }
                    else {
                        LoderGifView.MyloaderHide(view: self.view)
                        // parsing status error
                        UIUtil.showMessage(title: "Alert!", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            LoderGifView.MyloaderHide(view: self.view)
        }
    }
    
    // MARK: Helper Methods validation
    func isValidInput() -> Bool {
        var errorMessage = ""
        var isValid = true
        
        if let textindustry = btnSelectYourInterest.titleLabel?.text, textindustry == "SELECT YOUR INTERESTS" {
            errorMessage = "Please select your interests"
            isValid = false
            UIUtil.showMessage(title: "Alert!", message: errorMessage, controller: self, okHandler: nil)
        } else if Interest_count < 3 {
            errorMessage = "Please select at-least 3 interests"
            isValid = false
            UIUtil.showMessage(title: "Alert!", message: errorMessage, controller: self, okHandler: nil)
        }
        
        return isValid
    }
    
    @IBAction func back(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

