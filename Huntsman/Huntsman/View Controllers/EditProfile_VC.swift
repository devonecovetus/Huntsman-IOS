//
//  EditProfile_VC.swift
//  Huntsman
//  Created by Rupesh Chhabra on 28/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.

import UIKit
import ActionSheetPicker_3_0

class EditProfile_VC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var data_profileinfo = [:] as NSDictionary
    
    var Interest_Id = ""
    var Interest_Title = ""
    var Industy_Id = ""
    var Industy_Title = ""

    var Interest_TitleZero = ""
    var Interest_count = 0
    var profilepic_base64 : String = ""

    @IBOutlet weak var Image_view: UIImageView!
    @IBOutlet weak var Btn_Count: UIButton!

    @IBOutlet weak var Tf_FirstName: UITextField!
    @IBOutlet weak var Tf_LastName: UITextField!
    @IBOutlet weak var Tf_Email: UITextField!
    @IBOutlet weak var Tf_ContactNo: UITextField!
    
    @IBOutlet weak var Tf_JobTitle: UITextField!
    @IBOutlet weak var Tf_CompanyName: UITextField!
    @IBOutlet weak var Tf_Place: UITextField!
    @IBOutlet weak var Tv_About: UITextView!
    
    @IBOutlet weak var Btn_Industry: UIButton!
    @IBOutlet weak var Btn_Birthday: UIButton!
    @IBOutlet weak var btnSelectYourInterest: UIButton!
    
    @IBOutlet weak var Lbl_Since: UILabel!
    @IBOutlet weak var lbl_name: UILabel!

    @IBOutlet weak var ViewInterestHeight: NSLayoutConstraint!
    
    @IBOutlet weak var View_About: UIView!
    @IBOutlet weak var View_Profession: UIView!
    @IBOutlet weak var View_Interest: UIView!
    @IBOutlet weak var View_SelectInterest: UIView!

    @IBOutlet weak var View_More: UIView!
    
    var InterestList = [] as NSArray
    var IntXAxis:Int = 0
    var IntYAxis:Int = 0
    var label = UILabel()
    var str_dobsend = ""
    
    var callupdatebackedit :(()->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(data_profileinfo)
        setBottomBorder(TextField:Tf_FirstName)
        setBottomBorder(TextField:Tf_LastName)
        setBottomBorder(TextField:Tf_Email)
        setBottomBorder(TextField:Tf_ContactNo)
        setBottomBorder(TextField:Tf_JobTitle)
        setBottomBorder(TextField:Tf_CompanyName)
        setBottomBorder(TextField:Tf_Place)
        
        setBottomBorder(Button:Btn_Industry)
        setBottomBorder(Button:Btn_Birthday)
        setBottomBorder(Button:btnSelectYourInterest)
        
        addToolBar(textField: Tf_ContactNo)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileStep3_VC.InterestReceivedNotification), name: NSNotification.Name(rawValue: "NotificationInterest"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileStep2_VC.CategoryReceivedNotification), name: NSNotification.Name(rawValue: "NotificationCategory"), object: nil)

        let color = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
        Tv_About.layer.borderColor = color
        Tv_About.layer.borderWidth = 0.5

        View_About = UIUtil.dropShadow(view: View_About, color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        View_Profession = UIUtil.dropShadow(view: View_Profession, color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        View_Interest = UIUtil.dropShadow(view: View_Interest, color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        View_More = UIUtil.dropShadow(view: View_More, color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        
       
        if data_profileinfo.count == 0  {
        }  else {
      
        if let profile_pic = data_profileinfo.value(forKey:"profile_pic") as? String, profile_pic != "" {
            self.Image_view.sd_setImage(with: URL(string: profile_pic), placeholderImage: UIImage(named: "no image"))
        }else {
            self.Image_view.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "no image"))
        }
        
        if let lastname = data_profileinfo.value(forKey:"lastname") as? String {
            self.lbl_name.text = ((data_profileinfo.value(forKey:"name") as? String)?.uppercased())! + " " + (lastname.uppercased())
            Tf_LastName.text = (data_profileinfo.value(forKey: "lastname") as! String)
        } else{
            self.lbl_name.text = ((data_profileinfo.value(forKey:"name") as? String)?.uppercased())!
            Tf_LastName.text = ""
        }
        
        Tf_FirstName.text = (data_profileinfo.value(forKey: "name") as! String)
        
        Tf_Email.text = (data_profileinfo.value(forKey: "email") as! String)

        if let contact = data_profileinfo.value(forKey:"contact_no") as? String {
            Tf_ContactNo.text = contact
        }  else {
            Tf_ContactNo.text = ""
        }

        Tf_Place.text = (data_profileinfo.value(forKey: "address") as! String)
        
        Interest_Id = (data_profileinfo.value(forKey: "interest_id") as! String)
        print(Interest_Id)
     
        Interest_Title = (data_profileinfo.value(forKey: "interest") as! String)
        print(Interest_Title)
        
        Industy_Id = (data_profileinfo.value(forKey: "industry_id") as! String)
        Industy_Title = (data_profileinfo.value(forKey: "industry_title") as! String)

        if let Str_about = data_profileinfo.value(forKey:"about") as? String, Str_about != "" {
            Tv_About.text = Str_about
            Tv_About.textColor = UIColor.black
        } else {
            Tv_About.textColor = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1.0)
            Tv_About.text = "About me..."
        }
        Tf_JobTitle.text = (data_profileinfo.value(forKey: "job_title") as! String)
        Tf_CompanyName.text = (data_profileinfo.value(forKey: "company") as! String)
        
        if let Str_Birthday = data_profileinfo.value(forKey:"dob") as? String, Str_Birthday != "" {
            str_dobsend = Str_Birthday
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if formatter.date(from: Str_Birthday) != nil  {
                let date = formatter.date(from: Str_Birthday)
                formatter.dateFormat = "dd MMM yyyy"
                let result = formatter.string(from: date!)
                self.Btn_Birthday.setTitle("       " + result, for: .normal)
            } else {
                self.Btn_Birthday.setTitle("       " , for: .normal)
            }
        }
        
        if let Str_industry_title = data_profileinfo.value(forKey:"industry_title") as? String, Str_industry_title != "" {
            Btn_Industry.setTitle(Str_industry_title, for: UIControlState.normal)
        }
        
            let dateStr = (data_profileinfo.value(forKey: "joining_date") as! String)
            let dateFmt = DateFormatter()
            dateFmt.timeZone = NSTimeZone.default
            dateFmt.dateFormat =  "yyyy-MM-dd  HH:mm:ss"
            if dateFmt.date(from: dateStr) != nil {
                let date = dateFmt.date(from: dateStr)
                let year = Calendar.current.component(.year, from: date!)
                Lbl_Since.text = String(year)
            } else {
                Lbl_Since.text = ""
            }
            Interest_Create(Str_Intrestlist: (data_profileinfo.value(forKey:"interest")  as! NSString))
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.Btn_Count.setTitle("\(DiscoverNotificationCount.NotificationCount)", for: .normal)
    }
    
   // interest creatation
    func Interest_Create(Str_Intrestlist : NSString) {
        for subView in View_SelectInterest.subviews {
            subView.removeFromSuperview()
        }
        
        self.InterestList = Str_Intrestlist.components(separatedBy: ",") as NSArray
        self.IntXAxis = 0
        self.IntYAxis = 5
        Interest_count = Int(self.InterestList.count)
        
        for (index, element) in self.InterestList.enumerated() {
            
            if let font = UIFont(name: "GillSansMT", size: 14) {
                
                let fontAttributes = [NSAttributedStringKey.font: font]
                let myText = element
                let size = (myText as! NSString).size(withAttributes: fontAttributes)
                
                let constraintRect = CGSize(width: Device.SCREEN_WIDTH - 20, height: 10000)
                let boundingBox = (element as AnyObject).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
                
                var IntWidth = Int(size.width + 20)
                if(IntWidth > Device.SCREEN_WIDTH - 20) {
                    IntWidth = Device.SCREEN_WIDTH - 20
                }
                
                if (self.IntXAxis + Int(boundingBox.width + 20) > Device.SCREEN_WIDTH - 20) {
                    self.IntYAxis = self.IntYAxis + Int(boundingBox.height + 20)
                    print("YXisInner\(self.IntYAxis)")
                    self.IntXAxis = 0
                }
                
                self.label = UILabel(frame: CGRect(x: self.IntXAxis, y: self.IntYAxis, width: IntWidth, height: Int(boundingBox.height+10)))
                self.label.text = (myText as! String)
                self.label.font = UIFont(name: "GillSansMT" , size: 13)
                self.label.tag = 100 + index
                
                self.label.textColor = UIColor.black
                self.label.textAlignment = .center
                
                self.label.numberOfLines = 0
                self.label.lineBreakMode = NSLineBreakMode.byWordWrapping
                self.label.layer.masksToBounds = true
                self.label.layer.cornerRadius = CGFloat(self.label.frame.size.height/2)
                self.label.layer.borderWidth = 0.5
                self.label.layer.borderColor = UIColor.lightGray.cgColor
                
                self.IntXAxis = Int(self.label.frame.origin.x + self.label.frame.size.width + 5)
                
                if ((self.IntXAxis + Int(boundingBox.width)) > Device.SCREEN_WIDTH - 20) {
                    self.IntXAxis = 0
                    self.IntYAxis = self.IntYAxis + Int(boundingBox.height + 20)
                }
                self.View_SelectInterest.addSubview(self.label)
            }
        }
        
        self.ViewInterestHeight.constant = self.label.frame.origin.y + self.label.frame.size.height + 10
    }
    
    @objc func CategoryReceivedNotification(notification: NSNotification) {
        print(notification)
        let myDict = notification.object as? [String: Any]
        Industy_Id = (myDict! ["SubCategoryId"] as? String)!
        Industy_Title = (myDict! ["SubCategoryTitle"] as? String)!
        
        Btn_Industry.setTitle(Industy_Title, for: .normal)
    }
    
    //----
    @objc func InterestReceivedNotification(notification: NSNotification) {
        let myDict = notification.object as? [String: Any]
        Interest_Id = (myDict! ["InterestId"] as? String)!
        Interest_Title = (myDict! ["InterestTitle"] as? String)!
        Interest_count = myDict! ["InterestCount"] as! Int
        Interest_TitleZero = (myDict! ["ZeroInterest"] as? String)!
        Interest_Create(Str_Intrestlist: Interest_Title as NSString)
    }
    
    //-----
    @IBAction func Action_UpdateProfile(_ sender: Any) {
        if isValidInput() {
            callLoginAPI()
        }
    }
    
    func callLoginAPI() {
        LoderGifView.MyloaderShow(view: self.view)
        if  Tv_About.text == "About me..." {
            Tv_About.text = ""
        }
        
        let params = [
            URLConstant.Param.USER_FIRSTNAME:Tf_FirstName.text!,
            URLConstant.Param.USER_LASTTNAME:Tf_LastName.text!,
            URLConstant.Param.CONTACTNO:Tf_ContactNo.text!,
            URLConstant.Param.USERABOUT:Tv_About.text!,
            URLConstant.Param.USER_DOB:str_dobsend,
            URLConstant.Param.PROFILEPIC :profilepic_base64,
            URLConstant.Param.INDUSTRYID : Industy_Id,
            URLConstant.Param.INDUSTRYTITLE : Industy_Title,
            URLConstant.Param.JOBTITLE :Tf_JobTitle.text!,
            URLConstant.Param.COMPANYNAME : Tf_CompanyName.text!,
            URLConstant.Param.INTERESTID : Interest_Id,
            URLConstant.Param.INTERESTTITLE : Interest_Title
        ]

        WebserviceUtil.callPost(jsonRequest: URLConstant.API.USER_PROFILE_UPDATE,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        LoderGifView.MyloaderHide(view: self.view)
                        self.callupdatebackedit?()
                        
                        let tokenn = PreferenceUtil.getUser().token
                        let password = PreferenceUtil.getUser().password

                        let data = json.value(forKey: "user_info") as! NSDictionary
                        let user = User()
                        if let id = data.value(forKey:"id") as? String, Int(id) != nil {user.id = Int(id)!}
                        if let name = data.value(forKey:"name") as? String {user.name = name}
                        if let lastname = data.value(forKey:"lastname") as? String {user.lastname = lastname}
                        user.token = tokenn
                        user.password = password

                        if let profileimg = data.value(forKey:"profile_pic") {user.profilepic = "https://clubappadmin.huntsmansavilerow.com/profile_pics/" + (profileimg as! String)}
                        if let email = data.value(forKey:"email") as? String {user.email = email}
                        
                        PreferenceUtil.saveUser(user: user)
                        
                        let alertController = UIAlertController(title: "Huntsman", message: (json.value(forKey: "message") as? String)!, preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
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
   
    @IBAction func selectInterestClick(sender: AnyObject?){
     // Safe Present
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Table_VC") as?Table_VC {
            if Interest_Id.isEmpty || Interest_Id == ""{
            }else{
                vc.InterestPassedTitle = Interest_Title
                vc.InterestPassedId = Interest_Id
            }
            present(vc, animated: true, completion: nil)
        }
    }
    
    // MARK: Helper Methods
    func isValidInput() -> Bool {
        var errorMessage = ""
        var isValid = true
        
        if let text = Tf_FirstName.text, text.isEmpty  {
            errorMessage = "Please enter first name"
            isValid = false
            let alert = CustomAlert (title:"",Message:errorMessage)
            alert.show(animated: true)
        } else if let text = Tf_LastName.text, text.isEmpty  {
            errorMessage = "Please enter last name"
            isValid = false
            let alert = CustomAlert (title:"",Message:errorMessage)
            alert.show(animated: true)

        } else if let text = Tf_Place.text, text.isEmpty  {
            errorMessage = "Please enter place"
            isValid = false
            let alert = CustomAlert (title:"",Message:errorMessage)
            alert.show(animated: true)
        } else if let text = Tf_JobTitle.text, text.isEmpty  {
            errorMessage = "Please enter job title"
            isValid = false
            let alert = CustomAlert (title:"",Message:errorMessage)
            alert.show(animated: true)
        } else if let text = Tf_CompanyName.text, text.isEmpty  {
            errorMessage = "Please enter company name"
            isValid = false
            let alert = CustomAlert (title:"",Message:errorMessage)
            alert.show(animated: true)
        } else  if Interest_count < 3 {
            errorMessage = "Please select at-least 3 interests"
            isValid = false
            let alert = CustomAlert (title:"",Message:errorMessage)
            alert.show(animated: true)
        }
        return isValid
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
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        Image_view.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let imageData = UIImageJPEGRepresentation(Image_view.image!, 0.25)! as NSData
        profilepic_base64 = imageData.base64EncodedString(options: .lineLength64Characters)
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: IBActions
    @IBAction func birthdateClick(_ sender: UIButton) {
        
        ActionSheetDatePicker.show(withTitle: "Select Date", datePickerMode: .date, selectedDate: Date(), minimumDate: nil, maximumDate: Date(), doneBlock: { (sheet, value, index) in
            if let date = value as? Date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                self.str_dobsend = formatter.string(from: date)
                formatter.dateFormat = "dd MMM yyyy"
                let result = formatter.string(from: date)
                self.Btn_Birthday.setTitle("       " + result, for: .normal)
            }
        }, cancel: nil, origin: self.view)
    }
    
    func setBottomBorder(TextField: UITextField) {
        TextField.borderStyle = .none
        TextField.layer.backgroundColor = UIColor.white.cgColor
        TextField.layer.masksToBounds = false
        TextField.layer.shadowColor = UIColor.lightGray.cgColor
        TextField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        TextField.layer.shadowOpacity = 0.5
        TextField.layer.shadowRadius = 0.0
    }
    
    func setBottomBorder(Button: UIButton) {
        Button.layer.backgroundColor = UIColor.white.cgColor
        Button.layer.masksToBounds = false
        Button.layer.shadowColor = UIColor.lightGray.cgColor
        Button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        Button.layer.shadowOpacity = 0.5
        Button.layer.shadowRadius = 0.0
    }
    
    @IBAction func Action_notification(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "Notification_VC") as! Notification_VC
        present(profile, animated: true, completion: nil)
    }
    
    @IBAction func backClick(sender: AnyObject?){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EditProfile_VC:UITextFieldDelegate, UITextViewDelegate {
    // Textview Delegate Method
    func textViewDidBeginEditing(_ textView: UITextView) {
        if Tv_About.text == "About me..." {
            Tv_About.textColor = UIColor.black
            Tv_About.text = ""
        }
         moveTextView(textView, moveDistance: -70, up: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if Tv_About.text == "" {
            Tv_About.textColor = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1.0)
            Tv_About.text = "About me..."
        }
        moveTextView(textView, moveDistance: -70, up: false)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // Move the text field in a pretty animation!
    func moveTextView(_ textView: UITextView, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    // textfiled methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if textField == Tf_ContactNo {
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        return  newText.count <= 15
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if Device.IS_IPHONE_X{
            if textField == Tf_CompanyName {
                moveTextField(textField, moveDistance: -180, up: true)
            }
        } else{
            if textField == Tf_JobTitle {
                moveTextField(textField, moveDistance: -150, up: true)
            } else {
                moveTextField(textField, moveDistance: -180, up: true)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if Device.IS_IPHONE_X{
            if textField == Tf_CompanyName{
                moveTextField(textField, moveDistance: -180, up: false)
            }
        }else{
            if textField == Tf_JobTitle {
                moveTextField(textField, moveDistance: -150, up: false)
            } else {
                moveTextField(textField, moveDistance: -180, up: false)
            }
        }
    }
    
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }

    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    @objc func donePressed(){
        view.endEditing(true)
    }
  
}
