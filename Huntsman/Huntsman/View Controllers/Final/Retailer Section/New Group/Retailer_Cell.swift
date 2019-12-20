//
//  Retailer_Cell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 17/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class Retailer_Cell: UITableViewCell {

    @IBOutlet weak var view_base: UIView!
    
    @IBOutlet weak var Img_ProfilePic: UIImageView!
    @IBOutlet weak var Lbl_city: UILabel!
    @IBOutlet weak var Lbl_name: UILabel!
    @IBOutlet weak var Btn_bookmark: UIButton!
    @IBOutlet weak var Lbl_aboutuser: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        view_base = UIUtil.dropShadow(view: view_base, color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
