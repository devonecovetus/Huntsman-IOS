//
//  requestbooking_cell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 08/05/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class requestbooking_cell: UITableViewCell {
    
    @IBOutlet weak var view_base: UIView!
    
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var btn_status: UIButton!
    @IBOutlet weak var btn_message: UIButton!

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
