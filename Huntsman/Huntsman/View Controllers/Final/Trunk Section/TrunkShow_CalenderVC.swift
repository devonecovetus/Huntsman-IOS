//
//  TrunkShow_CalenderVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 30/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import XLPagerTabStrip

enum MyTheme {
    case light
    case dark
}
// TrunkShow_CalenderDelegate loder show hide 
protocol TrunkShow_CalenderDelegate:class {
    func Trunkshow_CalenderLoderShow()
    func Trunkshow_CalenderLoderHide()
}

class TrunkShow_CalenderVC: UIViewController,IndicatorInfoProvider,CalenderDelegate{
    
    var Trunks = [TrunkModel]()
    private let follow_bookmark_attend = Follow_Bookmark_Attend()
    
    var delegate:TrunkShow_CalenderDelegate?

    var Month :Int = 0
    var Year:Int = 0
    var Day:Int = 0
    
    var Str_Page = ""
    var Str_day = ""
    var CurrentDate = ""
    var intpage : Int = 0
    var more : Int!
    
    var pagereload : Int = 0
    var lodingApi: Bool!
    var ApiCall = ""
    var loadapiFirst: Bool!
    var currentdate = ""

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var Lbl_Month: UILabel!
    @IBOutlet weak var Lbl_Status: UILabel!
    @IBOutlet weak var Lbl_Month_YPosition: NSLayoutConstraint!
    @IBOutlet weak var Table_ViewContaintSize: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.removeObject(forKey:"allcalendarlist")
        follow_bookmark_attend.delegate = self

        tableview.estimatedRowHeight = 120.0
        tableview.rowHeight = UITableViewAutomaticDimension
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        Month = month
        Year = year
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let now = Date()
        let dateString = formatter.string(from:now)
        let DateMonth = formatter.date(from: dateString)
        formatter.dateFormat = "MMMM"
        let GetDateMonth = formatter.string(from: DateMonth!)
        
        Lbl_Month.text = String(describing: GetDateMonth).uppercased()
        
        Str_day = ""
        
        callTrunkcalendarAPI()
        ScrollView.addSubview(calenderView)
        
        calenderView.delegate = self
        calenderView.topAnchor.constraint(equalTo: ScrollView.topAnchor, constant: 10).isActive=true
        calenderView.rightAnchor.constraint(equalTo: ScrollView.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: ScrollView.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 365).isActive=true
        self.Lbl_Month_YPosition.constant = self.calenderView.frame.origin.y + self.calenderView.frame.size.height - 50
        
        ApiCall = "YES"
        loadapiFirst = true
        
        formatter.dateFormat = "dd-MM-yyyy"
        currentdate = formatter.string(from: date)
        print(currentdate)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        if ApiCall == "YES"
        {
            if loadapiFirst == true
            {
                loadapiFirst = false
            } else
            {
                self.lodingApi = true
                self.intpage = 0
                self.pagereload = 0
                self.Str_Page = String(self.intpage)
                self.callLoginApi_SelectedMonth()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ApiCall = "YES"
    }
    
    // MARK: -   -------Calendar Delegate Method ----
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    lazy var calenderView: CalenderView = {
        let calenderView = CalenderView(theme: MyTheme.light)
        calenderView.translatesAutoresizingMaskIntoConstraints=false
        return calenderView
    }()
     // didTap_PrivousMonth
    func didTap_PrivousMonth(date:String)
    {
        let dateFmt = DateFormatter()
        dateFmt.timeZone = NSTimeZone.default
        dateFmt.dateFormat = "MMMM yyyy"
        
        // Get NSDate for the given string
        let date1 = dateFmt.date(from: date)
        let year = Calendar.current.component(.year, from: date1!)
        let month = Calendar.current.component(.month, from: date1!)
        
        Month = month
        Year = year
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMMM"
        let DateMonth = dateFormatter.string(from: date!)
        Lbl_Month.text = String(describing: DateMonth).uppercased()
        Str_day = ""
        callTrunkcalendarAPI()
    }
      // didTap_NextMonth
    func didTap_NextMonth(date:String)
    {
        let dateFmt = DateFormatter()
        dateFmt.timeZone = NSTimeZone.default
        dateFmt.dateFormat = "MMMM yyyy"
        let date1 = dateFmt.date(from: date)
        let year = Calendar.current.component(.year, from: date1!)
        let month = Calendar.current.component(.month, from: date1!)
        
        Month  = month
        Year = year
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd MMMM"
        let DateMonth = dateFormatter.string(from: date!)
        Lbl_Month.text = String(describing: DateMonth).uppercased()
        Str_day = ""
        callTrunkcalendarAPI()
    }
    
    func didTapDate(date: String, available: Bool)
    {
        print("date = \(date)")
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        let date0 = df.date(from: date)
        df.dateFormat = "dd MMMM"
        let DateMonth0 = df.string(from: date0!)
        print("dd MMM - \(df.string(from: date0!))")
        Lbl_Month.text = String(describing: DateMonth0).uppercased()
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date2 = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let DateMonth = dateFormatter.string(from: date2!)
        Str_day = DateMonth
        self.Lbl_Month_YPosition.constant = self.calenderView.frame.origin.y + self.calenderView.frame.size.height - 50
        
        self.lodingApi = true
        self.intpage = 0
        self.pagereload = 0
        self.Str_Page = String(self.intpage)
        self.callLoginApi_SelectedMonth()
    }
    
    // MARK: --- Api Calling for Event Show in month ----
    func callTrunkcalendarAPI(){
        
        self.delegate?.Trunkshow_CalenderLoderShow()
        let params = [
            URLConstant.Param.MONTH : Month,
            URLConstant.Param.YEAR : Year
        ]
        
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.USER_TRUNKCALENDAR,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let trunk_calendar = json.value(forKey: "trunk_calender") as? NSArray
                        if trunk_calendar?.count == 0 {
                            
                            UserDefaults.standard.removeObject(forKey:"allcalendarlist")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "load"), object: nil)
                            
                            self.Lbl_Month_YPosition.constant = self.calenderView.frame.origin.y + self.calenderView.frame.size.height - 50
                            
                            self.Trunks.removeAll()
                            self.tableview.reloadData()
                            self.Table_ViewContaintSize.constant = self.tableview.contentSize.height + 10
                            self.Lbl_Status.text = "There are no trunk shows."
                            self.Lbl_Status.isHidden = false
                           
                        }
                        else{
                            var EventListArray = [Int] ()
                            for Item in trunk_calendar!
                            {
                                let Date = ((Item as AnyObject).value(forKey: "date") as? String)!
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                
                                if dateFormatter.date(from: Date) != nil
                                {
                                    let date = dateFormatter.date(from: Date)!
                                    dateFormatter.dateFormat = "dd"
                                    let finaldayEvent = dateFormatter.string(from: date)
                                    EventListArray.append(Int(finaldayEvent)!)
                                }
                            }
                            
                            UserDefaults.standard.removeObject(forKey:"allcalendarlist")
                            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject:EventListArray  as Any)
                            PreferenceUtil.saveCalendarList(list: encodedData as NSData)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "load"), object: nil)
                            
                            self.Lbl_Month_YPosition.constant = self.calenderView.frame.origin.y + self.calenderView.frame.size.height - 50
                            self.delegate?.Trunkshow_CalenderLoderHide()
                            self.lodingApi = true
                            self.intpage = 0
                            self.pagereload = 0
                            self.Str_Page = String(self.intpage)
                            self.callLoginApi_SelectedMonth()
                        }
                    }
                    else {
                        if let msg = json.value(forKey:"message") as? String, msg == "Invalid auth token."{
                            UIUtil.showLogout(title: "", message:"It seems you logged-in on other device with same user. To continue with same device please log-in again.", controller: self, okHandler: nil)
                        } else {
                            UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                        }
                        
                    }
                }
                self.delegate?.Trunkshow_CalenderLoderHide()
            }
        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.Trunkshow_CalenderLoderHide()
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
    
    // MARK: -   -------Api Calling for SelectedMonth ----
    func callLoginApi_SelectedMonth() {
        self.delegate?.Trunkshow_CalenderLoderShow()
        let params = [
            URLConstant.Param.PAGE:Str_Page,
            URLConstant.Param.BOOKMARK:"0",
            URLConstant.Param.TYPE :"",
            URLConstant.Param.MONTH: String(Month),
            URLConstant.Param.YEAR :String(Year),
            URLConstant.Param.FILTERDATE :Str_day
        ]
        // TRUNKSHOW_GETAPPTRUNK  (selected month)
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.TRUNKSHOW_GETAPPTRUNK,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let TotalTrunk = json.value(forKey: "total_trunk") as? Int
                        if TotalTrunk == 0 {
                            
                            self.Trunks.removeAll()
                            self.tableview.reloadData()
                            self.Table_ViewContaintSize.constant = self.tableview.contentSize.height + 10
                            self.Lbl_Status.text = "There are no trunk show"
                            self.Lbl_Status.isHidden = false
                            
                            self.delegate?.Trunkshow_CalenderLoderHide()
                        }
                        else
                        {
                            let str_more = json.value(forKey: "more") as? String
                            self.more = Int(str_more!)!
                            
                            let Trunk_Array = (json.value(forKey: "trunks")  as! NSMutableArray)
                            
                            if self.pagereload == 0 {
                                
                                self.Trunks.removeAll()
                                
                                for item in Trunk_Array {
                                    
                                    guard let trunk = TrunkModel(id:((item as AnyObject).value(forKey: "id") as? String)!, photo: ((item as AnyObject).value(forKey: "image") as? String)!, date: ((item as AnyObject).value(forKey: "trunk_date") as? String)!,Enddate: ((item as AnyObject).value(forKey: "trunk_end_date") as? String)!, title: ((item as AnyObject).value(forKey: "trunk_title") as? String)!, desc: ((item as AnyObject).value(forKey: "trunk_desc") as? String)!, follow: ((item as AnyObject).value(forKey: "follow") as? Int)!, attend: ((item as AnyObject).value(forKey: "attend") as? Int)!, bookmark: ((item as AnyObject).value(forKey: "bookmark") as? Int)!) else {
                                        fatalError("Unable to instantiate meal2")
                                    }
                                    self.Trunks += [trunk]
                                }
                            }
                            else
                            {
                                for item in Trunk_Array {
                                    
                                    guard let trunk = TrunkModel(id:((item as AnyObject).value(forKey: "id") as? String)!, photo: ((item as AnyObject).value(forKey: "image") as? String)!, date: ((item as AnyObject).value(forKey: "trunk_date") as? String)!,Enddate: ((item as AnyObject).value(forKey: "trunk_end_date") as? String)!, title: ((item as AnyObject).value(forKey: "trunk_title") as? String)!, desc: ((item as AnyObject).value(forKey: "trunk_desc") as? String)!, follow: ((item as AnyObject).value(forKey: "follow") as? Int)!, attend: ((item as AnyObject).value(forKey: "attend") as? Int)!, bookmark: ((item as AnyObject).value(forKey: "bookmark") as? Int)!) else {
                                        fatalError("Unable to instantiate meal2")
                                    }
                                    
                                    self.Trunks += [trunk]
                                }
                            }
                            
                            self.lodingApi = true
                            self.Lbl_Status.isHidden = true
                            self.Table_ViewContaintSize.constant = 250
                            self.tableview.reloadData()
                            self.tableview.layoutIfNeeded()
                            self.Table_ViewContaintSize.constant = self.tableview.contentSize.height + 10
                            
                            self.delegate?.Trunkshow_CalenderLoderHide()
                        }
                    }
                    else {
                        self.delegate?.Trunkshow_CalenderLoderHide()
                      
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
            self.delegate?.Trunkshow_CalenderLoderHide()
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
    
    func CallBack_ForViewdisapper()->()
    {
        ApiCall = "NO"
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "        Calendar ",image:UIImage(named: "Calender")!, highlightedImage:UIImage(named: "Calender"))
    }
    
//    override func willMove(toParentViewController parent: UIViewController?) {
//
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
}

extension TrunkShow_CalenderVC:UITableViewDataSource, UITableViewDelegate, Follow_Bookmark_AttendDelegate, UIScrollViewDelegate{
    
    // MARK: -   -------Table view delegate and datasource Method ----
    func tableView(_ table_view: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Trunks.count
    }
    
    func tableView(_ table_view: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table_view.dequeueReusableCell(withIdentifier: "TrunkList_Cell", for: indexPath) as! TrunkList_Cell
        
        // Fetches the appropriate trunks for the data source layout.
        let trunk = Trunks[indexPath.row]
        
        cell.img_trunk.sd_setImage(with: URL(string: trunk.photo), placeholderImage: UIImage(named: "no image"))
        
        let date = Date()
        let stringDate: String = date.userddMMMyyyyDate(str_date: trunk.date)
        cell.Lbl_Date.text = stringDate
        
        cell.Lbl_TrunkTitle.text = trunk.title
        cell.Lbl_TrunkDescrip.text = trunk.desc
        
        // ---- follow
        if trunk.follow != 0 {
            cell.Btn_like .setImage(UIImage(named: "follow filled")!, for: UIControlState.normal)
        }
        else{
            cell.Btn_like .setImage(UIImage(named: "follow")!, for: UIControlState.normal)
        }
        cell.Btn_like.tag = 100 + indexPath.row
        cell.Btn_like.addTarget(self, action: #selector(action_follow_unfollow), for: .touchUpInside)
        
      // trunk
        
        if trunk.attend != 0 {
            cell.Btn_Attendent .setImage(UIImage(named: "attend  filled")!, for: UIControlState.normal)
        }
        else {
            cell.Btn_Attendent .setImage(UIImage(named: "attend")!, for: UIControlState.normal)
        }
        
        let StrEnddate: String = date.UserEventEnddate(str_date: trunk.End_date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        if Calendar.current.compare(dateFormatter.date(from:StrEnddate )!, to: dateFormatter.date(from:currentdate )!, toGranularity: .day) == .orderedSame || Calendar.current.compare(dateFormatter.date(from:currentdate )!, to: dateFormatter.date(from:StrEnddate )!, toGranularity: .day) ==   .orderedAscending{
            cell.Btn_Attendent.isHidden = false
            cell.BookmarkLeading.constant = 48
        }
        else
        {
            cell.BookmarkLeading.constant = 10
            cell.Btn_Attendent.isHidden = true
        }
        
        cell.Btn_Attendent.tag = 300 + indexPath.row
        cell.Btn_Attendent.addTarget(self, action: #selector(action_attend_unattend), for: .touchUpInside)
        
        // ---- bookmark
        if trunk.bookmark != 0{
            cell.Btn_BookMark .setImage(UIImage(named: "bookmark filled")!, for: UIControlState.normal)
        }
        else {
            cell.Btn_BookMark .setImage(UIImage(named: "Bookmark")!, for: UIControlState.normal)
        }
        cell.Btn_BookMark.tag = 500  + indexPath.row
        cell.Btn_BookMark.addTarget(self, action: #selector(action_bookmark_unbookmark), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ table_view: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ApiCall = "NO"
        
        // Fetches the appropriate trunks for the data source layout.
        let trunk = Trunks[indexPath.row]
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "Trunk_DetailVC") as! Trunk_DetailVC
        profile.TrunkId = trunk.id
        profile.CallBack_ForViewdisapper = CallBack_ForViewdisapper
        profile.callupdateback = callupdateback
        present(profile, animated: true, completion: nil)
    }
 
    // ------- Follow unfollow section  -------- //
    @objc func action_follow_unfollow(sender: UIButton){
        // Fetches the appropriate trunks for the data source layout.
        let trunk = Trunks[sender.tag - 100]
        if trunk.follow == 0 {
            follow_bookmark_attend.call_followunfollow(type:"follow", follow_id: trunk.id, follow_type: "2", API: URLConstant.API.USER_FOLLOWACTION)
            
            if let index = Trunks.index(where: { $0.id == trunk.id }) {
                Trunks[index].follow = 1
            }
            
        } else {
            follow_bookmark_attend.call_followunfollow(type:"unfollow", follow_id: trunk.id, follow_type: "2", API: URLConstant.API.USER_UNFOLLOWACTION)
            
            if let index = Trunks.index(where: { $0.id == trunk.id }) {
                Trunks[index].follow = 0
            }
        }
        let indexPath = IndexPath(item: sender.tag - 100, section: 0)
        self.tableview.reloadRows(at: [indexPath], with: .fade)
    }
    
    func didRecieveFollowUpdate(response: String) {
    }

    // ------- Attend section  -------- //
    @objc func action_attend_unattend(sender: UIButton){
        
        // Fetches the appropriate trunks for the data source layout.
        let trunk = Trunks[sender.tag - 300]
        
        if trunk.attend == 0 {
            
            follow_bookmark_attend.call_attendunattend(type: "attend", attend_id: trunk.id, attend_type: "2", API: URLConstant.API.USER_ATTENDACTION)
            
            if let index = Trunks.index(where: { $0.id == trunk.id }) {
                Trunks[index].attend = 1
            }
            let messageTitle = "You are attending " + trunk.title + "."
            let alert = CustomAlert (title:"Huntsman",Message:messageTitle)
            alert.show(animated: true)

            let indexPath = IndexPath(item: sender.tag - 300, section: 0)
            self.tableview.reloadRows(at: [indexPath], with: .fade)

        } else {
            
            let messageTitle = "Are you sure you want to unattend  " + trunk.title + "?"
            let alert = UIAlertController(title: "Huntsman", message: messageTitle, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: handleConfirmUnattend(TrunkId:trunk.id  as NSString, TagIndex:sender.tag - 300 )
            ))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func handleConfirmUnattend(TrunkId:NSString ,TagIndex:Int) -> (_ alertAction:UIAlertAction) -> () {
        return { alertAction in
            self.follow_bookmark_attend.call_attendunattend(type: "unattend", attend_id: TrunkId as String, attend_type: "2", API: URLConstant.API.USER_UNATTENDACTION)
            
            if let index =  self.Trunks.index(where: { $0.id == TrunkId as String }) {
                 self.Trunks[index].attend = 0
            }
            let indexPath = IndexPath(item: TagIndex, section: 0)
            self.tableview.reloadRows(at: [indexPath], with: .fade)
        }
    }

    
    func didRecieveAttendUpdate(response: String, attendtype: String) {
    }
    
    // ------- Bookmark section  -------- //
    @objc func action_bookmark_unbookmark(sender: UIButton){
        
        // Fetches the appropriate trunks for the data source layout.
        let trunk = Trunks[sender.tag - 500]
        
        if trunk.bookmark == 0 {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "bookmark", bookmark_id: trunk.id, bookmark_type: "2", API: URLConstant.API.USER_BOOKMARKACTION)
            
            if let index = Trunks.index(where: { $0.id == trunk.id }) {
                Trunks[index].bookmark = 1
            }
            
        } else {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "unbookmark", bookmark_id: trunk.id, bookmark_type: "2", API: URLConstant.API.USER_UNBOOKMARKACTION)
            
            if let index = Trunks.index(where: { $0.id == trunk.id }) {
                Trunks[index].bookmark = 0
            }
        }
        
        let indexPath = IndexPath(item: sender.tag - 500, section: 0)
        self.tableview.reloadRows(at: [indexPath], with: .fade)
    }
    
    func didRecieveBookmarkUpdate(response: String) {
    }
    
    
    /* callupdateback call back function follow attent bookmark value update if click on trunkdetail */
    func callupdateback(_ id:NSString, _ updation:NSString, _ follow:Int, _ attend:Int, _ bookmark:Int)->()
    {
        if updation == "1"
        {
            // Fetches the appropriate trunks for the data source layout.
            if let index = Trunks.index(where: { $0.id == id as String }) {
                Trunks[index].follow = follow
                Trunks[index].attend = attend
                Trunks[index].bookmark = bookmark
                
                let indexPath = IndexPath(item: index, section: 0)
                self.tableview.reloadRows(at: [indexPath], with: .fade)
            }
        }
    }
    
}
