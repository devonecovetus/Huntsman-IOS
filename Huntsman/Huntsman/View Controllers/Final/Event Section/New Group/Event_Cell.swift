//
//  Event_Cell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 11/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

protocol EventDelegate {
    func inviteForEvent(index: Int)
}

class Event_Cell: UITableViewCell {
    var delegate: EventDelegate?
       var indexValue: Int = Int()
    @IBOutlet weak var view_base: UIView!
    
    @IBOutlet weak var btnAttendantWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var Img_Event: UIImageView!
    @IBOutlet weak var Lbl_EventTitle: UILabel!
    @IBOutlet weak var StakeViewWidth: NSLayoutConstraint!

    @IBOutlet weak var btn_Invite: UIButton!
    @IBAction func btn_Invite(_ sender: Any) {
        delegate?.inviteForEvent(index: indexValue)
    }
    @IBOutlet weak var Lbl_Date: UILabel!
    @IBOutlet weak var Btn_follow: UIButton!
    @IBOutlet weak var Btn_BookMark: UIButton!
    @IBOutlet weak var Btn_Attendent: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        view_base = UIUtil.dropShadow(view: view_base, color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
