//
//  Notification_VC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 26/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class Notification_VC: ButtonBarPagerTabStripViewController ,NotificationAllVcDelegate,NotifiHuntsmanDelegate {
    
    @IBAction func btn_DeleteAllNotification(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteAllNotifications"), object: nil)
        
    }
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    
    var imageview: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = UIFont(name: "GillSansMT" , size: 15.0)!
        settings.style.selectedBarHeight = 1.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor(red: 143/255.0,
                                                         green: 0/255.0,
                                                         blue: 42/255.0,
                                                         alpha: 1.0)
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = {
            
            [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor
                = self?.purpleInspireColor
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let vc1 = storyboard?.instantiateViewController(withIdentifier: "Notification_AllVC") as? Notification_AllVC
        vc1?.delegate = self
        let vc2 = storyboard?.instantiateViewController(withIdentifier: "Notification_HuntsmanVC") as? Notification_HuntsmanVC
        vc2?.delegate = self
        return [vc1!,vc2!]
    }
    
    func NotifiHuntsmanLoaderHide() {
        imageview?.removeFromSuperview()
        _ = MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

    }
    
    func NotifiHuntsmanLoaderShow() {
        let jeremyGif = UIImage.gifImageWithName("Huntsman")
        imageview = UIImageView(image: jeremyGif)
        imageview?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let hud = MBProgressHUD.showAdded(to:self.view, animated: true)
        hud?.mode = MBProgressHUDModeCustomView
        hud?.color = UIColor.clear
        hud?.customView = imageview
        return view.addSubview((hud?.customView)!)
    }
    
    func NotifiAllLoaderHide() {
        imageview?.removeFromSuperview()
        _ = MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

    }
    
    func NotifiAllLoaderShow() {
        let jeremyGif = UIImage.gifImageWithName("Huntsman")
        imageview = UIImageView(image: jeremyGif)
        imageview?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let hud = MBProgressHUD.showAdded(to:self.view, animated: true)
        hud?.mode = MBProgressHUDModeCustomView
        hud?.color = UIColor.clear
        hud?.customView = imageview
        return view.addSubview((hud?.customView)!)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
