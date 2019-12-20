//
//  RequestBooking_VC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 07/05/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class RequestBooking_VC: UIViewController {
    
    @IBOutlet weak var View_popup: UIView!
    @IBOutlet weak var btn_datetime: UIButton!
    @IBOutlet weak var text_comment: UITextView!
    @IBOutlet weak var view_request: UIView!
    var str_dobsend = ""
    @IBOutlet weak var btn_plus: UIButton!
    @IBOutlet weak var tableview: UITableView!

    var Request_Array = [] as NSMutableArray
    
    var Str_Page = ""
    var intpage : Int = 0
    var more:Int = 0
    var pagereload : Int = 0
    var lodingApi: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()

        view_request = UIUtil.dropShadow(view: view_request, color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        setBottomBorder(Button:btn_datetime)

        lodingApi = true
        intpage = 0
        pagereload = 0
        Str_Page = String(intpage)
        
        LoderGifView.MyloaderShow(view: self.view)
        callRequestBookingAPI()
    }
    
    // MARK: API Calls
    func callRequestBookingAPI() {
        let params = [
            URLConstant.Param.PAGE:Str_Page,
            URLConstant.Param.STATUS:"all"
        ]
        
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.REQUESTBOOKING_LIST,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        
                        LoderGifView.MyloaderHide(view: self.view)
                        
                        let total_request = json.value(forKey: "total_request") as? Int
                        if total_request == 0 {

                            self.Request_Array.removeAllObjects()
                            self.tableview.reloadData()
                            LoderGifView.MyloaderHide(view: self.view)
                            let alert = CustomAlert (title:"",Message:(json.value(forKey: "message") as? String)!)
                            alert.show(animated: true)


                        } else {

                            let str_more = json.value(forKey: "more") as? String
                            self.more = Int(str_more!)!
                            let request_Array = (json.value(forKey: "requests")  as! NSMutableArray)
                            if self.pagereload == 0 {
                                self.Request_Array.removeAllObjects()
                                for element in request_Array {
                                    self.Request_Array.add(element)
                                }
                            }
                            else
                            {
                                for element in request_Array {
                                    self.Request_Array.add(element)
                                }
                            }
                            self.lodingApi = true
                            self.tableview.reloadData()
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let height = tableview.contentOffset.y + tableview.frame.size.height
        let TableHeight = tableview.contentSize.height
        
        if (height >= TableHeight)
        {
            if (more == 0) {
                return;
            } else {
                
                if lodingApi == true
                {
                    lodingApi = false
                    pagereload = 1
                    intpage = intpage + 10
                    Str_Page = String(intpage)
                    LoderGifView.MyloaderShow(view: self.view)
                    callRequestBookingAPI()
                }
            }
        } else {
            return;
        }
    }
    
    @IBAction func Action_request(_ sender: Any) {
        View_popup.isHidden = false
        btn_plus.isHidden = true
    }
    
    @IBAction func Action_datetime(_ sender: Any) {
        ActionSheetDatePicker.show(withTitle: "Select Date", datePickerMode: .dateAndTime, selectedDate: Date(), minimumDate: Date(), maximumDate: nil, doneBlock: { (sheet, value, index) in
            if let date = value as? Date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss a"
                self.str_dobsend = formatter.string(from: date)
                formatter.dateFormat = "dd MMM yyyy hh:mm a"
                let result = formatter.string(from: date)
                self.btn_datetime.setTitle(result, for: .normal)
            }
        }, cancel: nil, origin: self.view)
    }
    
    @IBAction func Action_cancel(_ sender: Any) {
        text_comment.resignFirstResponder()
        View_popup.isHidden = true
        btn_plus.isHidden = false
    }
    
    @IBAction func Action_ok(_ sender: Any) {
        if isValidInput() {
            LoderGifView.MyloaderShow(view: view)
            text_comment.resignFirstResponder()
            callRequestAPI()
        }
    }
    
    // MARK: API Calls
    func callRequestAPI() {
        
        let params = [
            URLConstant.Param.BOOKINGDATE: str_dobsend,
            URLConstant.Param.USRECOMMENT: text_comment.text as String
        ]
        
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.TRUNKREQUEST,view:self.view , params: params as Any as? [String : Any], success: { (response) in
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        self.View_popup.isHidden = true
                        self.btn_plus.isHidden = false
                        
                        self.callRequestBookingAPI()

                        // parsing status error
                        self.btn_datetime.setTitle("Select Date", for: .normal)
                        self.text_comment.text = "Comment..."
                        UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                    }
                    else {
                        self.View_popup.isHidden = true
                        self.btn_plus.isHidden = false
                        
                        // parsing status error
                        UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                    }
                    LoderGifView.MyloaderHide(view: self.view)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            self.View_popup.isHidden = true
            self.btn_plus.isHidden = false
            
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
    
    // MARK: Helper Methods
    func isValidInput() -> Bool {
        var errorMessage = ""
        var isValid = true
        
        if let textdate = btn_datetime.titleLabel?.text, textdate == "Date & Time" {
            errorMessage = "Please select Date & Time"
            isValid = false
            UIUtil.showMessage(title: "", message: errorMessage, controller: self, okHandler: nil)
        }
        else if let text = text_comment.text, text.isEmpty || text == "Comment..." {
            errorMessage = "Please enter Comment"
            isValid = false
            UIUtil.showMessage(title: "", message: errorMessage, controller: self, okHandler: nil)
        }
        
        return isValid
    }
    
    func setBottomBorder(Button: UIButton) {
        Button.layer.backgroundColor = UIColor.white.cgColor
        Button.layer.masksToBounds = false
        Button.layer.shadowColor = UIColor.lightGray.cgColor
        Button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        Button.layer.shadowOpacity = 0.5
        Button.layer.shadowRadius = 0.0
    }
    
    func setBottomBorder(textview: UITextView) {
        textview.layer.backgroundColor = UIColor.white.cgColor
        textview.layer.masksToBounds = false
        textview.layer.shadowColor = UIColor.lightGray.cgColor
        textview.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        textview.layer.shadowOpacity = 0.5
        textview.layer.shadowRadius = 0.0
    }
    
    @IBAction func crossClick(sender: AnyObject?){
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension RequestBooking_VC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Request_Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "requestbooking_cell", for: indexPath) as! requestbooking_cell
        
        let list = Request_Array[indexPath.row] as! NSDictionary
        
        let string = ((list as AnyObject).value(forKey: "booking_date") as? String)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if dateFormatter.date(from: string) != nil
        {
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.string(from: date)
        cell.lbl_date.text = dateString
        }
        else
        {
         cell.lbl_date.text = ""
        }
        cell.lbl_title.text = ((list as AnyObject).value(forKey: "user_comment ") as? String)!
    
        cell.btn_message.tag = indexPath.row
        cell.btn_message.addTarget(self, action: #selector(buttonSelected_message), for: .touchUpInside)
        
        let status = ((list as AnyObject).value(forKey: "status") as? String)!
        
        if status == "1" {
            cell.lbl_status.text = "Pending"
            cell.btn_status.tag = 500 + indexPath.row
            cell.btn_status.setTitleColor(UIColor(red: 143/255.0,
                                                  green: 0/255.0,
                                                  blue: 42/255.0,
                                                  alpha: 1.0), for: .normal)
            cell.btn_message.setTitleColor(UIColor(red: 143/255.0,
                                                   green: 0/255.0,
                                                   blue: 42/255.0,
                                                   alpha: 1.0), for: .normal)
            cell.btn_status.addTarget(self, action: #selector(buttonSelected_status), for: .touchUpInside)
        }
        else if status == "2" {
            cell.lbl_status.text = "Accepted"
            cell.btn_status.tag = 500 + indexPath.row
            cell.btn_status.setTitleColor(UIColor(red: 143/255.0,
                                                  green: 0/255.0,
                                                  blue: 42/255.0,
                                                  alpha: 1.0), for: .normal)
            cell.btn_message.setTitleColor(UIColor(red: 143/255.0,
                                                   green: 0/255.0,
                                                   blue: 42/255.0,
                                                   alpha: 1.0), for: .normal)
            cell.btn_status.addTarget(self, action: #selector(buttonSelected_status), for: .touchUpInside)
        }
        else if status == "3" {
            cell.lbl_status.text = "Declined"
            cell.btn_status.tag = 500 + indexPath.row
            cell.btn_status.setTitleColor(UIColor(red: 143/255.0,
                                                 green: 0/255.0,
                                                 blue: 42/255.0,
                                                 alpha: 1.0), for: .normal)
            cell.btn_message.setTitleColor(UIColor(red: 143/255.0,
                                                   green: 0/255.0,
                                                   blue: 42/255.0,
                                                   alpha: 1.0), for: .normal)
            cell.btn_status.addTarget(self, action: #selector(buttonSelected_status), for: .touchUpInside)
        }
        else if status == "4" {
            cell.btn_status.isUserInteractionEnabled = false
            cell.lbl_status.text = "Cancelled"
            cell.btn_status.setTitleColor(UIColor.darkGray, for: .normal)
            cell.btn_message.setTitleColor(UIColor.darkGray, for: .normal)
        }

        return cell
    }
    
    // MARK: ******* message ----
    @objc func buttonSelected_status(sender: UIButton){
        
        let SelectedArray = Request_Array[sender.tag - 500] as! NSDictionary
        let requestid = ((SelectedArray as AnyObject).value(forKey: "request_id") as? NSString)
        
        call_status_API(Request_ID:requestid!, objectatindex: sender.tag - 500, setfollowvalue: "4")
    }
    
    func call_status_API(Request_ID:NSString, objectatindex:Int, setfollowvalue:String) {

        LoderGifView.MyloaderShow(view: self.view)
        
        let params = [
            URLConstant.Param.REQUESTID:Request_ID
        ]

        WebserviceUtil.callPost(jsonRequest: URLConstant.API.REQUEST_CANCEL,view: self.view, params: params, success: { (response) in

            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {

                        LoderGifView.MyloaderHide(view: self.view)

                        var dict = [:] as NSDictionary
                        dict = self.Request_Array[objectatindex] as! NSDictionary
                        dict.setValue(setfollowvalue, forKey: "status")
                        
                        self.Request_Array.removeObject(at: objectatindex)
                        self.Request_Array.insert(dict, at: objectatindex)
                        self.tableview.reloadData()
                    }
                    else {
                        LoderGifView.MyloaderHide(view: self.view)
                        UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
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
    
    // MARK: ******* message ---- flage set  profile.Flage_PrivousVC = "trunkshow_admin"
    @objc func buttonSelected_message(sender: UIButton){
        
        let SelectedArray = Request_Array[sender.tag] as! NSDictionary
        let requestid = ((SelectedArray as AnyObject).value(forKey: "request_id") as? String)
        let status = ((SelectedArray as AnyObject).value(forKey: "status") as? String)!
        if status == "4" {
            
            let alert = CustomAlert (title:"",Message:"You have cancelled the request.You can't chat with Huntsman!")
            alert.show(animated: true)
        }
        else{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "Admin_ChatVC") as! Admin_ChatVC
            profile.Flage_PrivousVC = "trunkshow_admin"
             profile.RequestBookingId = requestid!
            present(profile, animated: true, completion: nil)
        }
    }
}

extension RequestBooking_VC: UITextViewDelegate
{
    // Textview Delegate Method
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if text_comment.text == "Comment..."
        {
            text_comment.text = ""
        }
        moveTextView(textView, moveDistance: -100, up: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if text_comment.text == ""
        {
            text_comment.text = "Comment..."
        }
        moveTextView(textView, moveDistance: -100, up: false)
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
}
