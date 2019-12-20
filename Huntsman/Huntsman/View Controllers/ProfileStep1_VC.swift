//
//  ProfileStep1_VC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 05/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class ProfileStep1_VC: UIViewController {
    
    @IBOutlet weak var img_bg: UIImageView?
    @IBOutlet weak internal var ypostion: NSLayoutConstraint!
    @IBOutlet weak var Btn_enter: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (Device.IS_IPHONE_X){ //iPhone X
            img_bg?.image = UIImage(named:"step-bg-x.png")
            ypostion.constant = -310
        }
        if(Device.IS_IPHONE_6P){ //iPhone Plus
            ypostion.constant = -300
        }
        if(Device.IS_IPHONE_5){ //iPhone 5
            ypostion.constant = -230
        }
        
        Btn_enter.semanticContentAttribute = .forceRightToLeft
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
