//
//  Places.swift
//  MapKit Starter
//
//  Created by Pranjal Satija on 10/25/16.
//  Copyright © 2016 Pranjal Satija. All rights reserved.
//

import MapKit


// Map on marker show huntsman app
@objc class Place: NSObject {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    static func getPlaces() -> [Place] {
        
        var array = [] as NSArray
        
        if  UserDefaults.standard.value(forKey: "allmaplist") != nil
        {
            array = NSKeyedUnarchiver.unarchiveObject(with: PreferenceUtil.getMapList() as Data) as! NSArray
            
            var places = [Place]()
            
            for item in array {
                let dictionary = item as? [String : Any]
                let title = "Huntsman"
                var subtitle = ""
                if let actionString = dictionary?["trunk_title"] as? String
                {
                    subtitle = actionString
                }
                else if let Stringid = dictionary?["name"] as? String
                {
                    subtitle = Stringid
                }
                else
                {
                    subtitle = (dictionary?["event_title"] as? String)!
                }
                
                let lat = dictionary?["latitude"] as? String ?? "latitude"

                let longtude = dictionary?["longitude"] as? String ?? "longitude"

                let place = Place(title: title, subtitle: subtitle, coordinate: CLLocationCoordinate2DMake(Double(lat), Double(longtude)))
                
                places.append(place)
            }
            
            return places as [Place]
        }
        else { return [] }
    }
}

extension Double {
    init(_ value: String){
        self = (value as NSString).doubleValue
    }
}
extension Place: MKAnnotation { }
