//
//  Member_cell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 16/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class Member_cell: UICollectionViewCell {
    
    @IBOutlet weak var view_base: UIView!
    @IBOutlet weak var img_base: UIImageView!
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var lbl_industry: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_noevent: UILabel!
    @IBOutlet weak var lbl_since: UILabel!
    @IBOutlet weak var Btn_Bookmark: UIButton!
    @IBOutlet weak var Btn_Comment: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_base.layer.masksToBounds = false
        view_base.layer.borderColor = UIColor.lightGray.cgColor
        view_base.layer.borderWidth = 0.5
    }
}

