//
//  SignUpStep3_Vc.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 14/07/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import CoreLocation

class SignUpStep3_Vc: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var Btn_CurrentLocation: UIButton!
    @IBOutlet weak var Btn_ManualLocation: UIButton!
    
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var lbl_AddUnderline: UILabel!

    @IBOutlet weak var img_bg: UIImageView?

    var Str_latitude = ""
    var Str_logitude = ""
    
    var Str_latitudeKey = ""
    var Str_logitudeKey = ""
    
    
    var Str_step3_Street = ""
    var Str_step3_city = ""
    var Str_step3_state = ""
    var Str_step3_zipcode = ""
    var Str_step3_country = ""
    var Str_step3_Fulladdress = ""
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        if (Device.IS_IPHONE_X){ //iPhone X
            img_bg?.image = UIImage(named:"step-bg-x.png")
        }
        
        
        // for access current location
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    

    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print(location.coordinate)
            self.Str_latitude = "\(location.coordinate.latitude)"
            self.Str_logitude = "\(location.coordinate.longitude)"
        }
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "We need your location.",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
  
    @IBAction func CurrentLocation(sender: AnyObject?)
    {
        if self.Str_latitude == "" || self.Str_logitude == "" {
            UIUtil.showMessage(title: "", message: "Your location could not be determined.", controller: self, okHandler: nil)
        }
        else
        {
            getAddressFromLatLon(pdblLatitude: self.Str_latitude, withLongitude: self.Str_logitude)
        }
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        
        self.Str_latitudeKey = pdblLatitude
        self.Str_logitudeKey = pdblLongitude
        
        LoderGifView.MyloaderShow(view: self.view)
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                   
                    UIUtil.showMessage(title: "", message: "The operation couldn’t be completed, Try again!", controller: self, okHandler: nil)
                    
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                
                if placemarks != nil
                {
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        
                        print(pm.subLocality as Any)
                        print(pm.subThoroughfare as Any)
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            self.Str_step3_Street = pm.thoroughfare!
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            self.Str_step3_city = pm.locality!
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.administrativeArea != nil {
                            self.Str_step3_state = pm.administrativeArea!
                            addressString = addressString + pm.administrativeArea! + ", "
                        }
                        if pm.country != nil {
                            self.Str_step3_country = pm.country!
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            self.Str_step3_zipcode = pm.postalCode!
                            addressString = addressString + pm.postalCode! + " "
                        }
                        self.Str_step3_Fulladdress = addressString
                        self.lbl_Address.text = addressString
                    }
                }
                LoderGifView.MyloaderHide(view: self.view)
        })
    }
    
    // Manual location 
    @IBAction func UserManualLocation(sender: AnyObject?)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let Signupaddress = storyBoard.instantiateViewController(withIdentifier: "Signup_AddressVC") as! Signup_AddressVC
        self.navigationController?.pushViewController(Signupaddress, animated: true)
    }
  
    @IBAction func PreviousClick(sender: AnyObject?)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func NextClick(sender: AnyObject?)
    {
        if self.Str_latitudeKey == "" || self.Str_logitudeKey == "" {
            UIUtil.showMessage(title: "", message: "Choose your location.", controller: self, okHandler: nil)
        }
        else
        {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let SignupStep4 = storyBoard.instantiateViewController(withIdentifier: "SignupStep4_VC") as! SignupStep4_VC
            
            SignupStep4.locationFlage = "CurrentLocation"
            SignupStep4.latitude = self.Str_latitudeKey
            SignupStep4.logitude = self.Str_logitudeKey
            SignupStep4.Street =  self.Str_step3_Street
            SignupStep4.city = self.Str_step3_city
            SignupStep4.state =  self.Str_step3_state
            SignupStep4.country = self.Str_step3_country
            SignupStep4.zipcode = self.Str_step3_zipcode
            SignupStep4.Fulladdress =  self.Str_step3_Fulladdress

         self.navigationController?.pushViewController(SignupStep4, animated: true)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

