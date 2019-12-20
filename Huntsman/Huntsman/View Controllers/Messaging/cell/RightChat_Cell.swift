//
//  RightChat_Cell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 27/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class RightChat_Cell: UITableViewCell {
    
    @IBOutlet weak var img_red: UIImageView!
    @IBOutlet weak var Lbl_RightChatText: UILabel!
    @IBOutlet weak var Lbl_RightDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

}
