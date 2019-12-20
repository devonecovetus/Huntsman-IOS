//
//  SideMenu_Cell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 22/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class SideMenu_Cell: UITableViewCell {
    
    @IBOutlet weak var  Image_View: UIImageView?
    @IBOutlet weak var  Lbl_Title: UILabel?
    @IBOutlet weak var  Bg_View: UIView?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
