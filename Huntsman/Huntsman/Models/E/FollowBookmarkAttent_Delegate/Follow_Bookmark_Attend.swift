//
//  Follow_Bookmark_Attend.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 11/05/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import Foundation

protocol Follow_Bookmark_AttendDelegate : class
{
    func didRecieveFollowUpdate(response: String)
    func didRecieveBookmarkUpdate(response: String)
    func didRecieveAttendUpdate(response: String ,attendtype: String)
}

class Follow_Bookmark_Attend {
    
    weak var delegate: Follow_Bookmark_AttendDelegate?
    let vieww = UIView()
    
    // MARK: -   -------Follow call section ----
    func call_followunfollow(type:String, follow_id:String, follow_type:String, API:String){
        
        var params = [:] as NSDictionary
        
        if type == "follow" {
            params = [
                URLConstant.Param.FOLLOW:follow_id,
                URLConstant.Param.FOLLOWTYPE :follow_type
            ]
        } else {
            params = [
                URLConstant.Param.UNFOLLOW:follow_id,
                URLConstant.Param.UNFOLLOWTYPE :follow_type
            ]
        }
        
        WebserviceUtil.callPost(jsonRequest:API,view:vieww, params: params as? [String : Any], success: { (response) in
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        self.delegate?.didRecieveFollowUpdate(response: "ok")
                    }
                    else {
                        self.delegate?.didRecieveFollowUpdate(response: "failed")
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.didRecieveFollowUpdate(response: "failed")
        }
        
    }
    
    
    // MARK: -   -------Bookmark call section ----
    func call_bookmarkunbookmark(type:String, bookmark_id:String, bookmark_type:String, API:String){
        
        var params = [:] as NSDictionary
        
        if type == "bookmark" {
            params = [
                URLConstant.Param.USER_BOOKMARK:bookmark_id,
                URLConstant.Param.BOOKMARKTYPE :bookmark_type
            ]
        } else {
            params = [
                URLConstant.Param.UNBOOKMARK:bookmark_id,
                URLConstant.Param.UNBOOKMARKTYPE :bookmark_type
            ]
        }
        
        WebserviceUtil.callPost(jsonRequest:API,view:vieww, params: params as? [String : Any], success: { (response) in
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        self.delegate?.didRecieveBookmarkUpdate(response: "ok")
                    }
                    else {
                        self.delegate?.didRecieveBookmarkUpdate(response: "failed")
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.didRecieveBookmarkUpdate(response: "failed")
        }
    }
    
    // MARK: -   -------Attend call section ----
    func call_attendunattend(type:String, attend_id:String, attend_type:String, API:String){
        
        var params = [:] as NSDictionary
        
        if type == "attend" {
            params = [
                URLConstant.Param.ATTEND:attend_id,
                URLConstant.Param.ATTENDTYPE :attend_type
            ]
        } else {
            params = [
                URLConstant.Param.UNATTEND:attend_id,
                URLConstant.Param.UNATTENDTYPE :attend_type
            ]
        }
        
        WebserviceUtil.callPost(jsonRequest:API,view:vieww, params: params as? [String : Any], success: { (response) in
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        if type == "attend" {
                            self.delegate?.didRecieveAttendUpdate(response: "ok", attendtype: "attend")
                        } else {
                            self.delegate?.didRecieveAttendUpdate(response: "ok", attendtype: "notattend")
                        }
                    }
                    else {
                        self.delegate?.didRecieveAttendUpdate(response: "failed", attendtype: "notattend")
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            self.delegate?.didRecieveAttendUpdate(response: "failed", attendtype: "notattend")
        }
    }
}
