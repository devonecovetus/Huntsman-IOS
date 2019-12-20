//
//  MemberModel.swift
//  Huntsman
//
//  Created by Mac on 5/15/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import Foundation

class MemberModel {
    
    //MARK: Properties
    var id: String = ""
    var photo: String = ""
    var industry: String = ""
    var name: String = ""
    var about: String = ""
    
    var attend_events: String = ""
    var since: String = ""
    
    var bookmark: Int = 0
    
    //MARK: Initialization
    init?(id: String?, photo: String?, industry: String?, name: String?, about: String?, bookmark: Int, attend_events: String?, since:String?) {
        // Initialize stored properties.
        self.id = id ?? ""
        self.photo = photo ?? ""
        self.industry = industry ?? ""
        self.name = name ?? ""
        self.about = about ?? ""
        
        self.attend_events = attend_events ?? ""
        self.since = since ?? ""
        
        self.bookmark = bookmark
    }
}
