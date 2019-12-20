//
//  RetailerModel.swift
//  Huntsman
//
//  Created by Mac on 5/15/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import Foundation

class RetailerModel {
    
    //MARK: Properties
    var id: String = ""
    var photo: String = ""
    var city: String = ""
    var distance: String = ""
    var name: String = ""
    var desc: String = ""
    
    var bookmark: Int = 0
    
    //MARK: Initialization
    init?(id: String?, photo: String?, city: String?, distance: String?, name: String?, desc: String?, bookmark: Int) {
        
        self.id = id ?? ""
        self.photo = photo ?? ""
        self.city = city ?? ""
        self.distance = distance ?? ""
        self.name = name ?? ""
        self.desc = desc ?? ""
        self.bookmark = bookmark
    }
}
