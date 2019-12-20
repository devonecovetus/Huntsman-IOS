//
//  SignupStep4_VC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 14/07/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class SignupStep4_VC: UIViewController {
    
    @IBOutlet weak var lbl_UserName:UILabel!
    @IBOutlet weak var lbl_Email:UILabel!
    @IBOutlet weak var lbl_Address:UILabel!
    @IBOutlet weak var lbl_Dob:UILabel!
    @IBOutlet weak var img_bg: UIImageView?
    @IBOutlet weak var Btn_CreateAccount: UIButton!


    var locationFlage = ""
    
    var Street = ""
    var city = ""
    var state = ""
    var zipcode = ""
    var country = ""
    var Fulladdress = ""
    var latitude = ""
    var logitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (Device.IS_IPHONE_X){ //iPhone X
            img_bg?.image = UIImage(named:"step-bg-x.png")
        }
        lbl_Email.text = SignupStep2_Struct.Struct_Useremail as String
        lbl_Address.text = Fulladdress  as String
        lbl_Dob.text = SignupStep2_Struct.Struct_Dob as String
        
        Btn_CreateAccount.titleLabel?.minimumScaleFactor = 0.5
        Btn_CreateAccount.titleLabel?.adjustsFontSizeToFitWidth = true

        
    }

    override func viewDidLayoutSubviews() {
        lbl_UserName.text = "WELCOME " +  (SignupStep2_Struct.Struct_firstname as String).uppercased()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: IBActions
    @IBAction func Signup_Action(sender: AnyObject?){
          callSignup()
    }
    
    // MARK: API Calls Signup
    func callSignup() {
        LoderGifView.MyloaderShow(view: self.view)
        let params = [
            URLConstant.Param.USER_FIRSTNAME: SignupStep2_Struct.Struct_firstname as String,
            URLConstant.Param.USER_LASTTNAME: SignupStep2_Struct.Struct_lastname as String,
            URLConstant.Param.EMAIL: SignupStep2_Struct.Struct_Useremail as String,
            URLConstant.Param.PASSWORD:  SignupStep2_Struct.Struct_Password as String,
            URLConstant.Param.SIGNUP_DOB:  SignupStep2_Struct.Struct_Dob as String,
            URLConstant.Param.ADDRESS: Fulladdress  as String,
            URLConstant.Param.STREET: Street,
            URLConstant.Param.CITY: city,
            URLConstant.Param.STATE: state,
            URLConstant.Param.ZIPCODE: zipcode,
            URLConstant.Param.COUNTRY: country,
            URLConstant.Param.USER_LATI: latitude,          
            URLConstant.Param.USER_LONGI: logitude,
            ] as [String : Any]
       
        // MARK:URLConstant.API.SIGNUP Class in api name and params...(user SIGNUP api)
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.SIGN_UP,view: self.view, params: params, success: { (response) in
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK"
                    {
                        LoderGifView.MyloaderHide(view: self.view)
                        let alert = UIAlertController(title: "", message: (json.value(forKey: "message") as? String)!, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let Signup_Verify = storyBoard.instantiateViewController(withIdentifier: "Signup_VerifyVc") as! Signup_VerifyVc
                            Signup_Verify.Str_Flage = "SignupStep4_VC"
                            Signup_Verify.Str_Email = SignupStep2_Struct.Struct_Useremail as String
                            Signup_Verify.Str_password = SignupStep2_Struct.Struct_Password as String

                            self.navigationController?.pushViewController(Signup_Verify, animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        LoderGifView.MyloaderHide(view: self.view)

                        let alert = UIAlertController(title: "", message: "Mail address already exists, please choose another one.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                            
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: SignupStep2_VC.self) {
                                    self.navigationController!.popToViewController(controller, animated: false)
                                    break
                                }
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
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
}
