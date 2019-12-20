//
//  URLConstant.swift
//  Cuumi
//
//  Created by Abdul Wahib on 3/22/17.
//  Copyright © 2017 Cuumi. All rights reserved.
//

import Foundation

class URLConstant: Any {
    // BASE URL FOR ALL API
    //static let BASE_URL = "http://dev.covetus.com/hunts"
       static let BASE_URL = "https://clubappadmin.huntsmansavilerow.com"
  //  static let BASE_URL = "http://clubappadmin.huntsmansavilerow.com"
    
    class API {
        
        static let SIGN_IN = "\(BASE_URL)/Api/login"
        static let SIGN_UP = "\(BASE_URL)/Api/signUp"
        static let SIGN_EMAILVERIFY = "\(BASE_URL)/Api/verifyEmail"
        static let FORGOT_PASSWORD = "\(BASE_URL)/Api/forgotPassword"
        static let ALL_INDUSTRY = "\(BASE_URL)/Api/allIndustries"
        static let PROFILE_STEP1 = "\(BASE_URL)/Api/updateProfilestep1"
        static let ALL_INTEREST = "\(BASE_URL)/Api/allInterest"
        static let PROFILE_STEP2 = "\(BASE_URL)/Api/updateProfilestep2"
        static let PROFILE_STEP3 = "\(BASE_URL)/Api/updateProfilestep3"
        static let USER_PROFILE = "\(BASE_URL)/Api/userdetailbyToken"
        static let USER_DISCOVER_PROFILE = "\(BASE_URL)/Api/userDiscoverProfile"
        static let TRUNKSHOW_GETAPPTRUNK = "\(BASE_URL)/Api/Trunkshow/getallTrunk"
        static let USER_TRUNKCALENDAR = "\(BASE_URL)/Api/User/trunkCalendar"
        static let USER_TRUNKMAP = "\(BASE_URL)/Api/Trunkshow/trunkMap"
        static let TRUNKDETAIL = "\(BASE_URL)/Api/Trunkshow/trunkDetail"
        static let TRUNKREQUEST = "\(BASE_URL)/Api/User/requestTrunkshow"
        
        static let REQUESTBOOKING_LIST = "\(BASE_URL)/Api/Trunkshow/getRequestbookinglist"
        static let REQUEST_CANCEL = "\(BASE_URL)/Api/Trunkshow/requestbookingcancel"
        static let NEWSFEEDLIST = "\(BASE_URL)/Api/Event/getallfeeds"
        static let USER_PROFILE_UPDATE = "\(BASE_URL)/Api/updateProfiles"
        static let USER_FOLLOWACTION = "\(BASE_URL)/Api/User/followAction"
        static let USER_UNFOLLOWACTION = "\(BASE_URL)/Api/User/unfollowAction"
        static let USER_BOOKMARKACTION = "\(BASE_URL)/Api/User/bookmarkAction"
        static let USER_UNBOOKMARKACTION = "\(BASE_URL)/Api/User/unBookmarkAction"
        static let USER_ATTENDACTION = "\(BASE_URL)/Api/User/AttendAction"
        static let USER_UNATTENDACTION = "\(BASE_URL)/Api/User/unAttendAction"

        static let EVENT_GETALLEVENT = "\(BASE_URL)/Api/Event/getallEvent"
        static let USER_EVENTCALENDAR = "\(BASE_URL)/Api/User/EventCalendar"
        static let USER_EVENTMAP = "\(BASE_URL)/Api/Event/eventMap"
        
        // ----
        static let EVENTDETAIL = "\(BASE_URL)/Api/Event/eventDetail"
        static let NEWSFEEDDETAIL = "\(BASE_URL)/Api/Event/feedDetails"

        static let HUNTSMANALLUSERS = "\(BASE_URL)/Api/User/getallUser"
        static let HUNTSMAN_USERMAP  =  "\(BASE_URL)/Api/User/userMap"
        static let USERSDETAILBYID = "\(BASE_URL)/Api/userdetailbyid"
        
        // chat
        static let USERCHATPOST = "\(BASE_URL)/Api/Message/userchatPost"
        static let SENDMESSAGE = "\(BASE_URL)/Api/Message/sendMessage"
        static let GETCHATMESSAGE = "\(BASE_URL)/Api/Message/getChatMessage"
        static let GETCHATMESSAGE_USERID = "\(BASE_URL)/Api/Message/userChatbyid"
        
        // retailer
        static let RETAILER_GETALLRETAILER =  "\(BASE_URL)/Api/Retailer/getallRetailer"
        static let RETAILER_RETAILERMAP =  "\(BASE_URL)/Api/Retailer/retailerMap"
        static let RETAILER_DETAIL = "\(BASE_URL)/Api/Retailer/getRetailerdetails"
        
        static let INVITEUSER =  "\(BASE_URL)/Api/User/inviteUser"
        static let ALLNOTIFICATION = "\(BASE_URL)/Api/User/Allnotification"
        
        // Setting
        static let MSGSETTING = "\(BASE_URL)/Api/msgSetting"
        static let ALLSETTING = "\(BASE_URL)/Api/User/AllSetting"
        static let WARDROBE_LOCATIONSETTING = "\(BASE_URL)/Api/User/wardrobe_locationSetting"
        
        // Admin Chat
        static let REQUESTDETAIL = "\(BASE_URL)/Api/Trunkshow/requestDetail"
        static let REQUESTBOOKINGCOMMENT = "\(BASE_URL)/Api/Trunkshow/requestbookingcomment"
        
        static let CHANGEPASSWORD = "\(BASE_URL)/Api/User/resetPassword"
        
        // wardrobe
        static let WARDROBUSER = "\(BASE_URL)/Api/User/userWardrobe"
        static let WARDROBE_CATEGGORIES = "\(BASE_URL)/Api/wardrobeCategories"
        static let WARDROBE_PRODUCT_BYCATEGORY = "\(BASE_URL)/Api/allproductBycategory"
        static let WARDROBE_PRODUCTDETAIL = "\(BASE_URL)/Api/User/productDetail"
        static let WARDROBE_ADDREMOVEPRODUCT = "\(BASE_URL)/Api/User/add_removeProduct"
        static let WARDROBE_SHUFFLE = "\(BASE_URL)/Api/User/productShuffle"
        // wardrobe suggestion product
        static let USER_SUGGESTED_PRODUCT = "\(BASE_URL)/Api/User/userSuggestedProduct"
        
        // Notification Read/unRead
        static let USER_READ_NOTIFICATION = "\(BASE_URL)/Api/User/readNotification"
        
        static let USER_ADMIN_NOTIFICATION_READ = "\(BASE_URL)/Api/User/adminNotificationread"

         // Wardrobe suggest product seen
        static let USER_SUGGESTEDPRODUCT_SEEN = "\(BASE_URL)/Api/User/suggestedProductSeen"
        
        static let USER_UPDATE_DEVICEID = "\(BASE_URL)/Api/User/updateDeviceid"
        
        static let USER_Logout = "\(BASE_URL)/Api/User/logout"
        static let RESEND_OTP = "\(BASE_URL)/Api/resendEmailVerificationtoken"
        static let deleteNotifications = "\(BASE_URL)/Api/User/clearNotification"
    }
    
    class Param {
        
        static let EMAIL_OTP = "str[email_otp]"
        static let SIGNUP_DOB = "str[dob]"

        static let ADDRESS = "str[address]"
        static let STREET = "str[street]"
        static let CITY = "str[city]"
        static let STATE = "str[state]"
        static let ZIPCODE = "str[zipcode]"
        static let COUNTRY = "str[country]"
        static let USER_LATI = "str[user_lati]"
        static let USER_LONGI = "str[user_longi]"

        static let EMAIL = "str[email]"
        static let PASSWORD = "str[password]"
        static let DEVICETYPE = "str[device_type]"
        static let DEVICEID = "str[device_id]"
        static let TOKEN_HEADER = "Token"

        // Profilestep1 params
        static let INDUSTRYID = "str[industrory_id]"
        static let INDUSTRYTITLE = "str[industrory_title]"
        static let JOBTITLE = "str[job_title]"
        static let COMPANYNAME = "str[company]"
                
        // Profilestep2 params
        static let INTERESTID = "str[intereset_id]"
        static let INTERESTTITLE = "str[interest_title]"
        
        // Profilestep3 params
        static let PROFILEPIC = "str[profile_pic]"
        
        //Listing params
        static let PAGE = "str[page]"
        static let BOOKMARK = "str[bookmark]"
        static let TYPE = "str[type]"
        static let MONTH = "str[month]"
        static let YEAR = "str[year]"
        
        static let FILTERDATE = "str[filter_date]"
        
        //Detail params
        static let TRUNKDETAIL = "str[trunk_id]"
        static let EVENTDETAIL = "str[event_id]"
        static let FEEDDETAIL = "str[feed_id]"
        static let RETAILERDETAIL = "str[retailer_id]"
        
        static let STATUS = "str[status]"
        static let REQUESTID = "str[request_id]"
        
        // Update profile
        static let USERABOUT = "str[about_user]"
        static let USER_DOB = "str[user_dob]"
        static let USER_FIRSTNAME = "str[firstname]"
        static let USER_LASTTNAME = "str[lastname]"
        static let CONTACTNO = "str[contact_no]"
        
        // follow
        static let FOLLOW = "str[follow_to]"
        static let FOLLOWTYPE = "str[follow_type]"
        static let UNFOLLOW = "str[unfollow_to]"
        static let UNFOLLOWTYPE = "str[unfollow_type]"

        // bookmark
        static let USER_BOOKMARK = "str[bookmark_to]"
        static let UNBOOKMARK = "str[unbookmark_to]"
        static let BOOKMARKTYPE = "str[bookmark_type]"
        static let UNBOOKMARKTYPE = "str[unbookmark_type]"
        
        // attend
        static let ATTEND = "str[attend_to]"
        static let ATTENDTYPE = "str[attend_type]"
        static let UNATTEND = "str[unattend_to]"
        static let UNATTENDTYPE = "str[unattend_type]"
      
        //Huntsman member
        static let NAME = "str[name]"
        static let USERID = "str[user_id]"
     
        //chat/message
        static let MESSAGE = "str[message]"
        static let MESSAGETO = "str[message_to]"
        
        //invite
        static let INVITETO = "str[invite_to]"
        static let INVITEFOR = "str[invite_for]"
        
        //request
        static let BOOKINGDATE = "str[booking_date]"
        static let USRECOMMENT = "str[user_comment]"

        //Notification setting
        static let MSGFROMALL = "str[msg_from_all]"
        static let MSGFROMHUNTSMAN = "str[msg_from_huntsman]"
        static let MSGFROMUSER = "str[msg_from_user]"
        static let COMMENT = "str[comment]"
        
        static let MSG_SETTING = "str[msg_setting]"
        static let SETTING_TYPE = "str[setting_type]"
        static let SETTING = "str[setting]"
        
        static let OLDPASSWORD = "str[old_password]"
        static let NEWPASSWORD = "str[new_password]"
        static let CONFIRMPASSWORD = "str[confirm_password]"
        
        static let CATEGORY_ID = "str[category_id]"
        static let PRODUCTID = "str[product_id]"
        static let CATEGORY = "str[category]"
        static let STR_ACTION = "str[action]"
        static let PRODUCT_LIST = "str[product_list]"
        
        static let PRODUCTS = "str[products]"
        static let ORDER = "str[order]"
        static let STR_NOTIFICATIONID = "str[notification_id]"
        static let STR_TYPEID = "str[type_id]"
    }
}
