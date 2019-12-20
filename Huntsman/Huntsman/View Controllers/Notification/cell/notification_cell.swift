//
//  notification_cell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 26/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class notification_cell: UITableViewCell {

    @IBOutlet weak var view_base: UIView!
    
    @IBOutlet weak var img_view: UIImageView!
    @IBOutlet weak var img_icon: UIImageView!
    
    @IBOutlet weak var Lbl_title: UILabel!
    @IBOutlet weak var Lbl_date: UILabel!
    
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
