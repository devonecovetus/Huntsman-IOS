//
//  ChatLeft_Cell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 27/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class ChatLeft_Cell: UITableViewCell {

    @IBOutlet weak var img_grey: UIImageView!
    @IBOutlet weak var Lbl_LeftChatText: UILabel!
    @IBOutlet weak var Lbl_leftDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
