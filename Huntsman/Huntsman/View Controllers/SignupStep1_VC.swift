//
//  SignupStep1_VC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 14/07/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class SignupStep1_VC: UIViewController,UIImagePickerControllerDelegate {
    

    @IBOutlet weak var tf_FirstName: UITextField!
    @IBOutlet weak var tf_LastName: UITextField!
    @IBOutlet weak var Btn_Dob: UIButton!
    @IBOutlet weak var Tf_FirstnameCnstraint: NSLayoutConstraint!

    var  str_dobsend = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Device.IS_IPHONE_5
        {
            Tf_FirstnameCnstraint.constant = 100
        }
    }
    
    @IBAction func back(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
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
                self.Btn_Dob.setTitle( result, for: .normal)
                self.Btn_Dob.setTitleColor(UIColor(red: 0/255.0, green: 0/255.0, blue:0/255.0, alpha: 1.0), for: .normal)
            }
        }, cancel: nil, origin: self.view)
    }
    
    @IBAction func nextClick(sender: AnyObject?)
    {
        if isValidInput() {
            view.endEditing(true)
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let SignupStep2 = storyBoard.instantiateViewController(withIdentifier: "SignupStep2_VC") as! SignupStep2_VC
            SignupStep2.Str_username = tf_FirstName.text!
            SignupStep2.Str_lastname = tf_LastName.text!
            SignupStep2.Str_dob = (Btn_Dob.titleLabel?.text)!
            SignupStep2.Str_dobParams =  self.str_dobsend as String

            self.navigationController?.pushViewController(SignupStep2, animated: true)
        }
        
    }

    // MARK: Helper Methods validations
    func isValidInput() -> Bool {
        var errorMessage = ""
        var isValid = true
        if let password = tf_FirstName.text, password.isEmpty {
            errorMessage = "First Name Required"
            isValid = false
            UIUtil.showMessage(title: "", message: errorMessage, controller: self, okHandler: nil)
        }
        else if let password = tf_LastName.text, password.isEmpty {
            errorMessage = "Last Name Required"
            isValid = false
            UIUtil.showMessage(title: "", message: errorMessage, controller: self, okHandler: nil)
        }
        else if let btnTitle = Btn_Dob.titleLabel?.text, btnTitle.isEmpty || btnTitle == "DOB" {
            errorMessage = "Dob Required"
            isValid = false
            UIUtil.showMessage(title: "", message: errorMessage, controller: self, okHandler: nil)
        }
        return isValid
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension SignupStep1_VC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tf_FirstName {
            moveTextField(textField, moveDistance: -60, up: true)
        }
        else if textField == tf_LastName {
            moveTextField(textField, moveDistance: -80, up: true)
        }
      
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tf_FirstName {
            moveTextField(textField, moveDistance: -60, up: false)
        }
        else if textField == tf_LastName {
            moveTextField(textField, moveDistance: -80, up: false)
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
