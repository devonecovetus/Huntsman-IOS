//
//  Invite_VC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 25/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class Invite_VC: UIViewController, UITableViewDelegate, UITableViewDataSource ,UITextFieldDelegate  {

    @IBOutlet weak var table_view: UITableView!
    
    var mUserList = [] as NSArray
    var FilterUserlist  = [] as NSArray
    var UserSelectId = [] as NSMutableArray
    var isSearch : Bool!

    var event_title = ""
    @IBOutlet  weak var Tf_Search: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isSearch = false
        callUserAPI()
    }

    // MARK: API Calls
    func callUserAPI() {
        LoderGifView.MyloaderShow(view: self.view)
        let params = [
            URLConstant.Param.NAME:"",
            URLConstant.Param.BOOKMARK:"",
            ]
        
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.HUNTSMAN_USERMAP,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        
                        self.mUserList = (json.value(forKey: "users") as? NSArray)!
                        if self.mUserList.count == 0{
                            LoderGifView.MyloaderHide(view: self.view)
                            UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                        }
                        else
                        {
                            self.table_view.reloadData()
                            LoderGifView.MyloaderHide(view: self.view)
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
    
    func tableView(_ table_view: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearch! {
            return FilterUserlist.count
        }
        else{
            return mUserList.count
        }
    }
    
    func tableView(_ table_view: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table_view.dequeueReusableCell(withIdentifier: "Industry_Cell", for: indexPath) as! Industry_Cell
        
        var userlist:NSDictionary
        
        if isSearch! {
            userlist = FilterUserlist[indexPath.row] as! NSDictionary
        }
        else{
            userlist = mUserList[indexPath.row] as! NSDictionary
        }
        
        cell.lblText.text = (userlist as AnyObject).value(forKey: "name") as? String
        
        if UserSelectId.contains((userlist as AnyObject).value(forKey: "id") as? String as Any) {
            cell.lblText.textColor = UIColor(red: 143/255.0,
                                             green: 0/255.0,
                                             blue: 42/255.0,
                                             alpha: 1.0)
            cell.ImageView.image = UIImage(named:"CheckBoxNew")
            cell.ImageView.isHidden = false
        } else {
            cell.ImageView.isHidden = true
            cell.lblText.textColor = UIColor.lightGray
        }
        return cell
    }
    
    func tableView(_ table_view: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var userlist:NSDictionary
        
        if isSearch! {
            userlist = FilterUserlist[indexPath.row] as! NSDictionary
        }
        else{
            userlist = mUserList[indexPath.row] as! NSDictionary
        }
        
        
        if UserSelectId.contains((userlist as AnyObject).value(forKey: "id") as? String as Any) {
            UserSelectId.remove((userlist as AnyObject).value(forKey: "id") as? String as Any)
        } else {
            UserSelectId.add((userlist as AnyObject).value(forKey: "id") as? String as Any)
        }
        table_view.reloadData()
    }
    
    @IBAction func doneClick(sender: AnyObject?){
        
        if UserSelectId.count == 0 {
            UIUtil.showMessage(title: "", message: "Please select atleast 1 user to invite.", controller: self, okHandler: nil)
        } else {
            let str_userid = UserSelectId.componentsJoined(by: ",")
            callInviteUserAPI(user_id:str_userid)
        }
    }
    
    // MARK: API Calls
    func callInviteUserAPI(user_id:String) {
        
        LoderGifView.MyloaderShow(view: self.view)

        let params = [
            URLConstant.Param.INVITETO:user_id,
            URLConstant.Param.INVITEFOR:"Event",
            URLConstant.Param.MESSAGE:"Hey! I have invited you on " + event_title + " event."
            ]
        
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.INVITEUSER,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        LoderGifView.MyloaderHide(view: self.view)
                        self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func crossClick(sender: AnyObject?){
        self.dismiss(animated: true, completion: nil)
    }

    
    // Event list filter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        print(txtAfterUpdate)
        
        if string == " " {
        } else if string == "" {
            getSearchArrayContains(txtAfterUpdate)
        } else {
            getSearchArrayContains(txtAfterUpdate)
        }
        
        return true
    }
    
    func getSearchArrayContains(_ text : String) {
        
        let searchPredicate = NSPredicate(format: "name CONTAINS[c] %@", text)
        
        if mUserList.count == 0 {
            
        } else {
            FilterUserlist = NSMutableArray(array: mUserList.filtered(using: searchPredicate))
            print ("array = \(FilterUserlist)")
            if(FilterUserlist.count == 0){
                isSearch = false;
            } else {
                isSearch = true;
            }
            table_view.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
