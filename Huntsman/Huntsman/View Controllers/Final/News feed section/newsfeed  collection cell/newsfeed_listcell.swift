//
//  newsfeed_listcell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 16/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class newsfeed_listcell: UITableViewCell {
    
    @IBOutlet weak var view_base: UIView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lbldesc: UILabel!
    
    @IBOutlet weak var view_img1: UIView!
    @IBOutlet weak var ImageView11: UIImageView!
    
    @IBOutlet weak var view_img2: UIView!
    @IBOutlet weak var ImageView21: UIImageView!
    @IBOutlet weak var ImageView22: UIImageView!
    
    @IBOutlet weak var view_img3: UIView!
    @IBOutlet weak var ImageView31: UIImageView!
    @IBOutlet weak var ImageView32: UIImageView!
    @IBOutlet weak var ImageView33: UIImageView!

    @IBOutlet weak var lbllike: UILabel!
    @IBOutlet weak var Btn_like: UIButton!
    
    @IBOutlet weak var scroll_view: UIScrollView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        view_base = UIUtil.dropShadow(view: view_base, color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
