//
//  Event_tablecell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 20/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import EventKit

protocol Event_tablecell_DiscoverDelegate {
    func Event_DiscoverEvents(event_title:String, type:String, event_id:String, attend:String)
    func Event_DiscoverUnattendAlert(event_title:String, type:String, event_id:String, TagIndex:Int)
}

class Event_tablecell: UITableViewCell {
    
   
    var Events = [EventModel]()
    var Is_UnattendExist:Bool?

    private let follow_bookmark_attend = Follow_Bookmark_Attend()

    var event_name = ""
    var event_startdate = ""
    var event_enddate = ""

    @IBOutlet weak var collectionevent: UICollectionView!
    var delegate:Event_tablecell_DiscoverDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        follow_bookmark_attend.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(Event_tablecell.EventHandlerUnattend), name: NSNotification.Name(rawValue: "EventUnattentNotification"), object: nil)

    }
}

extension Event_tablecell : UICollectionViewDataSource, Follow_Bookmark_AttendDelegate  {
  
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Event_collectioncell", for: indexPath) as! Event_collectioncell
        
        let event = Events[indexPath.row]
        
        cell.Img_Event.sd_setImage(with: URL(string: event.photo), placeholderImage: UIImage(named: "no image"))

        let date = Date()
        let stringDate: String = date.usereventlistDate(str_date: event.date)
        cell.Lbl_Date.text = stringDate
        
        cell.Lbl_EventTitle.text = event.title
        
        // ---- follow
        if event.follow != 0 {
            cell.Btn_like .setImage(UIImage(named: "follow filled")!, for: UIControlState.normal)
        } else{
            cell.Btn_like .setImage(UIImage(named: "follow")!, for: UIControlState.normal)
        }
        cell.Btn_like.tag = 100 + indexPath.row
        cell.Btn_like.addTarget(self, action: #selector(action_follow_unfollow), for: .touchUpInside)
        
        // ---- trunk
        if event.attend != 0 {
            cell.Btn_Attendent .setImage(UIImage(named: "attend  filled")!, for: UIControlState.normal)
        }  else {
            cell.Btn_Attendent .setImage(UIImage(named: "attend")!, for: UIControlState.normal)
        }
        cell.Btn_Attendent.tag = 300 + indexPath.row
        cell.Btn_Attendent.addTarget(self, action: #selector(action_attend_unattend), for: .touchUpInside)
        
        // ---- bookmark
        if event.bookmark != 0{
            cell.Btn_BookMark .setImage(UIImage(named: "bookmark filled")!, for: UIControlState.normal)
        }  else {
            cell.Btn_BookMark .setImage(UIImage(named: "Bookmark")!, for: UIControlState.normal)
        }
        cell.Btn_BookMark.tag = 500  + indexPath.row
        cell.Btn_BookMark.addTarget(self, action: #selector(action_bookmark_unbookmark), for: .touchUpInside)
        
        return cell
    }
    
    // ------- Follow unfollow section  -------- //
    @objc func action_follow_unfollow(sender: UIButton){
        // Fetches the appropriate trunks for the data source layout.
        let event  = Events[sender.tag - 100]

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
        self.collectionevent.reloadItems(at: [indexPath])
    }
    
    func didRecieveFollowUpdate(response: String) {
    }
    
    // ------- Attend section  -------- //
    @objc func action_attend_unattend(sender: UIButton){
        
        let event = Events[sender.tag - 300]
        if event.attend == 0 {
            
            delegate?.Event_DiscoverEvents(event_title:"", type: "show_loader", event_id: "", attend: "")
            follow_bookmark_attend.call_attendunattend(type: "attend", attend_id: event.id, attend_type: "1", API: URLConstant.API.USER_ATTENDACTION)
            
            if let index = Events.index(where: { $0.id == event.id }) {
                Events[index].attend = 1
            }
            
            event_name = event.title
            event_startdate = event.date
            event_enddate = event.enddate
            let indexPath = IndexPath(item: sender.tag - 300, section: 0)
            self.collectionevent.reloadItems(at: [indexPath])

        } else {

            delegate?.Event_DiscoverUnattendAlert(event_title:event.title, type: "AlertShow", event_id:event.id , TagIndex: sender.tag - 300 )
            Is_UnattendExist = true
        }
    }
    @objc func EventHandlerUnattend(notification: NSNotification)
    {
        if Is_UnattendExist == true
        {
        print(notification)
        Is_UnattendExist = false
        let myDict = notification.object as? [String: Any]
        let Str_Index = myDict!["Tag_Index"]

        follow_bookmark_attend.call_attendunattend(type: "unattend", attend_id: (myDict! ["Event_Id"] as? String)!, attend_type: "1", API: URLConstant.API.USER_UNATTENDACTION)
        if let index = Events.index(where: { $0.id == (myDict! ["Event_Id"] as? String)! }) {
            Events[index].attend = 0
        }
        let indexPath = IndexPath(item: Str_Index as! Int, section: 0)
        self.collectionevent.reloadItems(at: [indexPath])
        }
    }
    
    func didRecieveAttendUpdate(response: String, attendtype: String) {

        if attendtype == "attend" {
            if response == "ok" {
                
                let eventStore: EKEventStore = EKEventStore()
                eventStore.requestAccess(to: .event, completion: {(granted, error) in
                    
                    if(granted) && (error == nil)
                    {
                        print(granted)
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        if  dateFormatter.date(from: self.event_startdate) != nil && dateFormatter.date(from: self.event_enddate) != nil {
                            
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
            }
        }
        delegate?.Event_DiscoverEvents(event_title:self.event_name, type: "hide_loader", event_id: "", attend: attendtype)
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
        self.collectionevent.reloadItems(at: [indexPath])
    }
    func didRecieveBookmarkUpdate(response: String) {
    }
}

extension Event_tablecell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = Events[indexPath.row]
        delegate?.Event_DiscoverEvents(event_title:"", type: "detail", event_id: event.id, attend: "")
    }
    
}


