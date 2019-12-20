//
//  Trunk_DetailVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 06/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import MapKit

class Trunk_DetailVC: UIViewController, Follow_Bookmark_AttendDelegate {
    
    private let follow_bookmark_attend = Follow_Bookmark_Attend()
    
    @IBOutlet weak var view_location: UIView!
    @IBOutlet weak var view_description: UIView!
    @IBOutlet weak var view_contact: UIView!
    
    @IBOutlet weak var img_trunk: UIImageView?
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var map: MKMapView!
    let locationManager = CLLocationManager()
        
    @IBOutlet weak var lbl_desc: UILabel!
    @IBOutlet weak var lbl_telephone: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var btn_bookmark: UIButton!
    @IBOutlet weak var btn_follow: UIButton!
    @IBOutlet weak var btn_attend: UIButton!
    @IBOutlet weak var StakeViewWidth: NSLayoutConstraint!

    @IBOutlet weak var lbl_branch: UILabel!
    
    var TrunkId = ""
    
    var flag_updation = "0"
    var flag_follow = 0
    var flag_attend = 0
    var flag_bookmark = 0
    var Is_Follow:Bool?
    var Is_BookMark:Bool?
    var Is_Attend:Bool?
    var currentdate = ""
    var BackNotification_Vc = ""

    var formatter = DateFormatter()
    var CallBack_ForViewdisapper :(()->())?
    var callupdateback:((_ id:NSString, _ updation:NSString, _ follow:Int, _ attend:Int, _ bookmark:Int)->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocationAccess()
        let date = Date()
        formatter.dateFormat = "dd-MM-yyyy"
        currentdate = formatter.string(from: date)
        follow_bookmark_attend.delegate = self
        
        view_location = UIUtil.dropShadow(view: view_location, color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        view_description = UIUtil.dropShadow(view: view_description, color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        view_contact = UIUtil.dropShadow(view: view_contact, color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)

        btn_bookmark = UIUtil.dropShadowButton(button:btn_bookmark)
        btn_follow = UIUtil.dropShadowButton(button:btn_follow)
        btn_attend = UIUtil.dropShadowButton(button:btn_attend)

        callDetailAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.CallBack_ForViewdisapper?()
    }
    
    // MARK: API Calls
    func callDetailAPI() {
        LoderGifView.MyloaderShow(view: self.view)
        let params = [
            URLConstant.Param.TRUNKDETAIL:TrunkId
        ]
        
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.TRUNKDETAIL,view: self.view, params: params, success: { (response) in
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let TotalTrunk = json.value(forKey: "trunks") as? NSArray
                        if TotalTrunk?.count ==  0 {
                            LoderGifView.MyloaderHide(view: self.view)
                            UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                        }
                        else {
                            let trunks = json.value(forKey: "trunks") as? NSArray
                            let data =  trunks![0] as! NSDictionary
                            
                            print("data  \(data)")
                            
                            if let trunk_pic = (data as AnyObject).value(forKey:"image") as? String, trunk_pic != "" {
                                self.img_trunk?.sd_setImage(with: URL(string: trunk_pic), placeholderImage: UIImage(named: "no image"))
                            }else {
                                self.img_trunk?.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "no image"))
                            }
                            
                            if let bookmark = ((data as AnyObject).value(forKey: "bookmark")as? Int), bookmark != 0 {
                                self.flag_bookmark = 1
                                self.btn_bookmark .setImage(UIImage(named: "bookmark filled")!, for: UIControlState.normal)
                                self.Is_BookMark = true
                            } else {
                                self.flag_bookmark = 0
                                self.btn_bookmark .setImage(UIImage(named: "Bookmark")!, for: UIControlState.normal)
                                self.Is_BookMark = false
                            }
                            
                            if let follow = ((data as AnyObject).value(forKey: "follow") as? Int), follow != 0 {
                                self.flag_follow = 1
                                self.btn_follow .setImage(UIImage(named: "follow filled")!, for: UIControlState.normal)
                                self.Is_Follow = true
                            } else {
                                self.flag_follow = 0
                                self.btn_follow .setImage(UIImage(named: "follow")!, for: UIControlState.normal)
                                self.Is_Follow = false
                            }
                            
                            if let attend = ((data as AnyObject).value(forKey: "attend") as? Int), attend != 0 {
                                self.flag_attend = 1
                                self.btn_attend .setImage(UIImage(named: "attend  filled")!, for: UIControlState.normal)
                                self.Is_Attend = true
                            } else {
                                self.flag_attend = 0
                                self.btn_attend .setImage(UIImage(named: "attend")!, for: UIControlState.normal)
                                self.Is_Attend = false
                            }
                            
                            let StrEnddate: String = self.UserEventEnddate(str_date:((data as AnyObject).value(forKey: "trunk_end_date") as? String)!)
                            
                            if Calendar.current.compare(self.formatter.date(from:StrEnddate )!, to: self.formatter.date(from:self.currentdate )!, toGranularity: .day) == .orderedSame || Calendar.current.compare(self.formatter.date(from:self.currentdate )!, to: self.formatter.date(from:StrEnddate )!, toGranularity: .day) ==   .orderedAscending{
                                self.btn_attend.isHidden = false
                            }
                            else
                            {
                                self.btn_attend.isHidden = true
                                self.StakeViewWidth.constant = 85

                            }

                            
                            self.flag_updation = "0"
                            self.lbl_title.text = ((data as AnyObject).value(forKey: "trunk_title") as? String)!
                            
                            let startdate = self.getCurrentDate(date:((data as AnyObject).value(forKey: "trunk_start_date") as? String)!)
                            let lastedate = self.getCurrentDate(date:((data as AnyObject).value(forKey: "trunk_end_date") as? String)!)
                            
                            self.lbl_date.text = "From " + startdate + " To " + lastedate
                            
                            self.lbl_address.text = ((data as AnyObject).value(forKey: "address") as? String)!
                            
                            self.lbl_telephone.text = ((data as AnyObject).value(forKey: "contact") as? String)!
                            
                            self.lbl_branch.text = ((data as AnyObject).value(forKey: "organizer") as? String)!
                            
                            self.lbl_email.text = ((data as AnyObject).value(forKey: "email") as? String)!
                            
                            let str_lat =  ((data as AnyObject).value(forKey: "latitude") as? String)!
                            let lat = Double(str_lat)
                            let str_long = ((data as AnyObject).value(forKey: "longitude") as? String)!
                            let longtude = Double(str_long)
                            
                            let location = CLLocationCoordinate2D(latitude: lat,
                                                                  longitude: longtude)
                            // 2
                            let span = MKCoordinateSpanMake(0.05, 0.05)
                            let region = MKCoordinateRegion(center: location, span: span)
                            self.map.setRegion(region, animated: true)
                            
                            //3
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = location
                            annotation.title = "Huntsman"
                            annotation.subtitle = ((data as AnyObject).value(forKey: "trunk_title") as? String)!
                            self.map.addAnnotation(annotation)
                            self.map.delegate = self
                            
                            self.lbl_desc.text = ((data as AnyObject).value(forKey: "trunk_desc") as? String)!
                            
                            LoderGifView.MyloaderHide(view: self.view)
                        }
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
    
    @IBAction func crossClick(sender: AnyObject?){
        if BackNotification_Vc == "PushNotifcation" {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.rootview_views(string: "discover")
        } else {
        callupdateback?(TrunkId as NSString, flag_updation as NSString, flag_follow, flag_attend, flag_bookmark)
        self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: ------- Follow unfollow section --------//
    @IBAction func Action_Follow_Unfollow(_ sender: Any)
    {
        if Is_Follow == true
        {
            follow_bookmark_attend.call_followunfollow(type:"unfollow", follow_id: TrunkId, follow_type: "2", API: URLConstant.API.USER_UNFOLLOWACTION)
            
            self.btn_follow .setImage(UIImage(named: "follow")!, for: UIControlState.normal)
            
            self.flag_updation = "1"
            self.flag_follow = 0
            self.Is_Follow = false
        }
        else
        {
            follow_bookmark_attend.call_followunfollow(type:"follow", follow_id: TrunkId, follow_type: "2", API: URLConstant.API.USER_FOLLOWACTION)
            
            self.btn_follow .setImage(UIImage(named: "follow filled")!, for: UIControlState.normal)
            
            self.flag_updation = "1"
            self.flag_follow = 1
            self.Is_Follow = true
        }
    }
    
    func didRecieveFollowUpdate(response: String) {
    }
    
    // MARK: ------- Attend unattend section --------//
    @IBAction func Action_Attend_Notattend(_ sender: Any)
    {
        if Is_Attend == true
        {
            let messageTitle = "Are you sure you want to unattend  " + self.lbl_title.text! + "?"
            let alert = UIAlertController(title: "Huntsman", message: messageTitle, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: handleConfirmUnattend(TrunkId:TrunkId as NSString )
            ))
            self.present(alert, animated: true, completion: nil)
            
        } else
        {
            follow_bookmark_attend.call_attendunattend(type: "attend", attend_id: TrunkId, attend_type: "2", API: URLConstant.API.USER_ATTENDACTION)
            self.btn_attend .setImage(UIImage(named: "attend  filled")!, for: UIControlState.normal)
            
            self.flag_updation = "1"
            self.flag_attend = 1
            self.Is_Attend = true
            
            let messageTitle = "You are attending " + self.lbl_title.text! + "."
            UIUtil.showMessage(title: "Huntsman", message:messageTitle , controller: self, okHandler: nil)

            
        }
    }
    func handleConfirmUnattend(TrunkId:NSString) -> (_ alertAction:UIAlertAction) -> () {
        return { alertAction in
            
            self.follow_bookmark_attend.call_attendunattend(type: "unattend", attend_id: TrunkId as String, attend_type: "2", API: URLConstant.API.USER_UNATTENDACTION)
            self.btn_attend .setImage(UIImage(named: "attend")!, for: UIControlState.normal)
            
            self.flag_updation = "1"
            self.flag_attend = 0
            self.Is_Attend = false
        }
    }
    func didRecieveAttendUpdate(response: String, attendtype: String) {
    }
    
    // MARK: ------- Bookmark unbbokmark section --------//
    @IBAction func Action_Bookmark_Unbookmark(_ sender: Any)
    {
        if Is_BookMark == true
        {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "unbookmark", bookmark_id: TrunkId, bookmark_type: "2", API: URLConstant.API.USER_UNBOOKMARKACTION)
            
            self.btn_bookmark .setImage(UIImage(named: "Bookmark")!, for: UIControlState.normal)
            
            self.flag_updation = "1"
            self.flag_bookmark = 0
            self.Is_BookMark = false
        }
        else
        {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "bookmark", bookmark_id: TrunkId, bookmark_type: "2", API: URLConstant.API.USER_BOOKMARKACTION)
            
            self.btn_bookmark .setImage(UIImage(named: "bookmark filled")!, for: UIControlState.normal)
            
            self.flag_updation = "1"
            self.flag_bookmark = 1
            self.Is_BookMark = true
        }
    }
    func didRecieveBookmarkUpdate(response: String) {
    }
    
    @IBAction func Action_request(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "RequestBooking_VC") as! RequestBooking_VC
        present(profile, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension Trunk_DetailVC: MKMapViewDelegate {
    
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
