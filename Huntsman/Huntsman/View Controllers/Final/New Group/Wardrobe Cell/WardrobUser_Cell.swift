//
//  WardrobUser_Cell.swift
//  Huntsman
//
//  Created by Mac on 5/17/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class WardrobUser_Cell: UITableViewCell {
    
    @IBOutlet weak var view_base: UIView!
    @IBOutlet weak var Img_ProfilePic: UIImageView!
    @IBOutlet weak var Lbl_Title: UILabel!
    @IBOutlet weak var Lbl_Description: UILabel!
    @IBOutlet weak var Btn_RemoveWardrobe: UIButton!
    @IBOutlet weak var Btn_AddRemoveWardrobe: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_base = UIUtil.dropShadow(view: view_base, color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
