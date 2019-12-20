//
//  WardrobeCateModel.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 19/05/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import Foundation
class WardrobeCateModel
{
    var added_at: String = ""
    var imgage: String = ""
    var in_wardrobe: Int = 0
    var description: String = ""
    var title: String = ""
    var category: String = ""
    var category_id: String = ""
    var product_id: String = ""

    //MARK: Initialization
    init?(product_id: String?, category_id: String?, category: String?, title: String?, description: String?, in_wardrobe: Int, imgage: String?, added_at:String?) {
        
        // Initialize stored properties.
        self.added_at = added_at ?? ""
        self.imgage = imgage ?? ""
        self.in_wardrobe = in_wardrobe
        self.description = description ?? ""
        self.title = title ?? ""
        
        self.category = category ?? ""
        self.category_id = category_id ?? ""
        self.product_id = product_id ?? ""
    }
}
