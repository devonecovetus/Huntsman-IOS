//
//  Event_CalenderVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 10/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import EventKit
// EventCalenderDelegate loder show hide
protocol EventCalenderDelegate: class {
    func EventCalenderLoderShow()
    func EventCalenderLoderHide()
}

class Event_CalenderVC: UIViewController,CalenderDelegate,IndicatorInfoProvider {

    var Events = [EventModel]()
    var delegate:EventCalenderDelegate?
    private let follow_bookmark_attend = Follow_Bookmark_Attend()
    
    var event_name = ""
    var event_startdate = ""
    var event_enddate = ""
    
    var Month :Int = 0
    var Year:Int = 0
    var Day:Int = 0
    
    var intpage : Int = 0
    var more : Int!
    var pagereload : Int = 0
    
    var lodingApi: Bool!
    
    var Str_Page = ""
    var Str_day = ""
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

        tableview.estimatedRowHeight = 190.0
        tableview.rowHeight = UITableViewAutomaticDimension
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        Month  = month
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
        loadapiFirst = true
        callUserEventCalendarAPI()
        ScrollView.addSubview(calenderView)
        calenderView.delegate = self
        calenderView.topAnchor.constraint(equalTo: ScrollView.topAnchor, constant: 10).isActive=true
        calenderView.rightAnchor.constraint(equalTo: ScrollView.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: ScrollView.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 365).isActive=true
        self.Lbl_Month_YPosition.constant = self.calenderView.frame.origin.y + self.calenderView.frame.size.height - 50
        ApiCall = "YES"
        formatter.dateFormat = "dd-MM-yyyy"
        currentdate = formatter.string(from: date)
        print(currentdate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if ApiCall == "YES" {
            if loadapiFirst == true  {
              loadapiFirst = false
            }  else { }
        }
    }
    
    // MARK: -   -------Calendar Delegate Method ----
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ApiCall = "YES"
    }
    
    lazy var  calenderView: CalenderView = {
        let calenderView = CalenderView(theme: MyTheme.light)
        calenderView.translatesAutoresizingMaskIntoConstraints=false
        return calenderView
    }()
    
    func didTap_PrivousMonth(date:String)  {
        print(date)
        let dateFmt = DateFormatter()
        dateFmt.timeZone = NSTimeZone.default
        dateFmt.dateFormat = "MMMM yyyy"
        
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
        callUserEventCalendarAPI()
    }
    
    func didTap_NextMonth(date:String)  {
        print(date)
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
        dateFormatter.dateFormat = "MMMM"
        let DateMonth = dateFormatter.string(from: date!)
        Lbl_Month.text = String(describing: DateMonth).uppercased()
        Str_day = ""
        callUserEventCalendarAPI()
    }
    
    func didTapDate(date: String, available: Bool)  {
        print("date = \(date)")
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        let date0 = df.date(from: date)
        df.dateFormat = "dd MMMM"
        let DateMonth0 = df.string(from: date0!)
        print("dd MMM - \(df.string(from: date0!))")
        Lbl_Month.text = String(describing: DateMonth0).uppercased()
        
        print(date)
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
    
    // MARK: -  ---Api Calling for Event Show in month ----
    func callUserEventCalendarAPI() {
        
        self.delegate?.EventCalenderLoderShow()
        
        let params = [
            URLConstant.Param.MONTH : Month,
            URLConstant.Param.YEAR : Year
        ]
        // user event calendar (for event date)
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.USER_EVENTCALENDAR,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let trunk_calendar = json.value(forKey: "event_calender") as? NSArray
                        if trunk_calendar?.count == 0{
                            UserDefaults.standard.removeObject(forKey:"allcalendarlist")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "load"), object: nil)
                            
                            self.Events.removeAll()
                            self.tableview.reloadData()
                            self.Table_ViewContaintSize.constant = self.tableview.contentSize.height + 10
                            self.Lbl_Status.text = "There are no event shows."
                            self.Lbl_Status.isHidden = false
                            self.delegate?.EventCalenderLoderHide()
                            self.Lbl_Month_YPosition.constant = self.calenderView.frame.origin.y + self.calenderView.frame.size.height - 50
                        } else{
                            var EventListArray = [Int] ()
                            for Item in trunk_calendar! {
                                let Date = ((Item as AnyObject).value(forKey: "date") as? String)!
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                
                                if dateFormatter.date(from: Date) != nil{
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
                            self.delegate?.EventCalenderLoderHide()
                            self.lodingApi = true
                            self.intpage = 0
                            self.pagereload = 0
                            self.Str_Page = String(self.intpage)
                            self.callLoginApi_SelectedMonth()
                        }
                    }  else {
                        if let msg = json.value(forKey:"message") as? String, msg == "Invalid auth token."{
                            UIUtil.showLogout(title: "", message:"It seems you logged-in on other device with same user. To continue with same device please log-in again.", controller: self, okHandler: nil)
                        } else {
                            UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                        }
                    }
                }
                self.delegate?.EventCalenderLoderHide()
            }
        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.EventCalenderLoderHide()
            if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)"   {
                UIUtil.showMessage(title: "No Internet Connection", message:"Make sure your device is connected to the internet.", controller: self, okHandler: nil)
            } else  {
                UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
            }
        }
    }
    
    // MARK: -   -------Api Calling for SelectedMonth ----
    func callLoginApi_SelectedMonth() {
        
        self.delegate?.EventCalenderLoderShow()
        let params = [
            URLConstant.Param.PAGE:Str_Page,
            URLConstant.Param.BOOKMARK:"0",
            URLConstant.Param.TYPE :"",
            URLConstant.Param.MONTH: String(Month),
            URLConstant.Param.YEAR :String(Year),
            URLConstant.Param.FILTERDATE :Str_day
        ]
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.EVENT_GETALLEVENT,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let TotalTrunk = json.value(forKey: "total_event") as? Int
                        if TotalTrunk == 0 {
                            
                            self.Events.removeAll()
                            self.tableview.reloadData()
                            self.Table_ViewContaintSize.constant = self.tableview.contentSize.height + 10
                            self.Lbl_Status.text = "There are no event show"
                            self.Lbl_Status.isHidden = false
                            self.delegate?.EventCalenderLoderHide()
                        } else  {
                            let str_more = json.value(forKey: "more") as? String
                            self.more = Int(str_more!)!
                            
                            let Event_Array = (json.value(forKey: "events")  as! NSMutableArray)
                            
                            if self.pagereload == 0 {
                                
                                self.Events.removeAll()
                                
                                for item in Event_Array {
                                    
                                    guard let event = EventModel(id:((item as AnyObject).value(forKey: "id") as? String)!, photo: ((item as AnyObject).value(forKey: "image") as? String)!, date: ((item as AnyObject).value(forKey: "event_start_date") as? String)!, enddate: ((item as AnyObject).value(forKey: "event_end_date") as? String)!, title: ((item as AnyObject).value(forKey: "event_title") as? String)!, follow: ((item as AnyObject).value(forKey: "follow") as? Int)!, attend: ((item as AnyObject).value(forKey: "attend") as? Int)!, bookmark: ((item as AnyObject).value(forKey: "bookmark") as? Int)!) else {
                                        fatalError("Unable to instantiate meal2")
                                    }
                                    self.Events += [event]
                                }
                            }  else  {
                                for item in Event_Array {
                                    
                                    guard let event = EventModel(id:((item as AnyObject).value(forKey: "id") as? String)!, photo: ((item as AnyObject).value(forKey: "image") as? String)!, date: ((item as AnyObject).value(forKey: "event_start_date") as? String)!, enddate: ((item as AnyObject).value(forKey: "event_end_date") as? String)!, title: ((item as AnyObject).value(forKey: "event_title") as? String)!, follow: ((item as AnyObject).value(forKey: "follow") as? Int)!, attend: ((item as AnyObject).value(forKey: "attend") as? Int)!, bookmark: ((item as AnyObject).value(forKey: "bookmark") as? Int)!) else {
                                        fatalError("Unable to instantiate meal2")
                                    }
                                    self.Events += [event]
                                }
                            }
                            
                            self.lodingApi = true
                            self.Lbl_Status.isHidden = true
                            self.Table_ViewContaintSize.constant = 250
                            self.tableview.reloadData()
                            self.tableview.layoutIfNeeded()
                            self.Table_ViewContaintSize.constant = self.tableview.contentSize.height + 10
                            self.delegate?.EventCalenderLoderHide()
                        }
                    } else {
                        self.delegate?.EventCalenderLoderHide()
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
            self.delegate?.EventCalenderLoderHide()
            
            if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)"  {
                UIUtil.showMessage(title: "No Internet Connection", message:"Make sure your device is connected to the internet.", controller: self, okHandler: nil)
            }   else {
                UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
            }
        }
    }
    
    func  CallBack_ForViewdisapper()->() {
        ApiCall = "NO"
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "        Calendar ",image:UIImage(named: "Calender")!, highlightedImage:UIImage(named: "Calender"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension Event_CalenderVC: UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate, Follow_Bookmark_AttendDelegate {
    
    // MARK: -   -------Table view delegate and datasource Method ----
    func tableView(_ table_view: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Events.count
    }
    
    func tableView(_ table_view: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table_view.dequeueReusableCell(withIdentifier: "Event_Cell", for: indexPath) as! Event_Cell

        // Fetches the appropriate trunks for the data source layout.
        let event = Events[indexPath.row]
        
        cell.Img_Event.sd_setImage(with: URL(string: event.photo), placeholderImage: UIImage(named: "no image"))
        
        let date = Date()
        let stringDate: String = date.usereventlistDate(str_date: event.date)
        let strEndDate: String = date.usereventlistDate(str_date: event.enddate)
        
        cell.Lbl_Date.text = stringDate + " to " + strEndDate
     //   cell.Lbl_Date.text = stringDate
        
        cell.Lbl_EventTitle.text = event.title
                
        // ---- follow
        if event.follow != 0 {
            cell.Btn_follow .setImage(UIImage(named: "follow filled")!, for: UIControlState.normal)
        }  else{
            cell.Btn_follow .setImage(UIImage(named: "follow")!, for: UIControlState.normal)
        }
        cell.Btn_follow.tag = 100 + indexPath.row
        cell.Btn_follow.addTarget(self, action: #selector(action_follow_unfollow), for: .touchUpInside)
        
        // ---- trunk
        
        if event.attend != 0 {
            cell.Btn_Attendent .setImage(UIImage(named: "attend  filled")!, for: UIControlState.normal)
        } else {
            cell.Btn_Attendent .setImage(UIImage(named: "attend")!, for: UIControlState.normal)
        }
        let StrEnddate: String = date.UserEventEnddate(str_date: event.enddate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        if Calendar.current.compare(dateFormatter.date(from:StrEnddate )!, to: dateFormatter.date(from:currentdate )!, toGranularity: .day) == .orderedSame || Calendar.current.compare(dateFormatter.date(from:currentdate )!, to: dateFormatter.date(from:StrEnddate )!, toGranularity: .day) ==   .orderedAscending{
            cell.Btn_Attendent.isHidden = false
        //    cell.StakeViewWidth.constant = 134
        }  else {
        //    cell.StakeViewWidth.constant = 95
            cell.Btn_Attendent.isHidden = true
            cell.btnAttendantWidthConstraint.constant = 0.0
        }
        cell.Btn_Attendent.tag = 300 + indexPath.row
        cell.Btn_Attendent.addTarget(self, action: #selector(action_attend_unattend), for: .touchUpInside)
        
        // ---- bookmark
        if event.bookmark != 0{
            cell.Btn_BookMark .setImage(UIImage(named: "bookmark filled")!, for: UIControlState.normal)
        } else {
            cell.Btn_BookMark .setImage(UIImage(named: "Bookmark")!, for: UIControlState.normal)
        }
        cell.Btn_BookMark.tag = 500  + indexPath.row
        cell.Btn_BookMark.addTarget(self, action: #selector(action_bookmark_unbookmark), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ table_view: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ApiCall = "NO"
        
        // Fetches the appropriate trunks for the data source layout.
        let event = Events[indexPath.row]
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let EventDetail = storyBoard.instantiateViewController(withIdentifier: "Event_DetailVC") as! Event_DetailVC
        EventDetail.EventId = event.id
        EventDetail.callupdatebackevent = callupdatebackevent
        EventDetail.CallBack_ForViewdisapper = CallBack_ForViewdisapper
        present(EventDetail, animated: true, completion: nil)
    }
  /*
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
                    self.callLoginApi_SelectedMonth()
                }
            }
        } else {
            return;
        }
    }
    */
    // ------- Follow unfollow section  -------- //
    @objc func action_follow_unfollow(sender: UIButton){
        
        // Fetches the appropriate trunks for the data source layout.
        let event = Events[sender.tag - 100]
        
        if event.follow == 0 {
            follow_bookmark_attend.call_followunfollow(type:"follow", follow_id: event.id, follow_type: "1", API: URLConstant.API.USER_FOLLOWACTION)
            
            if let index = Events.index(where: { $0.id == event.id }) {
                Events[index].follow = 1
            }
        } else {
            follow_bookmark_attend.call_followunfollow(type:"unfollow", follow_id: event.id, follow_type: "1", API: URLConstant.API.USER_UNFOLLOWACTION)
            
            if let index = Events.index(where: { $0.id == event.id }) {
                Events[index].follow = 0
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
        let event = Events[sender.tag - 300]
        
        if event.attend == 0 {
            self.delegate?.EventCalenderLoderShow()
            follow_bookmark_attend.call_attendunattend(type: "attend", attend_id: event.id, attend_type: "1", API: URLConstant.API.USER_ATTENDACTION)
            
            event_name = event.title
            event_startdate = event.date
            event_enddate = event.enddate
            
            if let index = Events.index(where: { $0.id == event.id }) {
                Events[index].attend = 1
            }
            
            let indexPath = IndexPath(item: sender.tag - 300, section: 0)
            self.tableview.reloadRows(at: [indexPath], with: .fade)

        } else {

            let messageTitle = "Are you sure you want to unattend  " + event.title + "?"
            let alert = UIAlertController(title: "Huntsman", message: messageTitle, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: handleConfirmUnattend(EventId:event.id  as NSString, TagIndex:sender.tag - 300 )
            ))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleConfirmUnattend(EventId:NSString ,TagIndex:Int) -> (_ alertAction:UIAlertAction) -> () {
        return { alertAction in
            
            self.delegate?.EventCalenderLoderShow()
            self.follow_bookmark_attend.call_attendunattend(type: "unattend", attend_id: EventId as String, attend_type: "1", API: URLConstant.API.USER_UNATTENDACTION)
            
            if let index = self.Events.index(where: { $0.id ==  EventId as String }) {
                self.Events[index].attend = 0
            }
            let indexPath = IndexPath(item: TagIndex, section: 0)
            self.tableview.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    func didRecieveAttendUpdate(response: String, attendtype: String) {
        
        self.delegate?.EventCalenderLoderHide()
        if attendtype == "attend" {
            if response == "ok" {
                
                let eventStore: EKEventStore = EKEventStore()
                eventStore.requestAccess(to: .event, completion: {(granted, error) in
                    
                    if(granted) && (error == nil)  {
                        print(granted)

                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        if  dateFormatter.date(from: self.event_startdate) != nil && dateFormatter.date(from: self.event_enddate) != nil  {
                            
                            let startdate = dateFormatter.date(from: self.event_startdate)!
                            let enddate = dateFormatter.date(from: self.event_enddate)!
                            
                            let event:EKEvent = EKEvent(eventStore: eventStore)
                            event.title = self.event_name
                            event.startDate = startdate
                            event.endDate = enddate
                            event.calendar = eventStore.defaultCalendarForNewEvents
                            do{
                                try eventStore.save(event, span: .thisEvent)
                            }catch let error as NSError{
                                print(error)
                            }
                        }
                        print("save event")
                    }
                    else{
                        print("error : \(String(describing: error))")
                    }
                })
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let invite = storyBoard.instantiateViewController(withIdentifier: "Invite_VC") as! Invite_VC
                invite.event_title = self.event_name
                present(invite, animated: true, completion: nil)
            }
        }
    }

    // ------- Bookmark section  -------- //
    @objc func action_bookmark_unbookmark(sender: UIButton){
        
        // Fetches the appropriate trunks for the data source layout.
        let event = Events[sender.tag - 500]
        
        if event.bookmark == 0 {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "bookmark", bookmark_id: event.id, bookmark_type: "1", API: URLConstant.API.USER_BOOKMARKACTION)
            
            if let index = Events.index(where: { $0.id == event.id }) {
                Events[index].bookmark = 1
            }
            
        } else {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "unbookmark", bookmark_id: event.id, bookmark_type: "1", API: URLConstant.API.USER_UNBOOKMARKACTION)
            
            if let index = Events.index(where: { $0.id == event.id }) {
                Events[index].bookmark = 0
            }
        }
        let indexPath = IndexPath(item: sender.tag - 500, section: 0)
        self.tableview.reloadRows(at: [indexPath], with: .fade)
    }
    
    func didRecieveBookmarkUpdate(response: String) {
    }
    
    func callupdatebackevent(_ id:NSString, _ updation:NSString, _ follow:Int, _ attend:Int, _ bookmark:Int)->()
    {
        if updation == "1" {
            // Fetches the appropriate trunks for the data source layout.
            if let index = Events.index(where: { $0.id == id as String }) {
                Events[index].follow = follow
                Events[index].attend = attend
                Events[index].bookmark = bookmark
                
                let indexPath = IndexPath(item: index, section: 0)
                self.tableview.reloadRows(at: [indexPath], with: .fade)
            }
        }
    }
}

