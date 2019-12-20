//
//  ProfileStep4_VC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 10/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class ProfileStep4_VC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var img_bg: UIImageView?
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var img_profile: UIImageView!
    
    var profilepic_base64 : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        PreferenceUtil.saveProfileComplete(string:"yes")

        if (Device.IS_IPHONE_X){ //iPhone X
            img_bg?.image = UIImage(named:"step-bg-x.png")
        }
        
        var Name = PreferenceUtil.getUser().name
        Name = Name.replacingOccurrences(of: " ", with: "")
        var fullName = ""
        var LastName = PreferenceUtil.getUser().lastname
        LastName = LastName.replacingOccurrences(of: " ", with: "")
        if LastName == "" {
            fullName = Name
        } else {
            fullName = Name + " " + LastName
        }

        let arrname = fullName.components(separatedBy: " ")
        var lettername = ""
        
        for var string in arrname{
            string = String(Array(string)[0])
            lettername = lettername + string
        }
        lb_name.text = lettername.uppercased()
    }
    
    @IBAction func Action_profilePic(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Profile pic", message: nil, preferredStyle: .actionSheet)
        
        let cameraButton = UIAlertAction(title: "Take a New Profile pic" , style: .default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        let  galleryButton = UIAlertAction(title: "Select Photo from Gallery", style: .default, handler: { (action) -> Void in
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(cameraButton)
        alertController.addAction(galleryButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])  {
        img_profile.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let imageData = UIImageJPEGRepresentation(img_profile.image!, 0.25)! as NSData
        profilepic_base64 = imageData.base64EncodedString(options: .lineLength64Characters)
        callLoginAPI()
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func callLoginAPI() {
        
        let params = [
            URLConstant.Param.PROFILEPIC: profilepic_base64
        ]
        // URLConstant.API.PROFILE_STEP3 in Base url with api name and params .(for profile pic upload)
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.PROFILE_STEP3,view: self.view , params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let user = User()

                        let tokenn = PreferenceUtil.getUser().token
                        let id = PreferenceUtil.getUser().id
                        let name = PreferenceUtil.getUser().name
                        let lastname = PreferenceUtil.getUser().lastname
                        let email = PreferenceUtil.getUser().email
                        let password = PreferenceUtil.getUser().password
                        
                        user.token = tokenn
                        user.id = id
                        user.name = name
                        user.lastname = lastname
                        user.email = email
                        user.password = password

                        if let profileimg = json.value(forKey:"image") {user.profilepic = profileimg as! String}
                        PreferenceUtil.saveUser(user: user)
                    }  else {
                        if let msg = json.value(forKey:"message") as? String, msg == "Invalid auth token."{
                            UIUtil.showLogout(title: "", message:"It seems you logged-in on other device with same user. To continue with same device please log-in again.", controller: self, okHandler: nil)
                        } 
                    }
                }
            }
           
        }) { (error) in
            print(error.localizedDescription)
            if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)" {
                UIUtil.showMessage(title: "No Internet Connection", message:"Make sure your device is connected to the internet.", controller: self, okHandler: nil)
            }  else {
                UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
            }
        }
        
    }
    
    @available(iOS 10.0, *)
    @IBAction func Action_discover(_ sender: UIButton) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.rootview_views(string: "discover")
    }
    
    @available(iOS 10.0, *)
    @IBAction func Action_profile(_ sender: UIButton) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.rootview_views(string: "profile")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
