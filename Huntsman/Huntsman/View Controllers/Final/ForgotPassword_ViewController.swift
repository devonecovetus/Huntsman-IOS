//
//  ForgotPassword_ViewController.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 01/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class ForgotPassword_ViewController: UIViewController {
    
    @IBOutlet weak var img_bg: UIImageView?
    @IBOutlet weak var ypostion : NSLayoutConstraint!
    @IBOutlet weak var tf_useremail: UITextField!
    @IBOutlet var baseview_sapceconstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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

    // MARK: Helper Methods validations
    func isValidInput() -> Bool {
        var errorMessage = ""
        var isValid = true
        
        if let text = tf_useremail.text, text.isEmpty || !ValidationUtil.isValidEmail(testStr: text) {
            errorMessage = "Invalid Email"
            isValid = false
            UIUtil.showMessage(title: "", message: errorMessage, controller: self, okHandler: nil)
        }
        return isValid
    }

    // MARK: IBActions
    @IBAction func forgotpasswordClick(sender: AnyObject?){
        if isValidInput() {
            view.endEditing(true)
            LoderGifView.MyloaderShow(view: view)
            callForgotAPI()
        }
    }

    // MARK: API callForgotAPI
    func callForgotAPI() {
        let params = [
            URLConstant.Param.EMAIL: tf_useremail.text!,
        ]
        // MARK: URLConstant.API.FORGOT_PASSWORD class in api name and params ...(Forget password)
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.FORGOT_PASSWORD,view: self.view ,params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        LoderGifView.MyloaderHide(view: self.view)
                        UIUtil.showMessage(title: "Huntsman...", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                    }
                    else {
                        // parsing status error
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

    @IBAction func back(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ForgotPassword_ViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
