//
//  Retailer_MapVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 16/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import MapKit

protocol Retailer_MapDelegate: class {
    func Retailer_MapLoaderHide()
    func Retailer_MapLoaderShow()
}
class Retailer_MapVC: UIViewController,IndicatorInfoProvider
{
    var locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    var locations = [] as NSArray
    var delegate:Retailer_MapDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        UserDefaults.standard.removeObject(forKey:"allmaplist")
        
        CallApiRetailerMap()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
    }
    
    func CallApiRetailerMap(){
        
        self.delegate?.Retailer_MapLoaderShow()
        WebserviceUtil.callGet(jsonRequest: URLConstant.API.RETAILER_RETAILERMAP ,view:self.view, success: { (response) in
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        
                        self.locations = (json.value(forKey: "retailers") as? NSArray)!
                        if self.locations.count == 0{
                            
                            self.delegate?.Retailer_MapLoaderHide()
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
                            
                            self.delegate?.Retailer_MapLoaderHide()
                        }
                    }
                    else {
                        self.delegate?.Retailer_MapLoaderHide()
                        if let msg = json.value(forKey:"message") as? String, msg == "Invalid auth token."{
                            UIUtil.showLogout(title: "", message:"It seems you logged-in on other device with same user. To continue with same device please log-in again.", controller: self, okHandler: nil)
                        } else {
                            UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                        }
                        
                    }
                }
            }
        }) { (error) in
            self.delegate?.Retailer_MapLoaderHide()
            print(error.localizedDescription)
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

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
       return IndicatorInfo(title: "        Map ",image:UIImage(named: "MapImg")!, highlightedImage:UIImage(named: "MapImg"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension Retailer_MapVC: MKMapViewDelegate {
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
        
        let searchPredicate = NSPredicate(format: "name CONTAINS[cd] %@", subtitle!)
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
        let RetailerDetail = storyBoard.instantiateViewController(withIdentifier: "Retailer_DetailVC") as! Retailer_DetailVC
        RetailerDetail.RetailerId = ((arr as AnyObject).value(forKey: "id") as? String)!
        present(RetailerDetail, animated: true, completion: nil)
        
    }
}
