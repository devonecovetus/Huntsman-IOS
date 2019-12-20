//
//  Trunk_ShowsVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 30/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class Trunk_ShowsVC: ButtonBarPagerTabStripViewController,SWRevealViewControllerDelegate ,Trunkshow_MapDelegate,TrunkShowList_Delegate,TrunkShow_MyBookmark_Delegate,TrunkShow_CalenderDelegate {
  
    @IBOutlet weak var Btn_Menu: UIButton!
    
    var imageview: UIImageView?
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = self?.purpleInspireColor
        }
    }
    
    @IBAction func Action_request(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "RequestBooking_VC") as! RequestBooking_VC
        present(profile, animated: true, completion: nil)
    }
    
   //  delegate access
    func Trunkshow_CalenderLoderShow() {
        let jeremyGif = UIImage.gifImageWithName("Huntsman")
        imageview = UIImageView(image: jeremyGif)
        imageview?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let hud = MBProgressHUD.showAdded(to:self.view, animated: true)
        hud?.mode = MBProgressHUDModeCustomView
        hud?.color = UIColor.clear
        hud?.customView = imageview
        return view.addSubview((hud?.customView)!)
    }
    
    func Trunkshow_CalenderLoderHide() {
        imageview?.removeFromSuperview()
        _ = MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

    }
    
    func TrunkshowBookmark_LoderHide() {
        imageview?.removeFromSuperview()
        _ = MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

    }
    
    func TrunkshowBookmark_LoderShow() {
        let jeremyGif = UIImage.gifImageWithName("Huntsman")
        imageview = UIImageView(image: jeremyGif)
        imageview?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let hud = MBProgressHUD.showAdded(to:self.view, animated: true)
        hud?.mode = MBProgressHUDModeCustomView
        hud?.color = UIColor.clear
        hud?.customView = imageview
        return view.addSubview((hud?.customView)!)
    }
    
    func Trunkshowlist_LoderShow() {
        let jeremyGif = UIImage.gifImageWithName("Huntsman")
        imageview = UIImageView(image: jeremyGif)
        imageview?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let hud = MBProgressHUD.showAdded(to:self.view, animated: true)
        hud?.mode = MBProgressHUDModeCustomView
        hud?.color = UIColor.clear
        hud?.customView = imageview
        return view.addSubview((hud?.customView)!)
    }
    
    func Trunkshowlist_LoderHide() {
        imageview?.removeFromSuperview()
        _ = MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

    }
    
    func TrunkshowMap_LoderShow() {
        let jeremyGif = UIImage.gifImageWithName("Huntsman")
        imageview = UIImageView(image: jeremyGif)
        imageview?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let hud = MBProgressHUD.showAdded(to:self.view, animated: true)
        hud?.mode = MBProgressHUDModeCustomView
        hud?.color = UIColor.clear
        hud?.customView = imageview
        return view.addSubview((hud?.customView)!)
    }
    
    func TrunkshowMap_LoderHide() {
        imageview?.removeFromSuperview()
        _ = MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController]
    {
        let vc1 = storyboard?.instantiateViewController(withIdentifier: "TrunkShow_CalenderVC") as? TrunkShow_CalenderVC
        vc1?.delegate = self
        let vc2 = storyboard?.instantiateViewController(withIdentifier: "TrunkShow_ListVC") as? TrunkShow_ListVC
        vc2?.delegate = self
        let vc3 = storyboard?.instantiateViewController(withIdentifier: "TrunkShow_MapVC") as? TrunkShow_MapVC
        vc3?.delegate = self
        let vc4 = storyboard?.instantiateViewController(withIdentifier: "TrunkShow_MyBookmarkVC") as? TrunkShow_MyBookmarkVC
        vc4?.delegate = self
        return [vc1!,vc2!,vc3!,vc4!]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
