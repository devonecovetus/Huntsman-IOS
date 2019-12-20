//
//  Wardrobe_cell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 16/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class Wardrobe_cell: UICollectionViewCell {
    
    @IBOutlet weak var view_base: UIView!
    @IBOutlet weak var img_dress: UIImageView!
    @IBOutlet weak var lblcategory: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_base.layer.masksToBounds = false
        view_base.layer.borderColor = UIColor.lightGray.cgColor
        view_base.layer.borderWidth = 0.5
    }
}
