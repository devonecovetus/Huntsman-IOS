//
//  EventModel.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 14/05/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import Foundation

class EventModel {
    
    //MARK: Properties
    var id: String = ""
    var photo: String = ""
    var date: String = ""
    var enddate: String = ""
    var title: String = ""
    
    var follow: Int = 0
    var attend: Int = 0
    var bookmark: Int = 0
    
    //MARK: Initialization
    init?(id: String?, photo: String?, date: String?, enddate: String?, title: String?, follow: Int, attend: Int, bookmark: Int) {
        
        self.id = id ?? ""
        self.photo = photo ?? ""
        self.date = date ?? ""
        self.enddate = enddate ?? ""
        self.title = title ?? ""
        
        self.follow = follow
        self.attend = attend
        self.bookmark = bookmark
    }
}
