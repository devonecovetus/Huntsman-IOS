//
//  HuntMember_BookmarkVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 11/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import XLPagerTabStrip
//HuntMemberBookDelegate  loder show hide on view
protocol HuntMemberBookDelegate: class {
    func HuntsBookLoaderHide()
    func HuntsBookLoaderShow()
}

class HuntMember_BookmarkVC: UIViewController,IndicatorInfoProvider {
    
    // MemberModel model class in json store key with value
    var Members = [MemberModel]()
    var delegate:HuntMemberBookDelegate?
    private let follow_bookmark_attend = Follow_Bookmark_Attend()
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var Tf_Search: UITextField!
    
    var Str_Page = ""
    var intpage : Int = 0
    var more : Int!
    var didSelectIndex:Int = 0
    var pagereload : Int = 0
    var lodingApi: Bool!
    var IsRemovIndex: Bool!
    var Remove_byId  = ""
    
    var ApiCall = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ApiCall = "YES"
        follow_bookmark_attend.delegate = self
        tableview.estimatedRowHeight = 180
        tableview.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if ApiCall == "YES"
        {
            lodingApi = true
            intpage = 0
            pagereload = 0
            Str_Page = String(intpage)
            callListAPI()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        ApiCall = "YES"
    }
    
    // MARK: API callListAPI Bookmark
    func callListAPI() {
        
        self.delegate?.HuntsBookLoaderShow()
        let params = [
            URLConstant.Param.PAGE:Str_Page,
            URLConstant.Param.BOOKMARK:"1",
            URLConstant.Param.NAME:Tf_Search.text!
        ]
        /* HUNTSMANALLUSERS Get user bookmark member list*/
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.HUNTSMANALLUSERS,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let totaluser = json.value(forKey: "total_user") as? Int
                        if totaluser == 0 {
                            self.Members.removeAll()
                            self.tableview.reloadData()
                            self.delegate?.HuntsBookLoaderHide()
                            let alert = CustomAlert (title:"",Message:(json.value(forKey: "message") as? String)!)
                            alert.show(animated: true)

                        }
                        else
                        {
                            let str_more = json.value(forKey: "more") as? String
                            self.more = Int(str_more!)!
                            
                            let User_Array = (json.value(forKey: "users")  as! NSMutableArray)
                            
                            if self.pagereload == 0 {
                                self.Members.removeAll()
                                for item in User_Array {
                                    
                                    guard let member = MemberModel(id:((item as AnyObject).value(forKey: "id") as? String)!, photo: ((item as AnyObject).value(forKey: "profile_pic") as? String)!, industry: ((item as AnyObject).value(forKey: "industry") as? String)!, name: ((item as AnyObject).value(forKey: "name") as? String)!, about: ((item as AnyObject).value(forKey: "about_user") as? String)!, bookmark: ((item as AnyObject).value(forKey: "bookmark") as? Int)!, attend_events: "", since: "") else {
                                        fatalError("Unable to instantiate meal2")
                                    }
                                    
                                    self.Members += [member]
                                }
                            }
                            else
                            {
                                for item in User_Array {
                                    
                                    guard let member = MemberModel(id:((item as AnyObject).value(forKey: "id") as? String)!, photo: ((item as AnyObject).value(forKey: "profile_pic") as? String)!, industry: ((item as AnyObject).value(forKey: "industry") as? String)!, name: ((item as AnyObject).value(forKey: "name") as? String)!, about: ((item as AnyObject).value(forKey: "about_user") as? String)!, bookmark: ((item as AnyObject).value(forKey: "bookmark") as? Int)!, attend_events: "", since: "") else {
                                        fatalError("Unable to instantiate meal2")
                                    }
                                    
                                    self.Members += [member]
                                }
                            }
                            self.lodingApi = true
                            self.tableview.reloadData()
                        }
                        self.delegate?.HuntsBookLoaderHide()
                    }
                    else {
                        self.delegate?.HuntsBookLoaderHide()
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
            self.delegate?.HuntsBookLoaderHide()

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
    
    // action_Message go to message chat
    @objc func action_Message(sender: UIButton){
        // Fetches the appropriate trunks for the data source layout.
        let member = Members[sender.tag - 100]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "Message_DetailVC") as! Message_DetailVC
        profile.str_messageto = member.id
        profile.To_UserName = member.name
        if member.photo == ""{
            profile.ImageUrl = ""
        }
        else{
            profile.ImageUrl = member.photo
        }
        profile.CallBack_ForViewdisapper = CallBack_ForViewdisapper
        present(profile, animated: true, completion: nil)
    }
    
    func  CallBack_ForViewdisapper()->()
    {
        ApiCall = "NO"
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "        Bookmarks ",image:UIImage(named: "MyBookmark")!, highlightedImage:UIImage(named: "MyBookmark"))
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
       
        Tf_Search.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HuntMember_BookmarkVC:UITableViewDataSource, UITableViewDelegate, Follow_Bookmark_AttendDelegate, UIScrollViewDelegate, UITextFieldDelegate{
    
    // Table view delegate and datasource Method ----
    func tableView(_ table_view: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Members.count
    }
    
    func tableView(_ table_view: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table_view.dequeueReusableCell(withIdentifier: "HuntsmanMemberCell", for: indexPath) as! HuntsmanMemberCell
        
        // Fetches the appropriate trunks for the data source layout.
        let member = Members[indexPath.row]
      
        if member.photo == ""{
            cell.Img_ProfilePic.sd_setImage(with: URL(string:""), placeholderImage: UIImage(named: "no image"))
        } else  {
            cell.Img_ProfilePic.sd_setImage(with: URL(string: member.photo), placeholderImage: UIImage(named: "no image"))
        }
        
        if member.industry == ""{
            cell.Lbl_Industry.text = ""
        } else  {
            cell.Lbl_Industry.text = member.industry
        }
        
        cell.Lbl_name.text = member.name
        
        if member.about == ""{
            cell.Lbl_aboutuser.text = ""
        } else  {
            cell.Lbl_aboutuser.text = member.about
        }
        
        cell.Btn_Comment.tag = 100  + indexPath.row
        cell.Btn_Comment.addTarget(self, action: #selector(action_Message), for: .touchUpInside)
        
        // ---- bookmark
        if member.bookmark != 0{
            cell.Btn_bookmark .setImage(UIImage(named: "bookmark filled")!, for: UIControlState.normal)
        }
        else {
            cell.Btn_bookmark .setImage(UIImage(named: "Bookmark")!, for: UIControlState.normal)
        }
        cell.Btn_bookmark.tag = 500  + indexPath.row
        cell.Btn_bookmark.addTarget(self, action: #selector(action_bookmark_unbookmark), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ table_view: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ApiCall = "NO"
        
        // Fetches the appropriate trunks for the data source layout.
        let member = Members[indexPath.row]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "UserProfileScreen_VC") as! UserProfileScreen_VC
        profile.str_userid = member.id
        profile.callupdateUserProfileScreen_VC = callupdateUserProfileScreen_VC
        profile.CallBack_ForViewdisapper = CallBack_ForViewdisapper
        present(profile, animated: true, completion: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let height:Int = Int(tableview.contentOffset.y + tableview.frame.size.height)
        let TableHeight:Int =  Int(tableview.contentSize.height)
        
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
                    callListAPI()
                }
            }
        } else {
            return;
        }
    }
    
    
    // ------- Bookmark section  -------- //
    @objc func action_bookmark_unbookmark(sender: UIButton){
        
        // Fetches the appropriate trunks for the data source layout.
        let member = Members[sender.tag - 500]
       
        if member.bookmark == 0 {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "bookmark", bookmark_id: member.id, bookmark_type: "3", API: URLConstant.API.USER_BOOKMARKACTION)
            
            if let index = Members.index(where: { $0.id == member.id }) {
                Members[index].bookmark = 1
            }
            
            let indexPath = IndexPath(item: sender.tag - 500, section: 0)
            self.tableview.reloadRows(at: [indexPath], with: .fade)
            
        } else {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "unbookmark", bookmark_id: member.id, bookmark_type: "3", API: URLConstant.API.USER_UNBOOKMARKACTION)
            
            if let index = Members.index(where: { $0.id == member.id }) {
                Members.remove(at: index)
            }
            
            tableview.reloadData()
        }
        
    }
    
    func didRecieveBookmarkUpdate(response: String) {
    }
    func didRecieveFollowUpdate(response: String) {
    }
    func didRecieveAttendUpdate(response: String, attendtype: String) {
    }
    
    func callupdateUserProfileScreen_VC(_ id:NSString, _ updation:NSString, _ bookmark:Int)->()
    {
        if updation == "1"
        {
            if bookmark == 0{
                if let index = Members.index(where: { $0.id == id as String }) {
                    Members.remove(at: index)
                }
                tableview.reloadData()
            }
            else{
                if let index = Members.index(where: { $0.id == id as String }) {
                    Members[index].bookmark = bookmark
                    
                    let indexPath = IndexPath(item: index, section: 0)
                    self.tableview.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
        
    }
    
    // Member list filter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == UIReturnKeyType.go{
            
            self.delegate?.HuntsBookLoaderHide()
            lodingApi = true
            intpage = 0
            pagereload = 0
            Str_Page = String(intpage)
            callListAPI()
        }
        return textField.resignFirstResponder()
    }

}
