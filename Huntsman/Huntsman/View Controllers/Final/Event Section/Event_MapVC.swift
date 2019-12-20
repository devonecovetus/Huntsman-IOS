//
//  Event_MapVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 10/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import MapKit
protocol Event_MapDelegate:class {
    func EventMap_LoderHide()
    func EventMap_LoderShow()
}

class Event_MapVC: UIViewController ,IndicatorInfoProvider{
    var locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    var locations = [] as NSArray

    var delegate:Event_MapDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.removeObject(forKey:"allmaplist")
        callMapAPI()
        requestLocationAccess()
    }
    
    // MARK: API Calls
    func callMapAPI() {
        self.delegate?.EventMap_LoderShow()
        let params = [
            URLConstant.Param.PAGE:"-1",
            URLConstant.Param.BOOKMARK:"",
            URLConstant.Param.TYPE :"",
            URLConstant.Param.MONTH :"",
            URLConstant.Param.YEAR :"",
            URLConstant.Param.FILTERDATE :""
        ]
        
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.USER_EVENTMAP,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        
                        self.locations = (json.value(forKey: "events") as? NSArray)!
                        if self.locations.count == 0{
                            self.delegate?.EventMap_LoderHide()
                            UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                        }
                        else
                        {
                            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject:self.locations  as Any)
                            PreferenceUtil.saveMapList(list: encodedData as NSData)
                            
                            let places = Place.getPlaces()
                            self.mapView?.delegate = self as MKMapViewDelegate
                            self.mapView?.addAnnotations(places)
                            
                            let overlays = places.map { MKCircle(center: $0.coordinate, radius: 100) }
                            self.mapView?.addOverlays(overlays)
                            
                            self.delegate?.EventMap_LoderHide()
                        }
                    }
                    else {
                        self.delegate?.EventMap_LoderHide()
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
            self.delegate?.EventMap_LoderHide()
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
    
    override func viewDidAppear(_ animated: Bool) {
        print(" viewDidAppear Map view")
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        //return IndicatorInfo(title: "Map view")
        return IndicatorInfo(title: "        Map ",image:UIImage(named: "MapImg")!, highlightedImage:UIImage(named: "MapImg"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension Event_MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
            
        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "locationpoint")
            let image = UIImage(named: "grey rigth")
            let button = UIButton(type: .infoLight)
            button.setImage(image, for: .normal)
            annotationView.rightCalloutAccessoryView = button
            annotationView.canShowCallout = true
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
      //  guard let annotation = view.annotation as? Place, let title = annotation.title else { return }
        
        let annotation = view.annotation as? Place
        //, let title = annotation.title else { return }
        let subtitle = annotation?.subtitle
        
        let searchPredicate = NSPredicate(format: "event_title CONTAINS[cd] %@", subtitle!)
        let map_arr = NSMutableArray(array: locations.filtered(using: searchPredicate))
        
        let lati = annotation?.coordinate.latitude
        
        let str_lati = String(format: "%.5f", lati!)
        
        let searchPredicate2 = NSPredicate(format: "latitude CONTAINS[cd] %@", str_lati)
        let map_arr2 = NSMutableArray(array: map_arr.filtered(using: searchPredicate2))
        
        var arr = [:] as  NSDictionary
        if  map_arr2.count == 0 {
            arr = map_arr[0] as! NSDictionary
        } else {
            arr = map_arr2[0] as! NSDictionary
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let EventDetail = storyBoard.instantiateViewController(withIdentifier: "Event_DetailVC") as! Event_DetailVC
        EventDetail.EventId = ((arr as AnyObject).value(forKey: "id") as? String)!
        present(EventDetail, animated: true, completion: nil)
    }
}
