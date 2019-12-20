//
//  UserProfileScreen_VC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 17/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import MapKit

class UserProfileScreen_VC: UIViewController {
    
    private let follow_bookmark_attend = Follow_Bookmark_Attend()

    var flag_updation = "0"
    var flag_bookmark = 0
    var str_userid = ""
    var UserName = ""
    var UserImageURl = ""
    var Is_BookMark:Bool?
    var data = [:] as NSDictionary
    
    @IBOutlet weak var Btn_Menu: UIButton!
    
    @IBOutlet weak var img_profilepic: UIImageView!
    
    @IBOutlet var attendEvent_progress: MBCircularProgressBarView!
    @IBOutlet var profilecomplete_progress: MBCircularProgressBarView!
    
    @IBOutlet weak var view_personalinfo: UIView!
    
    @IBOutlet weak var view_location: UIView!
    @IBOutlet weak var lbl_locationaddress: UILabel!
    @IBOutlet weak var view_locationHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var MapheightConstraint: NSLayoutConstraint!

    @IBOutlet weak var map: MKMapView!
    let locationManager = CLLocationManager()

    @IBOutlet weak var lbl_NoWardrobe: UILabel!
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_industry: UILabel!
    
    @IBOutlet weak var Btn_bookmark: UIButton!
    @IBOutlet weak var Btn_message: UIButton!
    
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
    
    @IBOutlet var view_wardrobe: UIView!
    @IBOutlet weak var wardrobe_collection: UICollectionView!
    @IBOutlet weak var wardrobe_heightconstraint: NSLayoutConstraint!
    
    @IBOutlet var view_member: UIView!
    @IBOutlet weak var member_collection: UICollectionView!
    @IBOutlet weak var member_heightconstraint: NSLayoutConstraint!
    
    var mWardrobeList = [] as NSArray
    var Members = [MemberModel]()
    
    // call back function for update value bookmark
    var CallBack_ForViewdisapper :(()->())?
    var callupdateUserProfileScreen_VC:((_ id:NSString, _ updation:NSString, _ bookmark:Int)->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Btn_bookmark.titleLabel?.minimumScaleFactor = 0.5
        Btn_bookmark.titleLabel?.adjustsFontSizeToFitWidth = true
        
        Btn_message.titleLabel?.minimumScaleFactor = 0.5
        Btn_message.titleLabel?.adjustsFontSizeToFitWidth = true
        
        view_personalinfo.layer.masksToBounds = false
        view_personalinfo.layer.shadowRadius = 3
        view_personalinfo.layer.borderWidth = 0.5
        view_personalinfo.layer.borderColor = UIColor.lightGray.cgColor
        
        view_aboutinfo = UIUtil.dropShadow(view: view_aboutinfo, color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        
        view_location = UIUtil.dropShadow(view: view_location, color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)

        follow_bookmark_attend.delegate = self
        
        callUserProfileAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.CallBack_ForViewdisapper?()
    }
    //MARK:Api callUserProfileAPI
    func callUserProfileAPI() {
        
        LoderGifView.MyloaderShow(view: view)
        let params = [
            URLConstant.Param.USERID: str_userid
        ]
         //MARK:Api URLConstant.API.USERSDETAILBYID class in api name and parmas (for get member user info)
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.USERSDETAILBYID,view: self.view , params: params, success: { (response) in
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        LoderGifView.MyloaderHide(view: self.view)
                        
                        self.data = json.value(forKey: "user_info") as! NSDictionary
                        
                        print("data = \(self.data)")
                        
                        if let pic = (self.data.value(forKey: "profile_pic") as? String), pic != "" {
                            self.img_profilepic.sd_setImage(with: URL(string: pic), placeholderImage: UIImage(named: "no image"))
                            self.UserImageURl = pic

                        }else {
                            self.img_profilepic.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "no image"))
                            self.UserImageURl = ""

                        }
                        self.UserName = (self.data.value(forKey:"name") as? String)!
                        
                        if let lastname = self.data.value(forKey:"lastname") as? String {
                            self.lbl_name.text = ((self.data.value(forKey:"name") as? String)?.uppercased())! + " " + (lastname.uppercased())
                        }
                        else {
                            self.lbl_name.text = ((self.data.value(forKey:"name") as? String)?.uppercased())!
                        }
                        
                        self.lbl_industry.text = (self.data.value(forKey:"industry_title") as? String)?.uppercased()
                        
                        let attendevent = self.data.value(forKey:"attend_event_count") as! String
                        let attendevent_float = Float(attendevent)
                        self.attendEvent_progress.value = CGFloat(attendevent_float)
                        
                        self.lbl_about.text = (self.data.value(forKey:"about") as? String)
                        
                        self.lbl_industry2.text = (self.data.value(forKey:"industry_title") as? String)?.uppercased()
                        
                        self.lbl_jobtitle.text = (self.data.value(forKey:"job_title") as? String)?.uppercased()
                        
                        self.lbl_companyname.text = (self.data.value(forKey:"company") as? String)?.uppercased()
                        if let Bookmark = (self.data.value(forKey: "bookmark") as? Int), Bookmark != 0 {
                            
                            self.flag_bookmark = 1

                            self.Is_BookMark = true
                            self.Btn_bookmark.setTitle("BOOKMARK", for: .normal)
                            self.Btn_bookmark.setImage(UIImage(named: "bookmark user white"), for: .normal)
                            
                            self.Btn_bookmark.titleLabel?.minimumScaleFactor = 0.5
                            self.Btn_bookmark.titleLabel?.adjustsFontSizeToFitWidth = true
                            self.Btn_bookmark.setTitleColor(.white, for: .normal)
                            self.Btn_bookmark.backgroundColor = UIColor(red: 143/255.0,
                                                                        green: 0/255.0,
                                                                        blue: 42/255.0,
                                                                        alpha: 1.0)
                        }
                        else
                        {
                            self.flag_bookmark = 0

                            self.Is_BookMark = false
                            self.Btn_bookmark.setTitle("BOOKMARK", for: .normal)
                            self.Btn_bookmark.setImage(UIImage(named: "Bookmark user red"), for: .normal)
                            self.Btn_bookmark.titleLabel?.minimumScaleFactor = 0.5
                            self.Btn_bookmark.titleLabel?.adjustsFontSizeToFitWidth = true
                            self.Btn_bookmark.setTitleColor(UIColor(red: 143/255.0,green: 0/255.0,blue: 42/255.0,alpha: 1.0), for: UIControlState.normal)
                            self.Btn_bookmark.layer.borderWidth = 1
                            
                            self.Btn_bookmark.layer.borderColor = UIColor(red:143/255.0, green:0/255.0, blue:42/255.0, alpha: 1.0).cgColor
                            self.Btn_bookmark.backgroundColor = UIColor.white
                        }
                        self.InterestList = (self.data.value(forKey:"interest") as? String)!.components(separatedBy: ",") as NSArray
                        
                        self.IntXAxis = 0
                        self.IntYAxis = 5
                        for (index, element) in self.InterestList.enumerated() {
                            
                            if let font = UIFont(name: "GillSansMT", size: 13) {
                                
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
                            }
                            else
                            {
                                self.lbl_birthday.text = ""
                            }
                        }
                        // Initialize Date string
                        let dateStr = (self.data.value(forKey:"joining_date") as? String)!
                        // Set date format
                        let dateFmt = DateFormatter()
                        dateFmt.timeZone = NSTimeZone.default
                        dateFmt.dateFormat =  "yyyy-MM-dd  HH:mm:ss"
                        
                        // Get NSDate for the given string
                        
                        if dateFmt.date(from: dateStr) != nil {
                        let date = dateFmt.date(from: dateStr)
                        let year = Calendar.current.component(.year, from: date!)
                        self.lbl_since.text = String(year)
                        }
                        else
                        {
                            self.lbl_since.text = ""
                        }
                        
                       let locationSetting = (self.data.value(forKey:"location_setting") as? String)!
                        if locationSetting == "0"
                        {
                            self.map.isHidden = true
                            self.MapheightConstraint.constant = 0
                            self.view_locationHeightConstraint.constant = 40
                            self.lbl_locationaddress.text = "Location is private, can't see member's location."
                        }
                        else
                        {
                            self.lbl_locationaddress.text = (self.data.value(forKey:"address") as? String)!
                            
                            let str_lat = (self.data.value(forKey:"latitute") as? String)!
                            let lat = Double(str_lat)
                            let str_long = (self.data.value(forKey:"longitude") as? String)!
                            let longtude = Double(str_long)
                            
                            let location = CLLocationCoordinate2D(latitude: lat, longitude: longtude)
                            let span = MKCoordinateSpanMake(0.05, 0.05)
                            let region = MKCoordinateRegion(center: location, span: span)
                            self.map.setRegion(region, animated: true)
                            
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = location
                            annotation.title = self.lbl_name.text?.lowercased()
                            annotation.subtitle = (self.data.value(forKey:"address") as? String)!
                            self.map.addAnnotation(annotation)
                            self.map.delegate = self
                        }
                     
                        let WardrobeSetting = (self.data.value(forKey:"wardrobe_setting") as? String)!
                        self.mWardrobeList =  (self.data.value(forKey: "wardrobe") as! NSArray)
                        
                        let profilecomplete_float = Float(self.mWardrobeList.count)
                        self.profilecomplete_progress.value = CGFloat(profilecomplete_float)

                        if self.mWardrobeList.count == 0
                        {
                            self.lbl_NoWardrobe.isHidden = false
                            if WardrobeSetting == "0"
                            {
                                self.lbl_NoWardrobe.text = "Wardrobe is private, can't see member's wardrobe."
                            }
                            else
                            {
                                self.lbl_NoWardrobe.text = "There is no item in wardrobe."
                            }
                            self.wardrobe_heightconstraint.constant = 140
                        } else {
                            if WardrobeSetting == "0"
                            {
                                self.lbl_NoWardrobe.isHidden = false
                                self.wardrobe_heightconstraint.constant = 140
                                self.lbl_NoWardrobe.text = "Wardrobe is private, can't see member's wardrobe."
                            }
                            else
                            {
                                self.lbl_NoWardrobe.isHidden = true
                                self.wardrobe_collection.reloadData()
                            }
                        }
                        let mMemberList = (json.value(forKey: "suggested_members") as! NSArray).mutableCopy() as! NSMutableArray

                        if mMemberList.count == 0
                        {
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
                        
                    }
                    else {
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
    
    @IBAction func Action_MessageDetail(sender: AnyObject?){
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "Message_DetailVC") as! Message_DetailVC
         profile.str_messageto = str_userid
         profile.To_UserName = self.UserName
         profile.ImageUrl = self.UserImageURl
        present(profile, animated: true, completion: nil)
    }
    
    @IBAction func buttonSelected_Bookmark(sender: AnyObject?){
        
        if Is_BookMark == true
        {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "unbookmark", bookmark_id: str_userid, bookmark_type: "3", API: URLConstant.API.USER_UNBOOKMARKACTION)
            
            self.Btn_bookmark .setImage(UIImage(named: "Bookmark")!, for: UIControlState.normal)
            
            self.flag_updation = "1"
            self.flag_bookmark = 0
            self.Is_BookMark = false
            
            self.Btn_bookmark.setTitle("BOOKMARK", for: .normal)
            self.Btn_bookmark.setImage(UIImage(named: "Bookmark user red"), for: .normal)
            self.Btn_bookmark.titleLabel?.minimumScaleFactor = 0.5
            self.Btn_bookmark.titleLabel?.adjustsFontSizeToFitWidth = true
            self.Btn_bookmark.setTitleColor(UIColor(red: 143/255.0,green: 0/255.0,blue: 42/255.0,alpha: 1.0), for: UIControlState.normal)
            self.Btn_bookmark.layer.borderWidth = 1
            
            self.Btn_bookmark.layer.borderColor = UIColor(red:143/255.0, green:0/255.0, blue:42/255.0, alpha: 1.0).cgColor
            self.Btn_bookmark.backgroundColor = UIColor.white

        }
        else
        {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "bookmark", bookmark_id: str_userid, bookmark_type: "3", API: URLConstant.API.USER_BOOKMARKACTION)
            
            self.Btn_bookmark .setImage(UIImage(named: "bookmark filled")!, for: UIControlState.normal)
            
            self.flag_updation = "1"
            self.flag_bookmark = 1
            self.Is_BookMark = true
            
            self.Btn_bookmark.setTitle("BOOKMARK", for: .normal)
            self.Btn_bookmark.setImage(UIImage(named: "bookmark user white"), for: .normal)
            
            self.Btn_bookmark.titleLabel?.minimumScaleFactor = 0.5
            self.Btn_bookmark.titleLabel?.adjustsFontSizeToFitWidth = true
            self.Btn_bookmark.setTitleColor(.white, for: .normal)
            self.Btn_bookmark.backgroundColor = UIColor(red: 143/255.0,
                                                        green: 0/255.0,
                                                        blue: 42/255.0,
                                                        alpha: 1.0)
            
        }
    }
   
    @IBAction func crossClick(sender: AnyObject?){
        callupdateUserProfileScreen_VC?(str_userid as NSString, flag_updation as NSString,flag_bookmark)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UserProfileScreen_VC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "locationpoint")
            annotationView.canShowCallout = true
            return annotationView
        }
    }
}


extension UserProfileScreen_VC: UICollectionViewDataSource, UICollectionViewDelegate, Follow_Bookmark_AttendDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == wardrobe_collection {
            return mWardrobeList.count
        } else {
            return Members.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == wardrobe_collection
        {
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
        }
        else{
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
            }
            else
            {
                cell.lbl_since.text = ""
            }
            cell.lbl_industry.text = member.industry

            cell.lbl_noevent.text = member.attend_events
            
            cell.Btn_Comment.tag = 100  + indexPath.row
            cell.Btn_Comment.addTarget(self, action: #selector(action_Message), for: .touchUpInside)
            
            // ---- bookmark
            if member.bookmark != 0{
                cell.Btn_Bookmark .setImage(UIImage(named: "bookmark black")!, for: UIControlState.normal)
            }
            else {
                cell.Btn_Bookmark .setImage(UIImage(named: "bookmark")!, for: UIControlState.normal)
            }
            cell.Btn_Bookmark.tag = 500  + indexPath.row
            cell.Btn_Bookmark.addTarget(self, action: #selector(action_bookmark_unbookmark), for: .touchUpInside)
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == wardrobe_collection
        {
        }
        else{
            
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
    
    func callupdateUserProfileScreen_VC(_ id:NSString, _ updation:NSString, _ bookmark:Int)->()
    {
        if updation == "1"
        {
            if let index = Members.index(where: { $0.id == id as String }) {
                Members[index].bookmark = bookmark
                
                let indexPath = IndexPath(item: index, section: 0)
                self.member_collection.reloadItems(at: [indexPath])
            }
        }
    }

    @objc func action_Message(sender: UIButton){
        
        // Fetches the appropriate trunks for the data source layout.
        let member = Members[sender.tag - 100]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "Message_DetailVC") as! Message_DetailVC
        profile.str_messageto = member.id
        if member.photo == ""{
            profile.ImageUrl = ""
        }
        else
        {
            profile.ImageUrl = member.photo
        }
        profile.To_UserName = member.name
        present(profile, animated: true, completion: nil)
    }
    
}
