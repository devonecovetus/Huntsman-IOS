//
//  Trunk_collectioncell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 20/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class Trunk_collectioncell: UICollectionViewCell {
    
    @IBOutlet weak var view_base: UIView!

    @IBOutlet weak var img_trunk: UIImageView!
    @IBOutlet weak var Lbl_TrunkTitle: UILabel!
    @IBOutlet weak var Lbl_TrunkDescrip: UILabel!
    
    @IBOutlet weak var Lbl_Date: UILabel!
    @IBOutlet weak var Lbl_Month: UILabel!
    @IBOutlet weak var Lbl_Year: UILabel!
    
    @IBOutlet weak var Btn_like: UIButton!
    @IBOutlet weak var Btn_BookMark: UIButton!
    @IBOutlet weak var Btn_Attendent: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        view_base.layer.masksToBounds = false
        view_base.layer.borderColor = UIColor.lightGray.cgColor
        view_base.layer.borderWidth = 0.5
    }
    
}
