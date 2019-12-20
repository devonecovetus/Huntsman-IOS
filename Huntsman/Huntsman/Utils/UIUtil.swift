//
//  UIUtil.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 01/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import Foundation
import UIKit

class UIUtil {
    
    class func showMessage(title: String, message: String, controller: UIViewController, okHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
            if okHandler != nil {
                okHandler!()
            }
        }
        alertController.addAction(dismissAction)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func showLogout(title: String, message: String, controller: UIViewController, okHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
            SideMenuStruct.someStringConstant = ""
            
            let TokenSave = PreferenceUtil.getUserdevicetoken()
            print(TokenSave)
            
            let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                defaults.removeObject(forKey: key)
            }
            print("Device Token: \(TokenSave)")
            PreferenceUtil.saveUserdevicetoken(token: TokenSave)
            
            let TokenSave1 = PreferenceUtil.getUserdevicetoken()
            print(TokenSave1)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.Call_LoginScreen()
        }
        
        alertController.addAction(dismissAction)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func dropShadow(view: UIView, color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) -> UIView {
        view.layer.masksToBounds = false
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = offSet
        view.layer.shadowRadius = radius
        return view
    }
    
    class func dropShadowButton(button: UIButton) -> UIButton {
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: -3.0, height: 3.0)
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 3.0
        button.layer.shadowOpacity = 3.0
        button.layer.cornerRadius = button.frame.width / 2
        return button
    }

}


