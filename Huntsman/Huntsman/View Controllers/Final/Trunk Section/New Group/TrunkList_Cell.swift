//
//  TrunkList_Cell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 30/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class TrunkList_Cell: UITableViewCell {
    
    @IBOutlet weak var view_base: UIView!
    
    @IBOutlet weak var img_trunk: UIImageView!
    @IBOutlet weak var Lbl_TrunkTitle: UILabel!
    @IBOutlet weak var Lbl_TrunkDescrip: UILabel!
    
    @IBOutlet weak var BookmarkLeading: NSLayoutConstraint!

    @IBOutlet weak var Lbl_Date: UILabel!
    @IBOutlet weak var Btn_like: UIButton!
    @IBOutlet weak var Btn_BookMark: UIButton!
    @IBOutlet weak var Btn_Attendent: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        view_base = UIUtil.dropShadow(view: view_base, color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
