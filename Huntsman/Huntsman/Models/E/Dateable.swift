//
//  Dateable.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 11/05/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import Foundation

protocol Dateable {
    func userddMMMyyyyDate(str_date:String) -> String
    func usereventlistDate(str_date:String) -> String
}

extension Date: Dateable{
    
    var  formatter: DateFormatter { return DateFormatter() }
    
    /** Return a user friendly hour */
    func userddMMMyyyyDate(str_date:String) -> String {
        
        var dateString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if dateFormatter.date(from: str_date) != nil {
            let date = dateFormatter.date(from: str_date)!
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            dateString = dateFormatter.string(from:date)
        }
        else{
            dateString = ""
        }
        return dateString
    }
    
    /** Return a user friendly hour */
    func usereventlistDate(str_date:String) -> String {
        var dateString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if dateFormatter.date(from: str_date) != nil {
            let date = dateFormatter.date(from: str_date)!
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            dateString = dateFormatter.string(from:date)
        }
        else
        {
            dateString = ""
        }
        return dateString
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
    
    func UserNewsfeedDate(str_date:String) -> String {
        // Customize a date formatter
        var dateString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if dateFormatter.date(from: str_date) != nil {
            let date = dateFormatter.date(from: str_date)!
            dateFormatter.dateFormat = "dd MMM yyyy - hh:mm a"
            dateString = dateFormatter.string(from:date)
        }
        else
        {
            dateString = ""
        }
        return dateString
    }
}

