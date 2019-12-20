//
//  WardrobeCollection_Cell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 16/05/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class WardrobeCollection_Cell: UICollectionViewCell {
    
    @IBOutlet weak var view_base: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var Lbl_category: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_base.layer.masksToBounds = false
        view_base.layer.borderColor = UIColor.lightGray.cgColor
        view_base.layer.borderWidth = 0.5
    }
}
