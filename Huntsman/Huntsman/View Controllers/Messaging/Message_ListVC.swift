//
//  Message_ListVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 17/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import XLPagerTabStrip

// for loader Hide and show 
protocol MessageListDelegate: class {
    func MessageListLoaderHide()
    func MessageListLoaderShow()
}

class Message_ListVC: UIViewController,IndicatorInfoProvider {

    var delegate:MessageListDelegate?
    
    @IBOutlet weak var tableview: UITableView!
    var Message_Array = [] as NSMutableArray
    var Message_Filter_Array:NSMutableArray = []
    var All_MessageArray = [] as NSMutableArray
    
    @IBOutlet weak var Tf_Search: UITextField!
    
    var Str_Page = ""
    var intpage : Int = 0
    var more : Int!
    var didSelectIndex:Int = 0
    var pagereload : Int = 0
    var lodingApi: Bool!
    var ApiCall = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ApiCall = "YES"
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        if ApiCall == "YES"
        {
            lodingApi = true
            intpage = 0
            pagereload = 0
            Str_Page = String(intpage)
            callmessagememberListAPI()
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        ApiCall = "YES"
    }
    
    // MARK: API Calls
    func callmessagememberListAPI() {
        
        self.delegate?.MessageListLoaderShow()
        let params = [
            URLConstant.Param.NAME:"",
            URLConstant.Param.BOOKMARK:"0"
        ]
        /*USERCHATPOST  Get user chatepost */
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.USERCHATPOST,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let totaluser = json.value(forKey: "total_message") as? Int
                        if totaluser == 0 {
                            self.Message_Array.removeAllObjects()
                            self.Message_Filter_Array.removeAllObjects()
                            self.All_MessageArray.removeAllObjects()
                            self.tableview.reloadData()
                            self.delegate?.MessageListLoaderHide()
                            let alert = CustomAlert (title:"",Message:(json.value(forKey: "message") as? String)!)
                            alert.show(animated: true)

                        }
                        else
                        {
                            let str_more = json.value(forKey: "more") as? String
                            self.more = Int(str_more!)!
                            
                            let Chat_Array = (json.value(forKey: "chat_history")  as! NSMutableArray)
                            
                            if self.pagereload == 0 {
                                self.Message_Array.removeAllObjects()
                                for element in Chat_Array {
                                    self.Message_Array.add(element)
                                }
                            }
                            else
                            {
                                for element in Chat_Array {
                                    self.Message_Array.add(element)
                                }
                            }
                            self.lodingApi = true
                            self.All_MessageArray = self.Message_Array
                            self.tableview.reloadData()
                        }
                        self.delegate?.MessageListLoaderHide()

                    }
                    else {
                      self.delegate?.MessageListLoaderHide()
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
            self.delegate?.MessageListLoaderHide()
            if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)"
            {
               UIUtil.showMessage(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", controller: self, okHandler: nil)
            }
            else
            {
                UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "        List ",image:UIImage(named: "ListImg")!, highlightedImage:UIImage(named: "ListImg"))
    }
}

extension Message_ListVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return All_MessageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "message_listingcell", for: indexPath) as! message_listingcell
        
        let  list = All_MessageArray[indexPath.row] as! NSDictionary
        
        if let pic = ((list as AnyObject).value(forKey: "profile_pic") as? String), pic != "" {
            cell.ImageView.sd_setImage(with: URL(string: pic), placeholderImage: UIImage(named: "no image"))
        } else {
            cell.ImageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "no image"))
        }
        cell.lblname.text = ((list as AnyObject).value(forKey: "chat_user") as? String)!
        cell.lbldesc.text = ((list as AnyObject).value(forKey: "last_message") as? String)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startTime = Date()
        
       let endTime = dateFormatter.date(from: ((list as AnyObject).value(forKey: "last_message_time") as? String)!)
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.year , .day, .month , .hour, .minute, .second]
        
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: endTime!, to: startTime)
        
        if let year = difference.year, year > 0
        {
            print(year)
            cell.lbltime.text =  String(year) + " year ago"
            return cell
        }
        else  if let Month = difference.month, Month > 0
        {
            print(Month)
            cell.lbltime.text =  String(Month) + " month ago"
            return cell
        }
        else if let day = difference.day, day > 0
        {
            print(day)
            cell.lbltime.text =  String(day) + " day ago"
            return cell
        }
        else if let hour = difference.hour, hour > 0
        {
            print(hour)
            cell.lbltime.text =  String(hour) + " hour ago"
            return cell
        }
        else if let minute = difference.minute, minute > 0
        {
            cell.lbltime.text =  String(minute) + " minute ago"
            return cell
        }
        else if let second = difference.second, second > 0
        {
            print(second)
            cell.lbltime.text =  String(second) + " second ago"
            return cell
        }
        return cell
    }
    
    func tableView(_ table_view: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let list = All_MessageArray[indexPath.row] as! NSDictionary
        ApiCall = "NO"
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "Message_DetailVC") as! Message_DetailVC
        profile.CallBack_ForViewdisapper = CallBack_ForViewdisapper
        profile.str_messageto = ((list as AnyObject).value(forKey: "chat_user_id") as? String)!
        profile.To_UserName = ((list as AnyObject).value(forKey: "chat_user") as? String)!
        profile.ImageUrl = ((list as AnyObject).value(forKey: "profile_pic") as? String)!
        present(profile, animated: true, completion: nil)
        
    }
    
    func  CallBack_ForViewdisapper()->()
    {
        ApiCall = "NO"
    }
}

extension Message_ListVC : UITextFieldDelegate {
    
    // Trunk list filter
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
        
        let searchPredicate = NSPredicate(format: "chat_user CONTAINS[cd] %@", text)
        
        if Message_Array.count == 0 {
            
        } else {
            Message_Filter_Array = NSMutableArray(array: Message_Array.filtered(using: searchPredicate))
            self.All_MessageArray = self.Message_Filter_Array
            
            print ("array = \(Message_Filter_Array)")
            if(Message_Filter_Array.count == 0){
                self.All_MessageArray = self.Message_Array
            }
            tableview.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            tableview.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

