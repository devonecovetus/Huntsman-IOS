//
//  Signup_AddressVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 12/07/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GooglePlaces

class Signup_AddressVC: UIViewController {
    
    var Str_latitude = ""
    var Str_logitude = ""

    var Str_Street = ""
    var Str_city = ""
    var Str_state = ""
    var Str_zipcode = ""
    var Str_country = ""
    var Str_fulladdres = ""
    
    @IBOutlet weak var CreateAccount: UIButton!
    @IBOutlet weak var lbl_FullAddress: UILabel!

    @IBOutlet weak var lbl_street: UILabel!
    @IBOutlet weak var lbl_city: UILabel!
    @IBOutlet weak var lbl_state: UILabel!
    @IBOutlet weak var lbl_zipcode: UILabel!
    @IBOutlet weak var lbl_country: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        lbl_FullAddress.text = "Select location"
        let tap = UITapGestureRecognizer(target: self, action: #selector(Signup_AddressVC.tapFunction))
        lbl_FullAddress.isUserInteractionEnabled = true
        lbl_FullAddress.addGestureRecognizer(tap)
    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        
        lbl_street.Helper_LightGrayunderlined()
        lbl_city.Helper_LightGrayunderlined()
        lbl_state.Helper_LightGrayunderlined()
        lbl_zipcode.Helper_LightGrayunderlined()
        lbl_country.Helper_LightGrayunderlined()
    }
    
 

    @IBAction func CreateAccount(sender: AnyObject?){
        
        if self.Str_latitude == "" || self.Str_logitude == "" {
            UIUtil.showMessage(title: "", message: "Choose your location.", controller: self, okHandler: nil)
        }
        else
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let SignupStep4 = storyBoard.instantiateViewController(withIdentifier: "SignupStep4_VC") as! SignupStep4_VC
            SignupStep4.locationFlage = "ManualLocation"
            SignupStep4.latitude = self.Str_latitude
            SignupStep4.logitude = self.Str_logitude
            SignupStep4.Street =  self.Str_Street
            SignupStep4.city = self.Str_city
            SignupStep4.state =  self.Str_state
            SignupStep4.country = self.Str_country
            SignupStep4.zipcode = self.Str_zipcode
            SignupStep4.Fulladdress =  self.Str_fulladdres
            
            self.navigationController?.pushViewController(SignupStep4, animated: true)
        }
        
    }
  
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension Signup_AddressVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        print("Place latlong: \(String(describing: place.coordinate))")
        getAddressFromLatLon(pdblLatitude: String(describing: place.coordinate.latitude), withLongitude: String(describing: place.coordinate.longitude))
        dismiss(animated: true, completion: nil)
        
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        
        LoderGifView.MyloaderShow(view: self.view)
        self.Str_latitude = pdblLatitude
        self.Str_logitude = pdblLongitude
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
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                
                if placemarks != nil
                {
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    
                    let pm = placemarks![0]
                    
                    print(pm.subLocality as Any)
                    print(pm.thoroughfare as Any)
                    print(pm.subThoroughfare as Any)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        self.Str_Street = pm.thoroughfare!
                        self.lbl_street.text = self.Str_Street
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    else
                    {
                        self.lbl_street.text = "Not found"
                    }
                    if pm.locality != nil {
                        self.Str_city = pm.locality!
                        self.lbl_city.text = self.Str_city
                        addressString = addressString + pm.locality! + ", "
                    }
                    else
                    {
                        self.lbl_city.text = "Not found"
                    }
                    if pm.administrativeArea != nil {
                        self.Str_state = pm.administrativeArea!
                        self.lbl_state.text = self.Str_state
                        addressString = addressString + pm.administrativeArea! + ", "
                    }
                    if pm.country != nil {
                        self.Str_country = pm.country!
                        self.lbl_country.text = self.Str_country
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        self.Str_zipcode = pm.postalCode!
                        self.lbl_zipcode.text = self.Str_zipcode
                        addressString = addressString + pm.postalCode! + " "
                    }
                    self.Str_fulladdres = addressString
                    self.lbl_FullAddress.text = addressString
                    print(addressString)
                    print("full address \(self.Str_fulladdres)")
                    
                }
            }
                LoderGifView.MyloaderHide(view: self.view)

           })
      
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
   // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

