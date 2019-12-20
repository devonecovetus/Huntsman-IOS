//
//  FeedsModel.swift
//  Huntsman
//
//  Created by Mac on 5/15/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import Foundation

class FeedsModel {
    
    //MARK: Properties
    var id: String = ""
    var title: String = ""
    var date: String = ""
    var decs: String = ""
    var photo: NSArray = []
    
    var likecount: Int = 0
    var follow: Int = 0
    
    //MARK: Initialization
    init?(id: String?, title: String?, date: String?, decs: String?, photo: NSArray, likecount: Int, follow: Int) {
        
     
        // Initialize stored properties.
        self.id = id ?? ""
        self.title = title ?? ""
        self.date = date ?? ""
        self.decs = decs ?? ""
        self.photo = photo
        
        self.likecount = likecount
        self.follow = follow
    }
    
}
