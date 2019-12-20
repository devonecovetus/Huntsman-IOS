//
//  HuntsMember_BaseVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 11/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HuntsMember_BaseVC: ButtonBarPagerTabStripViewController,SWRevealViewControllerDelegate,HuntMemberBookDelegate,HuntMember_MapDelegate,HuntMember_ListDelegate  {
   
    @IBAction func btn_Menu(_ sender: Any) {
    }
    @IBOutlet weak var Btn_Menu: UIButton!
    @IBOutlet weak var Btn_Count: UIButton!

    var imageview: UIImageView?
    
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.revealViewController().delegate = self
        Btn_Menu.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents
            .touchUpInside)

        // change selected bar color
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
                guard changeCurrentIndex == true else
                {
                    return
                }
                oldCell?.label.textColor = .black
                newCell?.label.textColor
                    = self?.purpleInspireColor
            }
        }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.Btn_Count.setTitle("\(DiscoverNotificationCount.NotificationCount)", for: .normal)
    }
    
   // delegate method ....
    func HuntMember_ListLoaderHide() {
        imageview?.removeFromSuperview()
        _ = MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
    
    func HuntMember_ListLoaderShow() {
        let jeremyGif = UIImage.gifImageWithName("Huntsman")
        imageview = UIImageView(image: jeremyGif)
        imageview?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let hud = MBProgressHUD.showAdded(to:self.view, animated: true)
        hud?.mode = MBProgressHUDModeCustomView
        hud?.color = UIColor.clear
        hud?.customView = imageview
        return view.addSubview((hud?.customView)!)
    }
    
    func HuntMember_MapLoaderHide() {
        imageview?.removeFromSuperview()
        _ = MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
    
    func HuntMember_MapLoaderShow() {
        let jeremyGif = UIImage.gifImageWithName("Huntsman")
        imageview = UIImageView(image: jeremyGif)
        imageview?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let hud = MBProgressHUD.showAdded(to:self.view, animated: true)
        hud?.mode = MBProgressHUDModeCustomView
        hud?.color = UIColor.clear
        hud?.customView = imageview
        return view.addSubview((hud?.customView)!)
    }
    
    func HuntsBookLoaderHide() {
        imageview?.removeFromSuperview()
        _ = MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

    }
    
    func HuntsBookLoaderShow() {
        let jeremyGif = UIImage.gifImageWithName("Huntsman")
        imageview = UIImageView(image: jeremyGif)
        imageview?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let hud = MBProgressHUD.showAdded(to:self.view, animated: true)
        hud?.mode = MBProgressHUDModeCustomView
        hud?.color = UIColor.clear
        hud?.customView = imageview
        return view.addSubview((hud?.customView)!)
    }
    
    // Action Notification screen
    @IBAction func Action_notification(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "Notification_VC") as! Notification_VC
        present(profile, animated: true, completion: nil)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let vc1 = storyboard?.instantiateViewController(withIdentifier: "HuntMember_ListVC") as? HuntMember_ListVC
        vc1?.delegate = self
        let vc2 = storyboard?.instantiateViewController(withIdentifier: "HuntMember_MapVC") as? HuntMember_MapVC
        vc2?.delegate = self
        let vc3 = storyboard?.instantiateViewController(withIdentifier: "HuntMember_BookmarkVC") as? HuntMember_BookmarkVC
        vc3?.delegate = self
        return [vc1!,vc2!,vc3!]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
