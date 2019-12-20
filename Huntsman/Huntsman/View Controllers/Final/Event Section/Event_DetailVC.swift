//
//  Event_DetailVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 11/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import MapKit
import EventKit

class Event_DetailVC: UIViewController, Follow_Bookmark_AttendDelegate {
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    private let follow_bookmark_attend = Follow_Bookmark_Attend()
    
    var event_name = ""
    var event_startdate = ""
    var event_enddate = ""
    
    var DestinationLatitude = ""
    var DestinationLongitude = ""

    @IBOutlet weak var view_location: UIView!
    @IBOutlet weak var view_description: UIView!
    @IBOutlet weak var StakeViewWidth: NSLayoutConstraint!

    
    @IBOutlet weak var img_view: UIImageView?
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    
    @IBOutlet weak var map: MKMapView!
   
    
    @IBOutlet weak var lbl_desc: UILabel!
    @IBOutlet weak var btn_bookmark: UIButton!
    @IBOutlet weak var btn_follow: UIButton!
    @IBOutlet weak var btn_attend: UIButton!
    
    var EventId = ""
    
    var flag_updation = "0"
    var flag_follow = 0
    var flag_attend = 0
    var flag_bookmark = 0

    var Is_Follow:Bool?
    var Is_BookMark:Bool?
    var Is_Attend:Bool?
    var currentdate = ""
    var formatter = DateFormatter()
    var BackNotification_Vc = ""

    // call back function ...
    var CallBack_ForViewdisapper :(()->())?
    var callupdatebackevent:((_ id:NSString, _ updation:NSString, _ follow:Int, _ attend:Int, _ bookmark:Int)->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        currentLocation = locationManager.location

        
        let date = Date()
        formatter.dateFormat = "dd-MM-yyyy"
        currentdate = formatter.string(from: date)
        requestLocationAccess()
        follow_bookmark_attend.delegate = self

        // Do any additional setup after loading the view.
        view_location = UIUtil.dropShadow(view: view_location, color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        view_description = UIUtil.dropShadow(view: view_description, color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        
        btn_bookmark = UIUtil.dropShadowButton(button:btn_bookmark)
        btn_follow = UIUtil.dropShadowButton(button:btn_follow)
        btn_attend = UIUtil.dropShadowButton(button:btn_attend)
        
        callDetailAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.CallBack_ForViewdisapper?()
    }
    
    @IBAction func ActionGetDirection(sender: AnyObject?)
    {
        self.map.delegate = self
        let url = "http://maps.apple.com/?saddr=\(Double((currentLocation?.coordinate.latitude)!)),\(Double( (currentLocation?.coordinate.longitude)!))&daddr=\(Double(DestinationLatitude)),\(Double(DestinationLongitude))"
        UIApplication.shared.openURL(URL(string:url)!)
    }
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: API callDetailAPI
    func callDetailAPI() {
        LoderGifView.MyloaderShow(view: self.view)
        let params = [
            URLConstant.Param.EVENTDETAIL:EventId
        ]
      //  URLConstant.API.EVENTDETAIL get event detail
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.EVENTDETAIL,view: self.view, params: params, success: { (response) in
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        
                        let events = json.value(forKey: "events") as? NSArray
                        let data =  events![0] as! NSDictionary
                        
                        if let event_pic = (data as AnyObject).value(forKey:"image") as? String, event_pic != "" {
                            self.img_view?.sd_setImage(with: URL(string: event_pic), placeholderImage: UIImage(named: "no image"))
                        }else {
                            self.img_view?.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "no image"))
                        }
                        
                        // ------ BOOKMARK ------
                        if let bookmark = ((data as AnyObject).value(forKey: "bookmark")as? Int), bookmark != 0 {
                            self.btn_bookmark .setImage(UIImage(named: "bookmark filled")!, for: UIControlState.normal)
                            self.Is_BookMark = true
                            self.flag_bookmark = 1
                        } else {
                            self.btn_bookmark .setImage(UIImage(named: "Bookmark")!, for: UIControlState.normal)
                            self.Is_BookMark = false
                            self.flag_bookmark = 0
                        }
                        
                        // ------ FOLLOW ------
                        if let follow = ((data as AnyObject).value(forKey: "follow") as? Int), follow != 0 {
                            self.flag_follow = 1
                            self.btn_follow .setImage(UIImage(named: "follow filled")!, for: UIControlState.normal)
                            self.Is_Follow = true
                        } else {
                            self.flag_follow = 0
                            self.btn_follow .setImage(UIImage(named: "follow")!, for: UIControlState.normal)
                            self.Is_Follow = false
                        }
                        
                        // ------ ATTEND ------
                        
                        if let attend = ((data as AnyObject).value(forKey: "attend") as? Int), attend != 0 {
                            self.flag_attend = 1
                            self.btn_attend .setImage(UIImage(named: "attend  filled")!, for: UIControlState.normal)
                            self.Is_Attend = true
                        } else {
                            self.flag_attend = 0
                            self.btn_attend .setImage(UIImage(named: "attend")!, for: UIControlState.normal)
                            self.Is_Attend = false
                        }
                        
                        let StrDate:String = String(format: "%@", ((data as AnyObject).value(forKey: "event_end_date")) as! CVarArg)

                        let StrEnddate: String = self.UserEventEnddate(str_date:StrDate)
                        
                        if Calendar.current.compare(self.formatter.date(from:StrEnddate )!, to: self.formatter.date(from:self.currentdate )!, toGranularity: .day) == .orderedSame || Calendar.current.compare(self.formatter.date(from:self.currentdate )!, to: self.formatter.date(from:StrEnddate )!, toGranularity: .day) ==   .orderedAscending{
                            self.btn_attend.isHidden = false
                        }
                        else
                        {
                            self.btn_attend.isHidden = true
                            self.StakeViewWidth.constant = 85
                        }
                        
                        self.flag_updation = "0"
                        self.lbl_title.text = ((data as AnyObject).value(forKey: "event_title") as? String)!
                        
                        self.event_name = ((data as AnyObject).value(forKey: "event_title") as? String)!
                        self.event_startdate = self.getCurrentDate(date:((data as AnyObject).value(forKey: "event_start_date") as? String)!)
                        self.event_enddate = self.getCurrentDate(date:((data as AnyObject).value(forKey: "event_end_date") as? String)!)
                        
                        self.lbl_date.text = "From " + self.event_startdate + " To " + self.event_enddate
                        
                        self.lbl_address.text = ((data as AnyObject).value(forKey: "event_address") as? String)!
                        
                        let str_lat =  ((data as AnyObject).value(forKey: "latitude") as? String)!
                        let lat = Double(str_lat)
                        let str_long = ((data as AnyObject).value(forKey: "longitude") as? String)!
                        let longtude = Double(str_long)
                        
                        self.DestinationLatitude = str_lat
                        self.DestinationLongitude = str_long
                        
                        let location = CLLocationCoordinate2D(latitude: lat, longitude: longtude)
                        // 2
                        let span = MKCoordinateSpanMake(0.05, 0.05)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.map.setRegion(region, animated: true)
                        
                        //3
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = "Huntsman"
                        annotation.subtitle = ((data as AnyObject).value(forKey: "event_title") as? String)!
                        self.map.addAnnotation(annotation)
                        self.map.delegate = self
                        
                        self.lbl_desc.text = ((data as AnyObject).value(forKey: "event_desc") as? String)!
                        
                        LoderGifView.MyloaderHide(view: self.view)
                    }
                    else {
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
            print(error.localizedDescription)
            LoderGifView.MyloaderHide(view: self.view)
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
    
    func getCurrentDate(date:String)-> String {
        
        let dateFmt = DateFormatter()
        dateFmt.timeZone = NSTimeZone.default
        dateFmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var result = ""
        if dateFmt.date(from: date) != nil
        {
        let datestr = dateFmt.date(from: date)
        dateFmt.dateFormat = "dd MMM yyyy - HH:mm a"
        result = dateFmt.string(from: datestr!)
        }
        else
        {
        result = ""
        }
        return result

    }
    func UserEventEnddate(str_date:String) -> String {
        // Customize a date formatter
        var dateString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if dateFormatter.date(from: str_date) != nil {
            let date = dateFormatter.date(from: str_date)!
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dateString = dateFormatter.string(from:date)
        }
        else
        {
            dateString = ""
        }
        return dateString
    }
    
    
   
    
    // MARK: ------- Follow unfollow section --------//
    @IBAction func Action_Follow_Unfollow(_ sender: Any)
    {
        if Is_Follow == true
        {
            follow_bookmark_attend.call_followunfollow(type:"unfollow", follow_id: EventId, follow_type: "1", API: URLConstant.API.USER_UNFOLLOWACTION)

            self.btn_follow .setImage(UIImage(named: "follow")!, for: UIControlState.normal)

            self.flag_updation = "1"
            self.flag_follow = 0
            self.Is_Follow = false
        }
        else
        {
            follow_bookmark_attend.call_followunfollow(type:"follow", follow_id: EventId, follow_type: "1", API: URLConstant.API.USER_FOLLOWACTION)

            self.btn_follow .setImage(UIImage(named: "follow filled")!, for: UIControlState.normal)
            
            self.flag_updation = "1"
            self.flag_follow = 1
            self.Is_Follow = true
        }
    }
    func didRecieveFollowUpdate(response: String) {
    }
    
    func didRecieveBookmarkUpdate(response: String) {
        
    }
    
    
    // MARK: ------- Attend unattend section --------//
    @IBAction func Action_Attend_Notattend(_ sender: Any)
    {
        if Is_Attend == true
        {
            let messageTitle = "Are you sure you want to unattend  " +  self.lbl_title.text! + "?"
            let alert = UIAlertController(title: "Huntsman", message: messageTitle, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: handleConfirmUnattend(EventId:EventId as NSString )
            ))
            self.present(alert, animated: true, completion: nil)
        } else
        {
            LoderGifView.MyloaderShow(view: self.view)

            follow_bookmark_attend.call_attendunattend(type: "attend", attend_id: EventId, attend_type: "1", API: URLConstant.API.USER_ATTENDACTION)
            self.btn_attend .setImage(UIImage(named: "attend  filled")!, for: UIControlState.normal)
            
            self.flag_updation = "1"
            self.flag_attend = 1
            self.Is_Attend = true
        }
    }
    
    
    func handleConfirmUnattend(EventId:NSString ) -> (_ alertAction:UIAlertAction) -> () {
        return { alertAction in
            
            LoderGifView.MyloaderShow(view: self.view)
            self.follow_bookmark_attend.call_attendunattend(type: "unattend", attend_id: EventId as String, attend_type: "1", API: URLConstant.API.USER_UNATTENDACTION)
            self.btn_attend .setImage(UIImage(named: "attend")!, for: UIControlState.normal)
            self.flag_updation = "1"
            self.flag_attend = 0
            self.Is_Attend = false
        }
    }
    
    
    func didRecieveAttendUpdate(response: String, attendtype: String) {
        
        LoderGifView.MyloaderHide(view: self.view)
        
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
                            let startdate = dateFormatter.date(from: self.event_startdate)
                            let enddate = dateFormatter.date(from: self.event_enddate)
                            
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
                invite.event_title = event_name
                present(invite, animated: true, completion: nil)
            }
        }
    }
  
    // MARK: ------- Bookmark unbbokmark section --------//
    @IBAction func Action_Bookmark_Unbookmark(_ sender: Any)
    {
        if Is_BookMark == true
        {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "unbookmark", bookmark_id: EventId, bookmark_type: "1", API: URLConstant.API.USER_UNBOOKMARKACTION)
            
            self.btn_bookmark .setImage(UIImage(named: "Bookmark")!, for: UIControlState.normal)
            
            self.flag_updation = "1"
            self.flag_bookmark = 0
            self.Is_BookMark = false
        }
        else
        {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "bookmark", bookmark_id: EventId, bookmark_type: "1", API: URLConstant.API.USER_BOOKMARKACTION)
            
            self.btn_bookmark .setImage(UIImage(named: "bookmark filled")!, for: UIControlState.normal)
            
            self.flag_updation = "1"
            self.flag_bookmark = 1
            self.Is_BookMark = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func crossClick(sender: AnyObject?){
        if BackNotification_Vc == "PushNotifcation" {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.rootview_views(string: "discover")
        } else {
        callupdatebackevent?(EventId as NSString, flag_updation as NSString, flag_follow, flag_attend, flag_bookmark)
        self.dismiss(animated: true, completion: nil)
        }
    }
}

extension Event_DetailVC: MKMapViewDelegate {
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
