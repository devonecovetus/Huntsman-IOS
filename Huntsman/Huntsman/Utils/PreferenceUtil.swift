//
//  PreferenceUtil.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 01/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import Foundation

class PreferenceUtil{
    
    // MARK: Save Values
    class func save(key: String, value: String?){
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    class func save(key: String, value: Int){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    class func save(key: String, value: Bool){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    class func save(key: String, value: NSData){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    
    // MARK: Get Values
    class func get(key:String) -> String? {
        return UserDefaults.standard.value(forKey: key) as? String
    }
    
    class func getInt(key:String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    class func getBool(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    class func getData(key: String) -> NSData {
        return UserDefaults.standard.data(forKey: key)! as NSData
    }
}

extension PreferenceUtil {
    
    class func saveUserdevicetoken(token: String) {
        
         PreferenceUtil.save(key: "userDeviceToken", value: token)
    }
    
    class func getUserdevicetoken() -> String {
        let devicetoken = get(key: "userDeviceToken")
        return devicetoken!
    }
    
    class func saveProfileComplete(string: String) {
        PreferenceUtil.save(key: PreferenceKey.USER_PROFILECOMPLETE, value: string)
    }
    
    class func getProfileComplete() -> String {
        var devicetoken = get(key: PreferenceKey.USER_PROFILECOMPLETE)
        if devicetoken == nil {
            devicetoken = ""
        }
        return devicetoken!
    }
    
    // Project Specific Functions
    class func saveUser(user: User) {
        PreferenceUtil.save(key: PreferenceKey.USER_IS_LOGGED, value: true)
        PreferenceUtil.save(key: PreferenceKey.USER_ID, value: user.id)
        PreferenceUtil.save(key: PreferenceKey.USER_EMAIL, value: user.email)
        PreferenceUtil.save(key: PreferenceKey.USER_TOKEN, value: user.token)
        PreferenceUtil.save(key: PreferenceKey.USER_NAME, value: user.name)
        PreferenceUtil.save(key: PreferenceKey.USER_LASTNAME, value: user.lastname)
        PreferenceUtil.save(key: PreferenceKey.USER_PROFILE_PIC, value: user.profilepic)
        PreferenceUtil.save(key: PreferenceKey.USER_PASSWORD, value: user.password)
    }
    class func getUser() -> User {
        let user = User()
        user.id = getInt(key: PreferenceKey.USER_ID)
        if let name = get(key: PreferenceKey.USER_NAME) {user.name = name}
        if let lastname = get(key: PreferenceKey.USER_LASTNAME) {user.lastname = lastname}
        if let token = get(key: PreferenceKey.USER_TOKEN) {user.token = token}
        if let email = get(key: PreferenceKey.USER_EMAIL) {user.email = email}
        if let password = get(key: PreferenceKey.USER_PASSWORD) {user.password = password}
        user.isLoggedIn = getBool(key: PreferenceKey.USER_IS_LOGGED)
        if let profilePic = get(key: PreferenceKey.USER_PROFILE_PIC){user.profilepic = profilePic}
        return user
    }
    
    // industrylist
    class func saveIndustryList(list: NSData) {
        PreferenceUtil.save(key: PreferenceKey.INDUSTRY_LIST, value: list)
    }
    class func getIndustryList() -> NSData {
        let industry_data = getData(key: PreferenceKey.INDUSTRY_LIST)
        return industry_data
    }
    
    // interestlist
    class func saveInterestList(list: NSData) {
        PreferenceUtil.save(key: PreferenceKey.INTEREST_LIST, value: list)
    }
    class func getInterestList() -> NSData {
        let interest_data = getData(key: PreferenceKey.INTEREST_LIST)
        return interest_data
    }
    
    // calendarlist
    class func saveCalendarList(list: NSData) {
        PreferenceUtil.save(key: PreferenceKey.ALLCALENDARLIST, value: list)
    }
    class func getCalendarList() -> NSData {
        let Calendar_data = getData(key: PreferenceKey.ALLCALENDARLIST)
        return Calendar_data
    }
   
    // maplist
    class func saveMapList(list: NSData) {
        PreferenceUtil.save(key: PreferenceKey.ALLMAPLIST, value: list)
    }
    class func getMapList() -> NSData {
        let map_data = getData(key: PreferenceKey.ALLMAPLIST)
        return map_data
    }
}
