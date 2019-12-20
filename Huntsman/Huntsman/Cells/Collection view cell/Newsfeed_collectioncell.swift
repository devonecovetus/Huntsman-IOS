//
//  Newsfeed_collectioncell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 20/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class Newsfeed_collectioncell: UICollectionViewCell {
    
    @IBOutlet weak var view_base: UIView!

    @IBOutlet weak var Img_Feed: UIImageView!
    @IBOutlet weak var Lbl_FeedTitle: UILabel!
    @IBOutlet weak var Lbl_FeedDescrip: UILabel!
    
    @IBOutlet weak var Lbl_Date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_base.layer.masksToBounds = false
        view_base.layer.borderColor = UIColor.lightGray.cgColor
        view_base.layer.borderWidth = 0.5
    }
}
