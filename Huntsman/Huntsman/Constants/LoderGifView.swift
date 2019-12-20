//
//  LoderGifView.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 07/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class LoderGifView: UIView {
    
    static var imageview: UIImageView!
    
    class func MyloaderShow(view: UIView) -> Void {
        
        let jeremyGif = UIImage.gifImageWithName("Huntsman")
        imageview = UIImageView(image: jeremyGif)
        imageview.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)

        hud?.mode = MBProgressHUDModeCustomView
        hud?.color = UIColor.clear
        hud?.customView = imageview
        return view.addSubview((hud?.customView)!)
        
    }
    
    class func MyloaderHide(view: UIView) {
        imageview.removeFromSuperview()
        _ = MBProgressHUD.hideAllHUDs(for: view, animated: true)
        
    }
    
    class func LoderCustomNavigationShow(ViewController:UIViewController?) {
        let jeremyGif = UIImage.gifImageWithName("Huntsman")
        imageview = UIImageView(image: jeremyGif)
        imageview.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        let hud = MBProgressHUD.showAdded(to:ViewController?.view, animated: true)
        hud?.mode = MBProgressHUDModeCustomView
        hud?.color = UIColor.clear
        hud?.customView = imageview
        return ViewController!.view.addSubview((hud?.customView)!)
    }
    
    class func LoderCustomNavigationHide(ViewController:UIViewController?) {
        imageview.removeFromSuperview()
        _ = MBProgressHUD.hideAllHUDs(for: ViewController?.view, animated: true)

    }
    
}



