//
//  Retailer_DetailVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 18/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import MapKit
import MessageUI

class Retailer_DetailVC: UIViewController,CLLocationManagerDelegate,MFMailComposeViewControllerDelegate, Follow_Bookmark_AttendDelegate{
    
    private let follow_bookmark_attend = Follow_Bookmark_Attend()
    
    @IBOutlet weak var View_CallBookmark: UIView!
    @IBOutlet weak var View_Map: UIView!
    @IBOutlet weak var View_DayTime: UIView!
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var Btn_contact: UIButton!
    @IBOutlet weak var lbl_about: UILabel!
    @IBOutlet weak var Btn_email: UIButton!
    @IBOutlet weak var Btn_website: UIButton!
    @IBOutlet weak var Btn_bookmark: UIButton!
    @IBOutlet weak var Btn_call: UIButton!
    @IBOutlet weak var lbl_Mon: UILabel!
    @IBOutlet weak var lbl_Tues: UILabel!
    @IBOutlet weak var lbl_Wed: UILabel!
    @IBOutlet weak var lbl_Thurs: UILabel!
    @IBOutlet weak var lbl_Fri: UILabel!
    @IBOutlet weak var lbl_Sat: UILabel!
    @IBOutlet weak var lbl_Sun: UILabel!
    
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var BackNotification_Vc = ""
    var RetailerId = ""
    var ContactNo = ""
    var Website = ""
    var Emailaddress = ""
    var SelectedArray:NSArray = []
    var Is_BookMark:Bool?
    
    var DestinationLatitude = ""
    var DestinationLongitude = ""
    
    var flag_updation = "0"
    var flag_bookmark = 0

    var callupdateRetailerDetail:((_ id:NSString, _ updation:NSString, _ bookmark:Int)->())?
    var CallBack_ForViewdisapper :(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestLocationAccess()
        locationManager.requestWhenInUseAuthorization()
        currentLocation = locationManager.location
        print(currentLocation?.coordinate.latitude ?? 0)
        print(currentLocation?.coordinate.longitude ?? 0)
        
        follow_bookmark_attend.delegate = self

        View_CallBookmark.layer.borderColor = UIColor.lightGray.cgColor
        View_CallBookmark.layer.borderWidth = 0.5
        
        View_Map.layer.borderColor = UIColor.lightGray.cgColor
        View_Map.layer.borderWidth = 0.5
        
        View_DayTime.layer.borderColor = UIColor.lightGray.cgColor
        View_DayTime.layer.borderWidth = 0.5

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
            URLConstant.Param.RETAILERDETAIL:RetailerId
        ]
        // URLConstant.API.RETAILER_DETAIL class in api name and params...(Retailer detail get info)
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.RETAILER_DETAIL,view: self.view, params: params, success: { (response) in
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let RetailerArray = json.value(forKey: "retailer_info") as? NSArray
                        if RetailerArray?.count ==  0 {
                            LoderGifView.MyloaderHide(view: self.view)
                            UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                        }
                        else {
                            let events = json.value(forKey: "retailer_info") as? NSArray
                            self.SelectedArray = events!
                            let data =  events![0] as! NSDictionary
                            
                            // ------ BOOKMARK ------
                            if let bookmark = ((data as AnyObject).value(forKey: "bookmark")as? Int), bookmark != 0 {
                                self.Btn_bookmark .setImage(UIImage(named: "bookmark filled")!, for: UIControlState.normal)
                                self.Is_BookMark = true
                                self.flag_bookmark = 1
                            } else {
                                self.Btn_bookmark .setImage(UIImage(named: "Bookmark")!, for: UIControlState.normal)
                                self.Is_BookMark = false
                                self.flag_bookmark = 0
                            }
                            
                             self.lbl_about.text = ((data as AnyObject).value(forKey: "about") as? String)!
                            
                            self.lbl_name.text = ((data as AnyObject).value(forKey: "name") as? String)!
                            
                            self.lbl_address.text = ((data as AnyObject).value(forKey: "address") as? String)!
                            
                            self.Btn_contact .setTitle(((data as AnyObject).value(forKey: "contact") as? String)!, for: .normal)
                            
                            self.ContactNo = ((data as AnyObject).value(forKey: "contact") as? String)!
                            
                            // Weak day
                            var OpeningHours =  events![0] as! NSDictionary
                            OpeningHours = (data.value(forKey: "opening_hours") as? NSDictionary
                                )!
                            print(OpeningHours)
                            var str_monday = ""
                            str_monday = ((OpeningHours as AnyObject).value(forKey: "monday") as? String)!
                            self.lbl_Mon.text  = str_monday.replacingOccurrences(of: ",", with: "\r\n")
                            
                            var str_tuesday = ""
                            str_tuesday = ((OpeningHours as AnyObject).value(forKey: "tuesday") as? String)!
                            self.lbl_Tues.text  = str_tuesday.replacingOccurrences(of: ",", with: "\r\n")
                            
                            var str_wednesday = ""
                            str_wednesday = ((OpeningHours as AnyObject).value(forKey: "wednesday") as? String)!
                            self.lbl_Wed.text  = str_wednesday.replacingOccurrences(of: ",", with: "\r\n")
                            
                            var str_thursday = ""
                            str_thursday = ((OpeningHours as AnyObject).value(forKey: "thursday") as? String)!
                            self.lbl_Thurs.text  = str_thursday.replacingOccurrences(of: ",", with: "\r\n")
                            
                            var str_friday = ""
                            str_friday = ((OpeningHours as AnyObject).value(forKey: "friday") as? String)!
                            self.lbl_Fri.text  = str_friday.replacingOccurrences(of: ",", with: "\r\n")
                            
                            var str_suturday = ""
                            str_suturday = ((OpeningHours as AnyObject).value(forKey: "saturday") as? String)!
                            self.lbl_Sat.text  = str_suturday.replacingOccurrences(of: ",", with: "\r\n")
                            
                            var str_sunday = ""
                            str_sunday = ((OpeningHours as AnyObject).value(forKey: "sunday") as? String)!
                            self.lbl_Sun.text  = str_sunday.replacingOccurrences(of: ",", with: "\r\n")
                            
                            self.Btn_email .setTitle(((data as AnyObject).value(forKey: "email") as? String)!, for: .normal)
                            self.Emailaddress = ((data as AnyObject).value(forKey: "email") as? String)!
                            
                            
                            self.Btn_website .setTitle(((data as AnyObject).value(forKey: "website") as? String)!, for: .normal)
                            self.Website = ((data as AnyObject).value(forKey: "website") as? String)!
                            
                            var lat = Double()
                            var long = Double()
                            var strLat = String()
                            var strLong = String()
                            if (data as AnyObject).value(forKey: "latitude") as? String != nil {
                                strLat = ((data as AnyObject).value(forKey: "latitude") as? String)!
                                lat = Double(strLat)
                            }
                            
                            if (data as AnyObject).value(forKey: "longitude") as? String != nil {
                               strLong = ((data as AnyObject).value(forKey: "longitude") as? String)!
                                long = Double(strLong)
                            }
                            
                            
                            
                            self.DestinationLatitude = strLat
                            self.DestinationLongitude = strLong
                            
                            let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
                            let span = MKCoordinateSpanMake(0.05, 0.05)
                            let region = MKCoordinateRegion(center: location, span: span)
                            self.map.setRegion(region, animated: true)
                            
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = location
                            annotation.title = "Huntsman"
                            annotation.subtitle = ((data as AnyObject).value(forKey: "name") as? String)!
                            self.map.addAnnotation(annotation)
                            self.map.delegate = self
                            
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
    
    @IBAction func ActionGetDirection(sender: AnyObject?)
    {
        self.map.delegate = self
        
        let url = "http://maps.apple.com/?saddr=\(Double((currentLocation?.coordinate.latitude)!)),\(Double( (currentLocation?.coordinate.longitude)!))&daddr=\(Double(DestinationLatitude)),\(Double(DestinationLongitude))"
        UIApplication.shared.openURL(URL(string:url)!)
    }
    
    @IBAction func ActionWebsite(sender: AnyObject?)
    {
        UIApplication.shared.openURL(URL(string:"http://\(self.Website)")!)
    }
    
    @IBAction func ActionGetEmail(sender: AnyObject?)
    {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients([self.Emailaddress])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ActionBack(sender: AnyObject?){
        if BackNotification_Vc == "PushNotifcation" {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.rootview_views(string: "discover")
        } else {
        callupdateRetailerDetail?(RetailerId as NSString, flag_updation as NSString,flag_bookmark)
        self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func ActionCall(sender: AnyObject?){
        
        if let url = URL(string: "tel://\(ContactNo)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    // Bookmark section heare
    @IBAction func ActionBookmark(sender: AnyObject?){
        
        if Is_BookMark == true
        {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "unbookmark", bookmark_id: RetailerId, bookmark_type: "4", API: URLConstant.API.USER_UNBOOKMARKACTION)
            
            self.Btn_bookmark .setImage(UIImage(named: "Bookmark")!, for: UIControlState.normal)
            
            self.flag_updation = "1"
            self.flag_bookmark = 0
            self.Is_BookMark = false
        }
        else
        {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "bookmark", bookmark_id: RetailerId, bookmark_type: "4", API: URLConstant.API.USER_BOOKMARKACTION)
            
            self.Btn_bookmark .setImage(UIImage(named: "bookmark filled")!, for: UIControlState.normal)
            
            self.flag_updation = "1"
            self.flag_bookmark = 1
            self.Is_BookMark = true
        }
    }
    
    func didRecieveFollowUpdate(response: String) {
    }
    func didRecieveBookmarkUpdate(response: String) {
    }
    func didRecieveAttendUpdate(response: String, attendtype: String) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension Retailer_DetailVC: MKMapViewDelegate {
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

