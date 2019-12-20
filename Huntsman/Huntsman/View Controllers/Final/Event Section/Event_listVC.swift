//
//  Event_listVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 10/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import EventKit

protocol Event_ListDelegate:class {
    func EventList_LoderShow()
    func EventList_LoderHide()
}

class Event_listVC: UIViewController ,IndicatorInfoProvider{
    
    var Events = [EventModel]()
    var filteredEvents = [EventModel]()
    var delegate:Event_ListDelegate?

    private let follow_bookmark_attend = Follow_Bookmark_Attend()
    
    var event_name = ""
    var event_startdate = ""
    var event_enddate = ""
    
    var intpage : Int = 0
    var more : Int!
    var pagereload : Int = 0
    
    var lodingApi: Bool!
    
    var Str_Page = ""
    var ApiCall = ""
    var Str_Type = ""
    var currentdate = ""
    var formatter = DateFormatter()
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var Btn_Upcoming: UIButton!
    @IBOutlet weak var Btn_past: UIButton!
    @IBOutlet  weak var Tf_Search: UITextField!
    
    //MARK: View Life Cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        ApiCall = "YES"
        
        tableview.estimatedRowHeight = 190.0
        tableview.rowHeight = UITableViewAutomaticDimension

        follow_bookmark_attend.delegate = self
        
        let date = Date()
        formatter.dateFormat = "dd-MM-yyyy"
        currentdate = formatter.string(from: date)
        print(currentdate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if ApiCall == "YES"
        {
            Str_Type = "upcoming"
            lodingApi = true
            pagereload = 0
            intpage = 0
            Str_Page = String(intpage)
            
            Btn_Upcoming.setTitleColor(UIColor.white, for: UIControlState.normal)
            Btn_past.setTitleColor(UIColor(red: 143/255.0,
                                           green: 0/255.0,
                                           blue: 42/255.0,
                                           alpha: 1.0), for: UIControlState.normal)
            Btn_past.backgroundColor = UIColor.white
            Btn_Upcoming.backgroundColor = UIColor(red: 143/255.0,
                                                   green: 0/255.0,
                                                   blue: 42/255.0,
                                                   alpha: 1.0)
            callEvent_GetAllEventAPI()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ApiCall = "YES"
    }
    
    // MARK: API callEvent_GetAllEventAPI
    func callEvent_GetAllEventAPI(strSearchText: String = "") {
        self.delegate?.EventList_LoderShow()
        
        let params = [
            URLConstant.Param.PAGE:Str_Page,
            URLConstant.Param.BOOKMARK:"0",
            URLConstant.Param.TYPE :Str_Type,
            URLConstant.Param.MONTH : "",
            URLConstant.Param.YEAR : "",
            URLConstant.Param.FILTERDATE : "",
            "str[search_string]": strSearchText
        ]
       /* URLConstant.API.EVENT_GETALLEVENT class in api name and params (for get all event upcoming and past according to str_type) */
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.EVENT_GETALLEVENT,view: self.view, params: params, success: { (response) in
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let TotalTrunk = json.value(forKey: "total_event") as? Int
                        if TotalTrunk == 0 {
                            
                            self.Events.removeAll()
                            self.filteredEvents.removeAll()
                            self.tableview.reloadData()
                            self.delegate?.EventList_LoderHide()
                            let alert = CustomAlert (title:"",Message:(json.value(forKey: "message") as? String)!)
                            alert.show(animated: true)

                        }
                        else
                        {
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
                            }
                            else
                            {
                                for item in Event_Array {
                                    
                                    guard let event = EventModel(id:((item as AnyObject).value(forKey: "id") as? String)!, photo: ((item as AnyObject).value(forKey: "image") as? String)!, date: ((item as AnyObject).value(forKey: "event_start_date") as? String)!, enddate: ((item as AnyObject).value(forKey: "event_end_date") as? String)!, title: ((item as AnyObject).value(forKey: "event_title") as? String)!, follow: ((item as AnyObject).value(forKey: "follow") as? Int)!, attend: ((item as AnyObject).value(forKey: "attend") as? Int)!, bookmark: ((item as AnyObject).value(forKey: "bookmark") as? Int)!) else {
                                        fatalError("Unable to instantiate meal2")
                                    }
                                    self.Events += [event]
                                }
                            }

                            self.lodingApi = true
                            self.tableview.reloadData()
                            self.delegate?.EventList_LoderHide()
                            
                        }
                    }
                    else {
                        self.delegate?.EventList_LoderHide()
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
            self.delegate?.EventList_LoderHide()
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
    
    
    // MARK: Button Actions
    @IBAction func Action_Upcoming(_ sender: Any) {
        
        Btn_Upcoming.setTitleColor(UIColor.white, for: UIControlState.normal)
        Btn_past.setTitleColor(UIColor(red: 143/255.0,
                                       green: 0/255.0,
                                       blue: 42/255.0,
                                       alpha: 1.0), for: UIControlState.normal)
        Btn_past.backgroundColor = UIColor.white
        Btn_Upcoming.backgroundColor = UIColor(red: 143/255.0,
                                               green: 0/255.0,
                                               blue: 42/255.0,
                                               alpha: 1.0)
        
        Tf_Search.text = ""
        Str_Type = "upcoming"
        lodingApi = true
        pagereload = 0
        intpage = 0
        Str_Page = String(intpage)
        
        callEvent_GetAllEventAPI()
    }
    
    @IBAction func Action_Past(_ sender: Any) {
        
        Btn_past.setTitleColor(UIColor.white, for: UIControlState.normal)
        Btn_Upcoming.setTitleColor(UIColor(red: 143/255.0,
                                           green: 0/255.0,
                                           blue: 42/255.0,
                                           alpha: 1.0), for: UIControlState.normal)
        Btn_past.backgroundColor = UIColor(red: 143/255.0,
                                           green: 0/255.0,
                                           blue: 42/255.0,
                                           alpha: 1.0)
        
        Btn_Upcoming.backgroundColor = UIColor.white
        
        
        Tf_Search.text = ""
        
        Str_Type = "past"
        lodingApi = true
        pagereload = 0
        intpage = 0
        Str_Page = String(intpage)
        callEvent_GetAllEventAPI()
    }
    
 
    func  CallBack_ForViewdisapper()->()
    {
        ApiCall = "NO"
    }
 
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "        List ",image:UIImage(named: "ListImg")!, highlightedImage:UIImage(named: "ListImg"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension Event_listVC:UITableViewDataSource, UITableViewDelegate, Follow_Bookmark_AttendDelegate, UIScrollViewDelegate, UITextFieldDelegate{
    
    // MARK: -   -------Table view delegate and datasource Method ----
    func tableView(_ table_view: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filteredEvents.count != 0 {
            return filteredEvents.count
        }
        return Events.count
    }
    
    func tableView(_ table_view: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table_view.dequeueReusableCell(withIdentifier: "Event_Cell", for: indexPath) as! Event_Cell
        cell.indexValue = indexPath.row
        cell.delegate = self
        // Fetches the appropriate trunks for the data source layout.
        let event : EventModel
        if filteredEvents.count != 0 {
            event = filteredEvents[indexPath.row]
        } else {
            event = Events[indexPath.row]
        }
        
        cell.Img_Event.sd_setImage(with: URL(string: event.photo), placeholderImage: UIImage(named: "no image"))
        
        let date = Date()
        let stringDate: String = date.usereventlistDate(str_date: event.date)
        let strEndDate: String = date.usereventlistDate(str_date: event.enddate)
        
        cell.Lbl_Date.text = stringDate + " to " + strEndDate
        cell.Lbl_EventTitle.text = event.title
        
        // ---- follow
        if event.follow != 0 {
            cell.Btn_follow .setImage(UIImage(named: "follow filled")!, for: UIControlState.normal)
        }
        else{
            cell.Btn_follow .setImage(UIImage(named: "follow")!, for: UIControlState.normal)
        }
        cell.Btn_follow.tag = 100 + indexPath.row
        cell.Btn_follow.addTarget(self, action: #selector(action_follow_unfollow), for: .touchUpInside)
        
        // ---- trunk
        let StrEnddate: String = date.UserEventEnddate(str_date: event.enddate)

        if event.attend != 0 {
            cell.Btn_Attendent .setImage(UIImage(named: "attend  filled")!, for: UIControlState.normal)
        }
        else {
            cell.Btn_Attendent .setImage(UIImage(named: "attend")!, for: UIControlState.normal)
        }
        if Calendar.current.compare(formatter.date(from:StrEnddate )!, to: formatter.date(from:currentdate )!, toGranularity: .day) == .orderedSame || Calendar.current.compare(formatter.date(from:currentdate )!, to: formatter.date(from:StrEnddate )!, toGranularity: .day) ==   .orderedAscending{
            cell.Btn_Attendent.isHidden = false
         //   cell.StakeViewWidth.constant = 134
        }
        else
        {
           // cell.StakeViewWidth.constant = 95
            cell.Btn_Attendent.isHidden = true
            cell.btnAttendantWidthConstraint.constant = 0.0
        }
        cell.Btn_Attendent.tag = 300 + indexPath.row
        cell.Btn_Attendent.addTarget(self, action: #selector(action_attend_unattend), for: .touchUpInside)
        
        // ---- bookmark
        if event.bookmark != 0{
            cell.Btn_BookMark .setImage(UIImage(named: "bookmark filled")!, for: UIControlState.normal)
        }
        else {
            cell.Btn_BookMark .setImage(UIImage(named: "Bookmark")!, for: UIControlState.normal)
        }
        cell.Btn_BookMark.tag = 500  + indexPath.row
        cell.Btn_BookMark.addTarget(self, action: #selector(action_bookmark_unbookmark), for: .touchUpInside)
        
        if Str_Type == "past" {
            cell.btn_Invite.alpha = 0.0
        } else {
            cell.btn_Invite.alpha = 1.0
        }
        
        return cell
    }
    
    func tableView(_ table_view: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ApiCall = "NO"
        let event : EventModel
        if filteredEvents.count != 0 {
            event = filteredEvents[indexPath.row]
        } else {
            event = Events[indexPath.row]
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let EventDetail = storyBoard.instantiateViewController(withIdentifier: "Event_DetailVC") as! Event_DetailVC
        EventDetail.EventId = event.id
        EventDetail.callupdatebackevent = callupdatebackevent
        EventDetail.CallBack_ForViewdisapper = CallBack_ForViewdisapper
        present(EventDetail, animated: true, completion: nil)
    }
    //lode more 
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
                    self.callEvent_GetAllEventAPI()
                }
            }
        } else {
            return;
        }
    }
    
    // ------- Follow unfollow section  -------- //
    @objc func action_follow_unfollow(sender: UIButton){
        // Fetches the appropriate trunks for the data source layout.
        let event : EventModel
        if filteredEvents.count != 0 {
            event = filteredEvents[sender.tag - 100]
        } else {
            event = Events[sender.tag - 100]
        }
        
        if event.follow == 0 {
            
            follow_bookmark_attend.call_followunfollow(type:"follow", follow_id: event.id, follow_type: "1", API: URLConstant.API.USER_FOLLOWACTION)

            if filteredEvents.count != 0 {
                if let index = Events.index(where: { $0.id == event.id }) {
                    Events[index].follow = 1
                }
                if let index = filteredEvents.index(where: { $0.id == event.id }) {
                    filteredEvents[index].follow = 1
                }
            }else
            {
                if let index = Events.index(where: { $0.id == event.id }) {
                    Events[index].follow = 1
                }
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
        let event : EventModel
        if filteredEvents.count != 0 {
            event = filteredEvents[sender.tag - 300]
        } else {
            event = Events[sender.tag - 300]
        }
        
        if event.attend == 0 {
            
            self.delegate?.EventList_LoderShow()
            follow_bookmark_attend.call_attendunattend(type: "attend", attend_id: event.id, attend_type: "1", API: URLConstant.API.USER_ATTENDACTION)

            if filteredEvents.count != 0 {
                if let index = Events.index(where: { $0.id == event.id }) {
                    Events[index].attend = 1
                }
                if let index = filteredEvents.index(where: { $0.id == event.id }) {
                    filteredEvents[index].attend = 1
                }
            }  else{
                
                if let index = Events.index(where: { $0.id == event.id }) {
                    Events[index].attend = 1
                }
            }
            
            event_name = event.title
            event_startdate = event.date
            event_enddate = event.enddate
            
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
            
            self.delegate?.EventList_LoderShow()

            self.follow_bookmark_attend.call_attendunattend(type: "unattend", attend_id: EventId as String, attend_type: "1", API: URLConstant.API.USER_UNATTENDACTION)
            
            if self.filteredEvents.count != 0 {
                if let index = self.Events.index(where: { $0.id == EventId as String }) {
                    self.Events[index].attend = 0
                }
                if let index = self.filteredEvents.index(where: { $0.id == EventId as String }) {
                    self.filteredEvents[index].attend = 0
                }
            }  else{
                if let index = self.Events.index(where: { $0.id == EventId as String }) {
                    self.Events[index].attend = 0
                }
            }
            let indexPath = IndexPath(item: TagIndex, section: 0)
            self.tableview.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    func didRecieveAttendUpdate(response: String, attendtype: String) {
        
        self.delegate?.EventList_LoderHide()
        if attendtype == "attend" {
            if response == "ok" {
                
                let eventStore: EKEventStore = EKEventStore()
                eventStore.requestAccess(to: .event, completion: {(granted, error) in
                    
                    if(granted) && (error == nil)
                    {
                        print(granted)
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        if dateFormatter.date(from: self.event_startdate) != nil && dateFormatter.date(from: self.event_enddate) != nil
                        {
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
                
//                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let invite = storyBoard.instantiateViewController(withIdentifier: "Invite_VC") as! Invite_VC
//                invite.event_title = self.event_name
//                present(invite, animated: true, completion: nil)
            }
        }
    }
    
    // ------- Bookmark section  -------- //
    @objc func action_bookmark_unbookmark(sender: UIButton){
        
        // Fetches the appropriate trunks for the data source layout.
        let event : EventModel
        if filteredEvents.count != 0 {
            event = filteredEvents[sender.tag - 500]
        } else {
            event = Events[sender.tag - 500]
        }
        
        if event.bookmark == 0 {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "bookmark", bookmark_id: event.id, bookmark_type: "1", API: URLConstant.API.USER_BOOKMARKACTION)
            
            if filteredEvents.count != 0 {
                if let index = Events.index(where: { $0.id == event.id }) {
                    Events[index].bookmark = 1
                }
                if let index = filteredEvents.index(where: { $0.id == event.id }) {
                    filteredEvents[index].bookmark = 1
                }
            } else {
                if let index = Events.index(where: { $0.id == event.id }) {
                    Events[index].bookmark = 1
                }
            }
            
        } else {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "unbookmark", bookmark_id: event.id, bookmark_type: "1", API: URLConstant.API.USER_UNBOOKMARKACTION)
            
            if filteredEvents.count != 0 {
                if let index = Events.index(where: { $0.id == event.id }) {
                    Events[index].bookmark = 0
                }
                if let index = filteredEvents.index(where: { $0.id == event.id }) {
                    filteredEvents[index].bookmark = 0
                }
            } else {
                if let index = Events.index(where: { $0.id == event.id }) {
                    Events[index].bookmark = 0
                }
            }
           
        }
        
        let indexPath = IndexPath(item: sender.tag - 500, section: 0)
        self.tableview.reloadRows(at: [indexPath], with: .fade)
    }
    
    func didRecieveBookmarkUpdate(response: String) {
    }
    
    func callupdatebackevent(_ id:NSString, _ updation:NSString, _ follow:Int, _ attend:Int, _ bookmark:Int)->()
    {
        if updation == "1"
        {
            if filteredEvents.count != 0 {
                // Fetches the appropriate trunks for the data source layout.
                if let index = Events.index(where: { $0.id == id as String }) {
                    Events[index].follow = follow
                    Events[index].attend = attend
                    Events[index].bookmark = bookmark
                }
                // Fetches the appropriate trunks for the data source layout.
                if let index = filteredEvents.index(where: { $0.id == id as String }) {
                    filteredEvents[index].follow = follow
                    filteredEvents[index].attend = attend
                    filteredEvents[index].bookmark = bookmark
                    
                    let indexPath = IndexPath(item: index, section: 0)
                    self.tableview.reloadRows(at: [indexPath], with: .fade)
                }
            } else {
                
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
    
    
    // Event list filter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        print(txtAfterUpdate)
        if txtAfterUpdate.count == 0 {
            self.Events = [EventModel]()
            callEvent_GetAllEventAPI()
        } else if txtAfterUpdate.count > 3 {
            callEvent_GetAllEventAPI(strSearchText: txtAfterUpdate)
        }
        self.delegate?.EventList_LoderHide()
        /*
        if string == " " {
        } else if string == "" {
            getSearchArrayContains(txtAfterUpdate)
        } else {
            getSearchArrayContains(txtAfterUpdate)
        } */
        tableview.reloadData()
        
        return true
    }
    
    func getSearchArrayContains(_ text : String) {
        if Events.count == 0 {
        } else {
            filteredEvents = Events.filter {
                return $0.title.range(of: text, options: .caseInsensitive) != nil
            }
            tableview.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            tableview.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

extension Event_listVC: EventDelegate {
    func inviteForEvent(index: Int) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let invite = storyBoard.instantiateViewController(withIdentifier: "Invite_VC") as! Invite_VC
        invite.event_title = Events[index].title
        present(invite, animated: true, completion: nil)
    }
}
