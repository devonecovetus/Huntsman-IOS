

//
//  ProfileScreen_VC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 14/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import SocketIO
class ProfileScreen_VC: UIViewController,SWRevealViewControllerDelegate {
    var data = [:] as NSDictionary
    private var socket:SocketIOClient?
    @IBOutlet weak var Btn_Menu: UIButton!
    @IBOutlet weak var Btn_Count: UIButton!
    @IBOutlet weak var img_profilepic: UIImageView!

    /*MBCircularProgressBarView for attent event progress and profile complete  External class  cocoapods*/
    @IBOutlet var attendEvent_progress: MBCircularProgressBarView!
    @IBOutlet var profilecomplete_progress: MBCircularProgressBarView!

    @IBOutlet weak var view_personalinfo: UIView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_industry: UILabel!
    @IBOutlet weak var view_aboutinfo: UIView!
    @IBOutlet weak var lbl_about: UILabel!
    @IBOutlet weak var lbl_industry2: UILabel!
    @IBOutlet weak var lbl_jobtitle: UILabel!
    @IBOutlet weak var lbl_companyname: UILabel!

    @IBOutlet weak var view_interest: UIView!
    @IBOutlet weak var interest_heightconstraint: NSLayoutConstraint!
    var InterestList = [] as NSArray
    var IntXAxis:Int = 0
    var IntYAxis:Int = 0
    var label = UILabel()

    @IBOutlet weak var lbl_birthday: UILabel!
    @IBOutlet weak var lbl_since: UILabel!
    @IBOutlet weak var lbl_NoWardrobe: UILabel!

    @IBOutlet var view_wardrobe: UIView!
    @IBOutlet weak var wardrobe_collection: UICollectionView!
    @IBOutlet weak var wardrobe_heightconstraint: NSLayoutConstraint!

    @IBOutlet weak var memberspacing_constraint: NSLayoutConstraint!
    @IBOutlet var view_member: UIView!
    @IBOutlet weak var member_collection: UICollectionView!
    @IBOutlet weak var member_heightconstraint: NSLayoutConstraint!

    var mWardrobeList = [] as NSArray
    var Members = [MemberModel]()
    
    private let follow_bookmark_attend = Follow_Bookmark_Attend()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().delegate = self
        
        Btn_Menu.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents
            .touchUpInside)
 
        view_personalinfo.layer.masksToBounds = false
        view_personalinfo.layer.shadowRadius = 3
        view_personalinfo.layer.borderWidth = 1.0
        view_personalinfo.layer.borderColor = UIColor.lightGray.cgColor
        view_aboutinfo = UIUtil.dropShadow(view: view_aboutinfo, color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        follow_bookmark_attend.delegate = self
        callProfileAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.Btn_Count.setTitle("\(DiscoverNotificationCount.NotificationCount)", for: .normal)
    }
    
    // -- API call
    func callProfileAPI() {
        
        LoderGifView.MyloaderShow(view: view)
        WebserviceUtil.callGet(jsonRequest: URLConstant.API.USER_PROFILE,view:self.view, success: { (response) in
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        
                        self.data = json.value(forKey: "user_info") as! NSDictionary
                        
                        if let pic = (self.data.value(forKey: "profile_pic") as? String), pic != "" {
                            self.img_profilepic.sd_setImage(with: URL(string: pic), placeholderImage: UIImage(named: "no image"))
                        } else {
                            self.img_profilepic.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "no image"))
                        }
                        
                        if let lastname = self.data.value(forKey:"lastname") as? String {
                            self.lbl_name.text = ((self.data.value(forKey:"name") as? String)?.uppercased())! + " " + (lastname.uppercased())
                        } else {
                            self.lbl_name.text = ((self.data.value(forKey:"name") as? String)?.uppercased())!
                        }
                        
                        self.lbl_industry.text = (self.data.value(forKey:"industry_title") as? String)?.uppercased()
                        
                        let attendevent = self.data.value(forKey:"attend_event_count") as! String
                        let attendevent_float = Float(attendevent)
                        self.attendEvent_progress.value = CGFloat(attendevent_float)
                        
                        var profilecomplete = self.data.value(forKey:"profile_complete") as! String
                        profilecomplete = profilecomplete.replacingOccurrences(of: "%", with: "")
                        
                        let profilecomplete_float = Float(profilecomplete)
                        self.profilecomplete_progress.value = CGFloat(profilecomplete_float)
                        
                        self.lbl_about.text = (self.data.value(forKey:"about") as? String)
                        self.lbl_industry2.text = (self.data.value(forKey:"industry_title") as? String)?.uppercased()
                        self.lbl_jobtitle.text = (self.data.value(forKey:"job_title") as? String)?.uppercased()
                        self.lbl_companyname.text = (self.data.value(forKey:"company") as? String)?.uppercased()
                        self.InterestList = (self.data.value(forKey:"interest") as? String)!.components(separatedBy: ",") as NSArray
                        
                        self.IntXAxis = 0
                        self.IntYAxis = 5
                        
                        for subView in self.view_interest.subviews {
                            subView.removeFromSuperview()
                        }
                        
                        for (index, element) in self.InterestList.enumerated() {
                            
                            if let font = UIFont(name: "Gill Sans", size: 14) {
                                
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
                                
                                self.label.textColor = UIColor.lightGray
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
                                self.view_interest.addSubview(self.label)
                            }
                        }
                        
                        self.interest_heightconstraint.constant = self.label.frame.origin.y + self.label.frame.size.height + 10
                        
                        if let Str_Birthday = self.data.value(forKey:"dob") as? String, Str_Birthday != "" {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            
                            if formatter.date(from: Str_Birthday) != nil {
                                let date = formatter.date(from: Str_Birthday)
                                formatter.dateFormat = "dd MMM yyyy"
                                let result = formatter.string(from: date!)
                                self.lbl_birthday.text = result.uppercased()
                            } else {
                                 self.lbl_birthday.text = ""
                            }
                        }
                        
                        // Initialize Date string
                        let dateStr = (self.data.value(forKey:"joining_date") as? String)!
                        
                        let dateFmt = DateFormatter()
                        dateFmt.timeZone = NSTimeZone.default
                        dateFmt.dateFormat =  "yyyy-MM-dd  HH:mm:ss"
                        
                        if dateFmt.date(from: dateStr) != nil {
                            let date = dateFmt.date(from: dateStr)
                            let year = Calendar.current.component(.year, from: date!)
                            self.lbl_since.text = String(year)
                        } else  {
                            self.lbl_since.text = ""
                        }
                    
                        self.mWardrobeList =  (self.data.value(forKey: "wardrobe") as! NSArray)
                        if self.mWardrobeList.count == 0  {
                          //  self.view_wardrobe.isHidden = true
                            self.wardrobe_heightconstraint.constant = 140
                            self.lbl_NoWardrobe.isHidden = false
                            //35
                            self.memberspacing_constraint.constant = 190
                        } else {
                            self.lbl_NoWardrobe.isHidden = true
                            self.wardrobe_collection.reloadData()
                        }
                        
                        let mMemberList = (json.value(forKey: "suggested_members") as! NSArray).mutableCopy() as! NSMutableArray
                        
                        if mMemberList.count == 0  {
                            self.view_member.isHidden = true
                            self.member_heightconstraint.constant = 0
                        } else {
                            
                            self.Members.removeAll()
                            for item in mMemberList {

                                guard let member = MemberModel(id:((item as AnyObject).value(forKey: "user_id") as? String)!, photo: ((item as AnyObject).value(forKey: "image") as? String)!, industry: ((item as AnyObject).value(forKey: "industry_title") as? String)!, name: ((item as AnyObject).value(forKey: "name") as? String)!, about: "", bookmark: ((item as AnyObject).value(forKey: "bookmark") as? Int)!, attend_events: ((item as AnyObject).value(forKey: "attend_event_count") as? String)!, since: ((item as AnyObject).value(forKey: "joining_date") as? String)!) else {
                                    fatalError("Unable to instantiate meal2")
                                }
                                self.Members += [member]
                            }
                            self.member_collection.reloadData()
                        }
                        LoderGifView.MyloaderHide(view: self.view)
                    } else {
                        LoderGifView.MyloaderHide(view: self.view)
                        // parsing status error
                        if let msg = json.value(forKey:"message") as? String, msg == "Invalid auth token."{
                            UIUtil.showLogout(title: "", message:"It seems you logged-in on other device with same user. To continue with same device please log-in again.", controller: self, okHandler: nil)
                        } else {
                            UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                        }
                    }
                }
            }
        }) { (error) in
            LoderGifView.MyloaderHide(view: self.view)
            print(error.localizedDescription)
            if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)" {
                UIUtil.showMessage(title: "No Internet Connection", message:"Make sure your device is connected to the internet.", controller: self, okHandler: nil)
            } else   {
                UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
            }
        }
    }
    // Action Notification screen
    @IBAction func Action_notification(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "Notification_VC") as! Notification_VC
        present(profile, animated: true, completion: nil)
    }
    
    // action edit profile
    @IBAction func Action_EditProfile(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "EditProfile_VC") as! EditProfile_VC
        profile.data_profileinfo = data
        profile.callupdatebackedit = callupdatebackedit
        present(profile, animated: true, completion: nil)
    }
    
    func callupdatebackedit()->()  {
        callProfileAPI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension Float {
    init(_ value: String){
        self = (value as NSString).floatValue
    }
}

extension ProfileScreen_VC : UICollectionViewDataSource, UICollectionViewDelegate, Follow_Bookmark_AttendDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == wardrobe_collection {
            return mWardrobeList.count
        } else {
            return Members.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == wardrobe_collection  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Wardrobe_cell", for: indexPath) as! Wardrobe_cell
            let list = mWardrobeList[indexPath.row]
            cell.lblcategory.text = ((list as AnyObject).value(forKey: "category") as? String)!
            cell.lbltitle.text = ((list as AnyObject).value(forKey: "title") as? String)!
            if let dress_pic = ((list as AnyObject).value(forKey: "image") as? String), dress_pic != "" {
                cell.img_dress.sd_setImage(with: URL(string: dress_pic), placeholderImage: UIImage(named: "no image"))
            }else {
                cell.img_dress.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "no image"))
            }
            return cell
        } else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Member_cell", for: indexPath) as! Member_cell
            
            let member = Members[indexPath.row]

            if member.photo == ""{
                cell.img_profile.sd_setImage(with: URL(string:""), placeholderImage: UIImage(named: "no image"))
            } else  {
                cell.img_profile.sd_setImage(with: URL(string: member.photo), placeholderImage: UIImage(named: "no image"))
            }
            cell.lbl_name.text = member.name
            let dateStr = member.since
            let dateFmt = DateFormatter()
            dateFmt.timeZone = NSTimeZone.default
            dateFmt.dateFormat =  "yyyy-MM-dd  HH:mm:ss"
            
            if dateFmt.date(from: dateStr) != nil {
                let date = dateFmt.date(from: dateStr)
                let year = Calendar.current.component(.year, from: date!)
                cell.lbl_since.text = String(year)
            }  else  {
                cell.lbl_since.text = ""
            }
            cell.lbl_industry.text = member.industry
            cell.lbl_noevent.text = member.attend_events
            cell.Btn_Comment.tag = 100  + indexPath.row
            cell.Btn_Comment.addTarget(self, action: #selector(action_Message), for: .touchUpInside)
            
            // ---- bookmark
            if member.bookmark != 0{
                cell.Btn_Bookmark .setImage(UIImage(named: "bookmark black")!, for: UIControlState.normal)
            } else {
                cell.Btn_Bookmark .setImage(UIImage(named: "bookmark")!, for: UIControlState.normal)
            }
            cell.Btn_Bookmark.tag = 500  + indexPath.row
            cell.Btn_Bookmark.addTarget(self, action: #selector(action_bookmark_unbookmark), for: .touchUpInside)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == wardrobe_collection {
        } else{
            let member = Members[indexPath.row]
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "UserProfileScreen_VC") as! UserProfileScreen_VC
            profile.str_userid = member.id
            profile.callupdateUserProfileScreen_VC = callupdateUserProfileScreen_VC
            present(profile, animated: true, completion: nil)
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
        } else {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "unbookmark", bookmark_id: member.id, bookmark_type: "3", API: URLConstant.API.USER_UNBOOKMARKACTION)
            if let index = Members.index(where: { $0.id == member.id }) {
                Members[index].bookmark = 0
            }
        }
        
        let indexPath = IndexPath(item: sender.tag - 500, section: 0)
        self.member_collection.reloadItems(at: [indexPath])
    }
    
    func didRecieveBookmarkUpdate(response: String) {
    }
    func didRecieveFollowUpdate(response: String) {
    }
    func didRecieveAttendUpdate(response: String, attendtype: String) {
    }
    
    func callupdateUserProfileScreen_VC(_ id:NSString, _ updation:NSString, _ bookmark:Int)->() {
        if updation == "1" {
            if let index = Members.index(where: { $0.id == id as String }) {
                Members[index].bookmark = bookmark
                let indexPath = IndexPath(item: index, section: 0)
                self.member_collection.reloadItems(at: [indexPath])
            }
        }
    }
    
    @objc func action_Message(sender: UIButton){
        
        let member = Members[sender.tag - 100]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "Message_DetailVC") as! Message_DetailVC
        profile.str_messageto = member.id
        profile.To_UserName = member.name
        if member.photo == ""{
             profile.ImageUrl = ""
        }  else   {
          profile.ImageUrl = member.photo
        }
        present(profile, animated: true, completion: nil)
    }
    
}
