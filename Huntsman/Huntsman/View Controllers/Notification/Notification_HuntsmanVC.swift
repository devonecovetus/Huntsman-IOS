//
//  Notification_HuntsmanVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 26/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import XLPagerTabStrip

// for loader Hide and show
protocol NotifiHuntsmanDelegate: class {
    func NotifiHuntsmanLoaderHide()
    func NotifiHuntsmanLoaderShow()
}

class Notification_HuntsmanVC: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var tableview: UITableView!
    var delegate:NotifiHuntsmanDelegate?
    
    var Notification_Array = [] as NSMutableArray
    var Count_Substract:Int = 0
    
    var Str_Page = ""
    var intpage : Int = 0
    var more:Int = 0
    var pagereload : Int = 0
    var lodingApi: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableview.estimatedRowHeight = 65.0
        tableview.rowHeight = UITableViewAutomaticDimension
        lodingApi = true
        intpage = 0
        pagereload = 0
        Str_Page = String(intpage)
        callNotificationAPI()
    }

    // MARK: API Calls
    func callNotificationAPI() {
        self.delegate?.NotifiHuntsmanLoaderShow()
        let params = [
            URLConstant.Param.PAGE:Str_Page,
            URLConstant.Param.TYPE:"huntsman"
        ]
          /*  MARK: ALLNOTIFICATION  get all huntsman */
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.ALLNOTIFICATION,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        
                        let count = json.value(forKey: "count") as? Int
                        if count == 0 {
                            
                            self.Notification_Array.removeAllObjects()
                            self.tableview.reloadData()
                            self.delegate?.NotifiHuntsmanLoaderHide()
                            UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                        }
                        else
                        {
                            let str_more = json.value(forKey: "more") as? String
                            self.more = Int(str_more!)!
                            
                            let notification = (json.value(forKey: "notification")  as! NSMutableArray)
                            
                            if self.pagereload == 0 {
                                self.Notification_Array.removeAllObjects()
                                for element in notification {
                                    self.Notification_Array.add(element)
                                }
                            }
                            else
                            {
                                for element in notification {
                                    self.Notification_Array.add(element)
                                }
                            }
                            self.lodingApi = true
                            self.tableview.reloadData()
                        }
                        self.delegate?.NotifiHuntsmanLoaderHide()
                    }
                    else {
                        self.delegate?.NotifiHuntsmanLoaderHide()

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
            self.delegate?.NotifiHuntsmanLoaderHide()
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
                    callNotificationAPI()
                }
            }
        } else {
            return;
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Huntsman")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension Notification_HuntsmanVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Notification_Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "notification_cell", for: indexPath) as! notification_cell
        
        let list = Notification_Array[indexPath.row] as! NSDictionary
        
        if let pic = ((list as AnyObject).value(forKey: "image") as? String), pic != "" {
            cell.img_view.sd_setImage(with: URL(string: pic), placeholderImage: UIImage(named: "no image"))
        }else {
            cell.img_view.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "no image"))
        }
        
        let HtmlconvertTitle =  (list as AnyObject).value(forKey: "title") as? String
        do {
            let finalstring    =  try NSAttributedString(data: (HtmlconvertTitle?.data(using: String.Encoding.utf8)!)!, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue],documentAttributes: nil)
            cell.Lbl_title.text =  finalstring.string
            
            let str_type =  (list as AnyObject).value(forKey: "type") as? String
            
            let str_isRead:String = String(format: "%@", (list as AnyObject).value(forKey: "is_read") as! CVarArg)
            
            switch str_type {
            case "1"?:
                if str_isRead == "0" {
                    cell.img_icon.image = UIImage(named:"news feed notification")
                }
                else
                {
                    cell.img_icon.image = UIImage(named:"news feed notification white")
                }
            case "2"?:
                if str_isRead == "0" {
                    cell.img_icon.image = UIImage(named:"trunk notification")
                }
                else
                {
                    cell.img_icon.image = UIImage(named:"trunk notification white")
                }
            case "3"?:
                if str_isRead == "0" {
                    cell.img_icon.image = UIImage(named:"event notification")
                }
                else
                {
                    cell.img_icon.image = UIImage(named:"event notification white")
                }
            case "4"?:
                if str_isRead == "0" {
                    cell.img_icon.image = UIImage(named:"retailer notification")
                }
                else
                {
                    cell.img_icon.image = UIImage(named:"retailer notification white")
                }
            case "5"?:
                if str_isRead == "0" {
                    cell.img_icon.image = UIImage(named:"msg notification")
                }
                else{
                    cell.img_icon.image = UIImage(named:"msg notification white")
                }
            case "6"?:
                if str_isRead == "0" {
                    cell.img_icon.image = UIImage(named:"news feed notification")
                }
                else
                {
                    cell.img_icon.image = UIImage(named:"news feed notification white")
                }
            case "7"?:
                if str_isRead == "0" {
                    cell.img_icon.image = UIImage(named:"msg notification")
                }
                else{
                    cell.img_icon.image = UIImage(named:"msg notification white")
                }
            case "8"?:
                if str_isRead == "0" {
                    cell.img_icon.image = UIImage(named:"msg notification")
                }
                else{
                    cell.img_icon.image = UIImage(named:"msg notification white")
                }
            case "9"?:
                if str_isRead == "0" {
                    cell.img_icon.image = UIImage(named:"msg notification")
                }
                else{
                    cell.img_icon.image = UIImage(named:"msg notification white")
                }
            default:
                print("no match")
            }
            
        } catch {
            print("Cannot convert html string to attributed string: \(error)")
        }
        
        let string = (list as AnyObject).value(forKey: "date") as! String
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if dateFormatter.date(from: string) != nil
        {
            let date = dateFormatter.date(from: string)!
            dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm a"
            let dateString = dateFormatter.string(from: date)
            cell.Lbl_date.text = dateString
        }
        else
        {
            cell.Lbl_date.text = ""
        }
        return cell
    }
    
    func tableView(_ table_view: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let list = Notification_Array[indexPath.row]as! NSDictionary
        let str_type =  (list as AnyObject).value(forKey: "type") as? String
        let str_notificationId =  (list as AnyObject).value(forKey: "notification_id") as? String
        let str_Id =  (list as AnyObject).value(forKey: "id") as? String
        let StrFrom =  (list as AnyObject).value(forKey: "from") as? String
        let str_isRead:String = String(format: "%@", (list as AnyObject).value(forKey: "is_read") as! CVarArg)

        if str_isRead == "0"
        {
            Call_NotificationRead_UnReadApi(Str_Type: str_type! as NSString, Str_NotificationId: str_notificationId! as NSString, Str_IsRead: str_isRead as NSString,Index: indexPath.row)
        }
        else
        {
            self.Str_Typ_ScreenLand(str_type: str_type! as NSString, StrId: str_Id! as NSString, Str_From: StrFrom! as NSString)
        }
    }
    
    func Call_NotificationRead_UnReadApi(Str_Type:NSString , Str_NotificationId:NSString ,Str_IsRead:NSString,Index:Int) {
        
        let params = [
            URLConstant.Param.STR_NOTIFICATIONID:Str_NotificationId,
            URLConstant.Param.STR_TYPEID:Str_Type
            ] as [String : Any]
        
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.USER_READ_NOTIFICATION,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        
                        let list = self.Notification_Array[Index]as! NSDictionary
                        list .setValue( "1" , forKey: "is_read")
                        
                        let str_type =  (list as AnyObject).value(forKey: "type") as? String
                        let str_Id =  (list as AnyObject).value(forKey: "id") as? String
                        let StrFrom =  (list as AnyObject).value(forKey: "from") as? String

                        let indexPath = IndexPath(item: Index, section: 0)
                        self.tableview.reloadRows(at: [indexPath], with: .fade)
                        
                        self.Count_Substract =   DiscoverNotificationCount.NotificationCount
                        DiscoverNotificationCount.NotificationCount = self.Count_Substract - 1
                        
                        self.Str_Typ_ScreenLand(str_type: str_type! as NSString, StrId: str_Id! as NSString, Str_From: StrFrom! as NSString )
                    }
                    else {
                        
                        self.delegate?.NotifiHuntsmanLoaderHide()
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
            self.delegate?.NotifiHuntsmanLoaderHide()
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
    //  Type according to landing screen vc
    func Str_Typ_ScreenLand(str_type: NSString ,StrId:NSString , Str_From: NSString) {
        
        switch str_type {
        case "1":
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "NewsFeed_DetailVC") as! NewsFeed_DetailVC
            profile.NewsFeedId = StrId as String
            present(profile, animated: true, completion: nil)
        case "2":
            let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "Trunk_DetailVC") as! Trunk_DetailVC
            profile.TrunkId = StrId as String
            present(profile, animated: true, completion: nil)
        case "3":
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let EventDetail = storyBoard.instantiateViewController(withIdentifier: "Event_DetailVC") as! Event_DetailVC
            EventDetail.EventId = StrId as String
            present(EventDetail, animated: true, completion: nil)
            
        case "4":
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let RetailerDetail = storyBoard.instantiateViewController(withIdentifier: "Retailer_DetailVC") as! Retailer_DetailVC
            RetailerDetail.RetailerId = StrId as String
            present(RetailerDetail, animated: true, completion: nil)
        case "5":
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "Message_DetailVC") as! Message_DetailVC
            profile.To_UserName = Str_From as String
            profile.str_messageto = StrId as String
            present(profile, animated: true, completion: nil)
        case "6":
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let WebView = storyBoard.instantiateViewController(withIdentifier: "Wardrobe_WebviewVC") as! Wardrobe_WebviewVC
            WebView.Str_url = StrId as String
            present(WebView, animated: true, completion: nil)
        case "7":
            let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "Admin_ChatVC") as! Admin_ChatVC
            profile.Flage_PrivousVC = "wardrobe_admin"
            present(profile, animated: true, completion: nil)
        case "8":
            let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "Admin_ChatVC") as! Admin_ChatVC
            profile.Flage_PrivousVC = "trunkshow_admin"
            profile.RequestBookingId = StrId as String
            present(profile, animated: true, completion: nil)
        case "9":
            let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "Admin_ChatVC") as! Admin_ChatVC
            profile.Flage_PrivousVC = "wardrobe_admin"
            profile.UserAdminChat = "User_AdminChat"
            present(profile, animated: true, completion: nil)
            
        default:
            print("No match")
        }
    }
}
