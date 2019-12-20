//
//  message_listingcell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 17/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class message_listingcell: UITableViewCell {

    @IBOutlet weak var view_base: UIView!
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lbldesc: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var Btn_bookmark: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        view_base.layer.masksToBounds = false
        view_base.layer.borderColor = UIColor.lightGray.cgColor
        view_base.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
