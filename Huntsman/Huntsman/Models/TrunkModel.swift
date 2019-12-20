//
//  TrunkModel.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 10/05/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class TrunkModel {
    //MARK: Properties
    var id: String = ""
    var photo: String = ""
    var date: String = ""
    var End_date: String = ""
    var title: String = ""
    var desc: String = ""
    
    var follow: Int = 0
    var attend: Int = 0
    var bookmark: Int = 0
    
    //MARK: Initialization
    
    init?(id: String?, photo: String?, date: String?,Enddate:String?, title: String?, desc: String?, follow: Int, attend: Int, bookmark: Int) {
 
        self.id = id ?? ""
        self.photo = photo ?? ""
        self.date = date ?? ""
        self.End_date = Enddate ?? ""
        self.title = title ?? ""
        self.desc = desc  ?? ""
        
        self.follow = follow
        self.attend = attend
        self.bookmark = bookmark
    }
}

