//
//  Discover_VC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 20/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import Crashlytics

//  Notification count update
struct DiscoverNotificationCount {
    static var NotificationCount : Int = 0
}

class Discover_VC: UIViewController,SWRevealViewControllerDelegate,Trunk_TableCell_DiscoverDelegate,Event_tablecell_DiscoverDelegate,Feed_tablecell_DiscoverDelegate,Member_TableCell_DiscoverDelegate {
  
    var Arraylist = [] as NSMutableArray
    var Trunks = [TrunkModel]()
    var Feeds = [FeedsModel]()
    var Events = [EventModel]()
    var Members = [MemberModel]()
    
    var Wardrobe_Array = [] as NSArray
    
     @IBOutlet weak var tableview: UITableView!
     @IBOutlet weak var Btn_Menu: UIButton!
     @IBOutlet weak var Btn_Count: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().delegate = self
        Btn_Menu.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents
            .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        PreferenceUtil.save(key: PreferenceKey.SIDEMENU_ROWSELECT, value: "Discover")
        CallApiDiscoverVc()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.Btn_Count .setTitle("\(DiscoverNotificationCount.NotificationCount)", for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "TrunkUnattentNotification"), object: nil)
    }
    
    // MARK : Api user discover profile (for Trunkshow , newfeed , event, wardrobe , Humtsman memeber)
    func CallApiDiscoverVc(){
        
        LoderGifView.MyloaderShow(view: view)
        WebserviceUtil.callGet(jsonRequest: URLConstant.API.USER_DISCOVER_PROFILE ,view:self.view, success: { (response) in
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        
                        self.Arraylist.removeAllObjects()
                        LoderGifView.MyloaderHide(view: self.view)
                        
                        self.Arraylist.addObjects(from: [""])
                        
                        // ------ Trunk Section ------ //
                       let Trunk_shows_Array = (json.value(forKey: "trunk_shows") as! NSArray)
                        
                         for item in Trunk_shows_Array {
                            
                            guard let trunk = TrunkModel(id:((item as AnyObject).value(forKey: "trunk_id") as? String)!, photo: ((item as AnyObject).value(forKey: "image") as? String)!, date: ((item as AnyObject).value(forKey: "trunk_date") as? String)!,Enddate: ((item as AnyObject).value(forKey: "trunk_end_date") as? String)!, title: ((item as AnyObject).value(forKey: "trunk_title") as? String)!, desc: ((item as AnyObject).value(forKey: "trunk_desc") as? String)!, follow: ((item as AnyObject).value(forKey: "follow") as? Int)!, attend: ((item as AnyObject).value(forKey: "attend") as? Int)!, bookmark: ((item as AnyObject).value(forKey: "bookmark") as? Int)!) else {
                                fatalError("Unable to instantiate meal2")
                            }
                            self.Trunks += [trunk]
                        }
                        if Trunk_shows_Array.count > 0  {
                            self.Arraylist .addObjects(from: ["TRUNK SHOWS"])
                        }
                        // ---XXXXX--- Trunk Section ---XXXXX--- //

                        // ------ NewFeed Section ------ //
                        let News_feed_Array = (json.value(forKey: "news_feed") as! NSArray)
                        self.Feeds.removeAll()

                        for item in News_feed_Array {

                            guard let feed = FeedsModel(id:((item as AnyObject).value(forKey: "news_feed_id") as? String)!, title: ((item as AnyObject).value(forKey: "news_title") as? String)!, date: ((item as AnyObject).value(forKey: "added_at") as? String)!, decs: ((item as AnyObject).value(forKey: "news_desc") as? String)!, photo: ((item as AnyObject).value(forKey: "image") as? NSArray)!, likecount: 0, follow: 0) else {
                                fatalError("Unable to instantiate meal2")
                            }
                            self.Feeds += [feed]
                        }
                        if News_feed_Array.count > 0 {
                            self.Arraylist .addObjects(from: ["NEWS FEED"])
                        }
                        // ---XXXXX--- NewFeed Section ---XXXXX--- //
                        
                        // ------ Event Section ------ //
                        let Event_Array = (json.value(forKey: "events") as! NSArray)
                        self.Events.removeAll()
                        for item in Event_Array {
                            
                            guard let event = EventModel(id:((item as AnyObject).value(forKey: "event_id") as? String)!, photo: ((item as AnyObject).value(forKey: "image") as? String)!, date: ((item as AnyObject).value(forKey: "event_start_time") as? String)!, enddate: ((item as AnyObject).value(forKey: "event_end_time") as? String)!, title: ((item as AnyObject).value(forKey: "event_title") as? String)!, follow: ((item as AnyObject).value(forKey: "follow") as? Int)!, attend: ((item as AnyObject).value(forKey: "attend") as? Int)!, bookmark: ((item as AnyObject).value(forKey: "bookmark") as? Int)!) else {
                                fatalError("Unable to instantiate meal2")
                            }
                            self.Events += [event]
                        }
                        if Event_Array.count > 0  {
                            self.Arraylist.addObjects(from: ["EVENTS"])
                        }
                        // ---XXXXX--- Event Section ---XXXXX--- //

                        self.Wardrobe_Array = (json.value(forKey: "wardrobe") as! NSArray)
                        if self.Wardrobe_Array.count > 0  {
                            self.Arraylist .addObjects(from: ["YOUR HUNTSMAN WARDROBE"])
                        }
                        
                        // ------ Member Section ------ //
                        let Huntsman_members_Array = (json.value(forKey: "huntsman_members") as! NSArray)
                        
                        let Ncount = (json.value(forKey: "notification_count") as? Int)
                        DiscoverNotificationCount.NotificationCount = Ncount!
                        let Str_Count = "\(DiscoverNotificationCount.NotificationCount)"
                        self.Btn_Count .setTitle(Str_Count, for: .normal)
                        
                        self.Members.removeAll()
                        
                        for item in Huntsman_members_Array {
                            guard let member = MemberModel(id:((item as AnyObject).value(forKey: "user_id") as? String)!, photo: ((item as AnyObject).value(forKey: "profile_pic") as? String)!, industry: ((item as AnyObject).value(forKey: "industry") as? String)!, name: ((item as AnyObject).value(forKey: "name") as? String)!, about: "", bookmark: ((item as AnyObject).value(forKey: "bookmark") as? Int)!, attend_events: ((item as AnyObject).value(forKey: "attend_event_count") as? String)!, since: ((item as AnyObject).value(forKey: "joining_date") as? String)!) else {
                                fatalError("Unable to instantiate meal2")
                            }
                            self.Members += [member]
                        }
                        if Huntsman_members_Array.count > 0   {
                            self.Arraylist .addObjects(from: ["HUNTSMAN MEMBERS"])
                        }
                        // ---XXXXX--- Members Section ---XXXXX--- //

                        self.tableview.reloadData()
                        self.automaticallyAdjustsScrollViewInsets = false
                        self.tableview.contentInset = UIEdgeInsets (top: -34,left: 0,bottom: -20,right: 0)
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
            LoderGifView.MyloaderHide(view: self.view)
            print(error.localizedDescription)
            if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)" {
                UIUtil.showMessage(title: "No Internet Connection", message:"Make sure your device is connected to the internet.", controller: self, okHandler: nil)
            } else {
                UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
            }
        }
    }
    
    @IBAction func Action_notification(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "Notification_VC") as! Notification_VC
        present(profile, animated: true, completion: nil)
    }
    
    // ------  Trunk Section ------ //
    func Trunk_DiscoverEvents(trunk_id: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "Trunk_DetailVC") as! Trunk_DetailVC
        profile.TrunkId = trunk_id
        profile.callupdateback = callupdateback
        present(profile, animated: true, completion: nil)
    }
    
    // Discover collection delegate method for unattent event alert
    func Trunk_DiscoverUnattendAlert(TrunkTitle: String, type: String, TrunkId: String, TagIndex: Int) {
        
        if type == "AlertShowAttend" {
            let messageTitle = "You are attending " + TrunkTitle + "."
            UIUtil.showMessage(title: "", message: messageTitle, controller: self, okHandler: nil)
        } else if type == "AlertShowUnattend"{
            let messageTitle = "Are you sure you want to unattend  " + TrunkTitle + "?"
            let alert = UIAlertController(title: "Huntsman", message: messageTitle, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: handleConfirmTrunkUnattend(TrunkId:TrunkId  as NSString,TrunkTitle:TrunkTitle as NSString, TagIndex:TagIndex )
            ))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //  TrunkUnattentNotification post data on trunk_tablecell for update cell
    func handleConfirmTrunkUnattend(TrunkId:NSString,TrunkTitle:NSString ,TagIndex:Int) -> (_ alertAction:UIAlertAction) -> () {
        return { alertAction in
            
            let myDict = [ "TrunkId": TrunkId, "TrunkTitle":TrunkTitle,"Tag_Index":TagIndex] as [String : Any]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TrunkUnattentNotification"), object:myDict , userInfo: nil)
            NotificationCenter.default.removeObserver(self, name: Notification.Name("TrunkUnattentNotification"), object: nil)
        }
    }
  
    //  Call back function trunkcollection cell   trunk follow attent bookmark update value
    func callupdateback(_ id:NSString, _ updation:NSString, _ follow:Int, _ attend:Int, _ bookmark:Int)->() {
        if updation == "1" {
            if let index = Trunks.index(where: { $0.id == id as String }) {
                Trunks[index].follow = follow
                Trunks[index].attend = attend
                Trunks[index].bookmark = bookmark
                self.tableview.reloadData()
            }
        }
    }
    // ---XXXX---  Trunk Section ---XXXX--- //

    
    // ------  Feed Section ------ //
    func Feed_DiscoverEvents(feed_id: String) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "NewsFeed_DetailVC") as! NewsFeed_DetailVC
        profile.NewsFeedId = feed_id
        present(profile, animated: true, completion: nil)
    }
    // ---XXXX---  Feed Section ---XXXX--- //
    
    // ------  Event Section ------ //
    
  // Eventcollection cell delegate method
    func Event_DiscoverUnattendAlert(event_title: String, type: String, event_id: String, TagIndex: Int) {
        if type == "AlertShow" {
            let messageTitle = "Are you sure you want to unattend  " + event_title + "?"
            let alert = UIAlertController(title: "Huntsman", message: messageTitle, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: handleConfirmUnattend(EventId:event_id  as NSString,EventTitle:event_title as NSString, TagIndex:TagIndex )
            ))
            self.present(alert, animated: true, completion: nil)
        }
      }
//   Notification post on eventtablecell
    func handleConfirmUnattend(EventId:NSString,EventTitle:NSString ,TagIndex:Int) -> (_ alertAction:UIAlertAction) -> () {
        return { alertAction in

            let myDict = [ "Event_Id": EventId, "Event_Title":EventTitle,"Tag_Index":TagIndex] as [String : Any]

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EventUnattentNotification"), object:myDict , userInfo: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "EventUnattentNotification"), object: nil)
        }
    }
  
    func Event_DiscoverEvents(event_title: String, type: String, event_id: String, attend: String) {
        
        if type == "show_loader" {
            LoderGifView.MyloaderShow(view: self.view)
        }  else if type == "hide_loader" {
            LoderGifView.MyloaderHide(view: self.view)
            if attend == "attend"  {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let invite = storyBoard.instantiateViewController(withIdentifier: "Invite_VC") as! Invite_VC
                invite.event_title = event_title as String
                present(invite, animated: true, completion: nil)
            }
        } else if type == "detail" {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let EventDetail = storyBoard.instantiateViewController(withIdentifier: "Event_DetailVC") as! Event_DetailVC
            EventDetail.EventId = event_id
            EventDetail.callupdatebackevent = callupdatebackevent
            present(EventDetail, animated: true, completion: nil)
        }
    }
    func callupdatebackevent(_ id:NSString, _ updation:NSString, _ follow:Int, _ attend:Int, _ bookmark:Int)->()
    {
        if updation == "1"  {
            // Fetches the appropriate trunks for the data source layout.
            if let index = Events.index(where: { $0.id == id as String }) {
                Events[index].follow = follow
                Events[index].attend = attend
                Events[index].bookmark = bookmark
                
                self.tableview.reloadData()
            }
        }
    }
    // ---XXXX---  Event Section ---XXXX--- //


    // ------  Humtsman Memeber Section ------ //
    func Member_DiscoverEvents(type: String, member_id: String,Name:String ,Photo:String) {
        if type == "message" {
            // for chat
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "Message_DetailVC") as! Message_DetailVC
            profile.str_messageto = member_id
            profile.To_UserName = Name
            profile.ImageUrl = Photo
            present(profile, animated: true, completion: nil)
        } else{
            // user profile scren detail
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "UserProfileScreen_VC") as! UserProfileScreen_VC
            profile.str_userid = member_id
            profile.callupdateUserProfileScreen_VC = callupdateUserProfileScreen_VC
            present(profile, animated: true, completion: nil)
        }
    }
    
    func callupdateUserProfileScreen_VC(_ id:NSString, _ updation:NSString, _ bookmark:Int)->()  {
        if updation == "1" {
            if let index = Members.index(where: { $0.id == id as String }) {
                Members[index].bookmark = bookmark
                
                self.tableview.reloadData()
            }
        }
    }
    // ---XXXX---  Huntsman Memeber Section ---XXXX--- //

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension Discover_VC : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 75
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let Str_Title = (Arraylist [indexPath.section] as! String)

        if Str_Title == "" {
            return UITableViewAutomaticDimension
        } else if Str_Title == "TRUNK SHOWS" || Str_Title == "NEWS FEED" {
            return 100
        } else if Str_Title == "EVENTS" || Str_Title == "MY HUNTSMAN WARDROBE" || Str_Title == "HUNTSMAN MEMBERS" {
            return 190
        } else {
            return 190
        }
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customView = UIView()
        if section == 0 {
            customView.frame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
        } else {
            customView.frame = CGRect.init(x: 0, y: 0, width: Device.SCREEN_WIDTH, height: 75)
        }
        customView.backgroundColor = UIColor.clear
        let lbl_title = UILabel()
        lbl_title.frame = CGRect.init(x: 5, y: 30, width:  Device.SCREEN_WIDTH - 50 , height: 40)
        lbl_title.backgroundColor = UIColor.clear
        lbl_title.text = (Arraylist [section] as! String)
        lbl_title.font = UIFont(name: "GillSansMT" , size: 19.0)
        customView.addSubview(lbl_title)
        let lbl_line = UILabel()
        lbl_line.frame = CGRect.init(x: 5, y: 65, width:40 , height: 2)
        lbl_line.backgroundColor = UIColor(red: 143/255.0, green: 0/255.0, blue: 42/255.0, alpha: 1.0)
        customView.addSubview(lbl_line)
        return customView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.Arraylist.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let Str_Title = (Arraylist [indexPath.section] as! String)

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?

        if Str_Title == "" {
            return cell!
        } else if Str_Title == "TRUNK SHOWS" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Trunk_tablecell") as! Trunk_tablecell
            cell.Trunks = self.Trunks
            cell.delegate = self
            cell.collectiontrunk.reloadData()
            return cell
        } else if Str_Title == "NEWS FEED" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeed_tablecell") as! NewsFeed_tablecell
            cell.Feeds = self.Feeds
            cell.delegate = self
            return cell
        } else if Str_Title == "EVENTS" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Event_tablecell") as! Event_tablecell
            cell.Events = self.Events
            cell.delegate = self
            cell.collectionevent.reloadData()
            return cell
        } else if Str_Title == "MY HUNTSMAN WARDROBE" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Wardorbe_tablecell") as! Wardorbe_tablecell
            cell.WardrobeArray = self.Wardrobe_Array
            return cell
        } else if Str_Title == "HUNTSMAN MEMBERS" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Member_tablecell") as! Member_tablecell
            cell.Members = Members
            cell.delegate = self
            cell.collectionwardrobe.reloadData()
            return cell
        } else {
            return cell!
        }
    }
}
