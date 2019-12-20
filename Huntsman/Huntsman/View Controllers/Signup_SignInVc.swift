//
//  Signup_SignInVc.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 14/07/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class Signup_SignInVc: UIViewController {

    @IBOutlet weak var Btn_SignIn:UIButton!
    @IBOutlet weak var Btn_SignUP:UIButton!
    @IBOutlet weak var img_bg: UIImageView?

    @IBAction func btn_TermsConditions(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WebContentViewController") as! WebContentViewController
        vc.strTitle = "Terms & Conditions"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_PrivacyPolicy(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WebContentViewController") as! WebContentViewController
        vc.strTitle = "Privacy Policy"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBOutlet weak var lbl_CLick: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (Device.IS_IPHONE_X){ //iPhone X
            img_bg?.image = UIImage(named:"step-bg-x.png")
        }
        setUpLabelClickingSetting()
    }
    
    func setUpLabelClickingSetting() {
        lbl_CLick.text = "By clicking on signup you ar agree to the Terms & Conditions and Privacy Policy. Please click here to review."
        let text = (lbl_CLick.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Terms & Conditions")
        underlineAttriString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range1)
        let range2 = (text as NSString).range(of: "Privacy Policy")
        underlineAttriString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range2)
        lbl_CLick.attributedText = underlineAttriString
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(tapLabel(gesture:)))
        tapGesture.isEnabled = true
        lbl_CLick.isUserInteractionEnabled = true
       // tapGesture.delegate = self as! UIGestureRecognizerDelegate
        lbl_CLick.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (lbl_CLick.text)!
        let termsRange = (text as NSString).range(of: "Terms & Conditions")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")

        if gesture.didTapAttributedTextInLabel(label: lbl_CLick, inRange: termsRange) {
            print("Tapped terms")
            
            
            
        } else if gesture.didTapAttributedTextInLabel(label: lbl_CLick, inRange: privacyRange) {
            print("Tapped privacy")
        } else {
            print("Tapped none")
        }
    }

    
    // sign in ibaction
    @IBAction func Sign_In(sender: AnyObject?){
        if Device.IS_IPHONE_5 {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Iphone5", bundle: nil)
            let login_vc = mainStoryboard.instantiateViewController(withIdentifier: "Login_ViewController") as! Login_ViewController
            self.navigationController?.pushViewController(login_vc, animated: true)
        } else {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let login_vc = mainStoryboard.instantiateViewController(withIdentifier: "Login_ViewController") as! Login_ViewController
            self.navigationController?.pushViewController(login_vc, animated: true)
        }
    }
    // sign up ibaction
    @IBAction func Sign_UP(sender: AnyObject?){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "SignupStep1_VC") as! SignupStep1_VC
        self.navigationController?.pushViewController(profile, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
}

extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        print("target Range = \(targetRange.location)")
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y) // CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,  (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer =  CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}
