//
//  Wardrobe_AnimationVC.swift
//  Huntsman
//
//  Created by Mac on 5/18/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
class Wardrobe_AnimationVC: UIViewController,SWRevealViewControllerDelegate {

    var ProductUrl = ""
    var ProductId = ""
    var strWardrobeType = String()
    @IBAction func btn_Sixth(_ sender: Any) {
        strWardrobeType = "Socks"
        navigateToWardrobeList(strType: strWardrobeType)
    }
    @IBAction func btn_Fifth(_ sender: Any) {
        strWardrobeType = "Shoes"
         navigateToWardrobeList(strType: strWardrobeType)
    }
    @IBAction func btn_Forth(_ sender: Any) {
        strWardrobeType = "TROUSERS"
         navigateToWardrobeList(strType: strWardrobeType)
    }
    @IBAction func btn_Third(_ sender: Any) {
        strWardrobeType = "Shirts"
         navigateToWardrobeList(strType: strWardrobeType)
    }
    @IBAction func btn_Two(_ sender: Any) {
        strWardrobeType = "JACKET"
         navigateToWardrobeList(strType: strWardrobeType)
    }
    @IBAction func btn_One(_ sender: Any) {
        strWardrobeType = "Ties"
        navigateToWardrobeList(strType: strWardrobeType)
    }
    @IBOutlet weak var Btn_Count: UIButton!
    @IBOutlet weak var Btn_Menu: UIButton!

    @IBOutlet weak var Image_Product: UIImageView?
    @IBOutlet weak var View_Prodcut: UIView!
    @IBOutlet weak var TextView: UITextView!
    @IBOutlet weak var Constraint_TextViewHeight: NSLayoutConstraint!

    @IBOutlet weak var img_bg: UIImageView?
    @IBOutlet weak var lbl_ProductTitle: UILabel?

    @IBOutlet weak var Btn_First: UIButton!
    @IBOutlet weak var Btns_Second: UIButton!
    @IBOutlet weak var Btn_Third: UIButton!
    @IBOutlet weak var Btn_Fourth: UIButton!
    @IBOutlet weak var Btn_Five: UIButton!
    @IBOutlet weak var Btn_Six: UIButton!

    @IBOutlet weak var Btn_Open: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // SWRevealViewController  class drawer
        self.revealViewController().delegate = self
        Btn_Menu.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents
            .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.View_Prodcut.isHidden = true

       img_bg?.image = UIImage(named:"WardrobeN1.jpg")
        
        Btn_First.isUserInteractionEnabled = false
        Btns_Second.isUserInteractionEnabled = false
        Btn_Third.isUserInteractionEnabled = false
        Btn_Fourth.isUserInteractionEnabled = false
        Btn_Five.isUserInteractionEnabled = false
        Btn_Six.isUserInteractionEnabled = false

        Btn_First.isHidden = true
        Btns_Second.isHidden = true
        Btn_Third.isHidden = true
        Btn_Fourth.isHidden = true
        Btn_Five.isHidden = true
        Btn_Six.isHidden = true

        Call_WardrobeProductSuggestion()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.Btn_Count.setTitle("\(DiscoverNotificationCount.NotificationCount)", for: .normal)
    }
    // MARK: Api Call_WardrobeProductSuggestion
    func Call_WardrobeProductSuggestion() {
        LoderGifView.MyloaderShow(view: self.view)
         /* MARK: URLConstant.API.USER_SUGGESTED_PRODUCT Class in url and params..(user product suggestion) */
        WebserviceUtil.callGet(jsonRequest: URLConstant.API.USER_SUGGESTED_PRODUCT,view:self.view ,success: { (response) in
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        LoderGifView.MyloaderHide(view: self.view)
                        
                        let Product = (json.value(forKey: "product")  as! NSArray)
                        if Product.count == 0  {
                        } else  {
                            let  list = Product[0] as! NSDictionary
                            self.ProductUrl = ((list as AnyObject).value(forKey: "product_url") as? String)!
                            self.ProductId = ((list as AnyObject).value(forKey: "product_id") as? String)!
                            
                           self.TextView.isUserInteractionEnabled = false
                            
                            let HtmlStringconvertTitle = (list as AnyObject).value(forKey: "title") as! String
                            do {
                                let finalstring    =  try NSAttributedString(data: HtmlStringconvertTitle.data(using: String.Encoding.utf8)!, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue],documentAttributes: nil)
                                self.lbl_ProductTitle?.text = finalstring.string
                                
                            } catch {
                                print("Cannot convert html string to attributed string: \(error)")
                            }
                            
                            if let pic = ((list as AnyObject).value(forKey: "image") as? String), pic != "" {
                                self.Image_Product?.sd_setImage(with: URL(string: pic), placeholderImage: UIImage(named: "no image"))
                            }else {
                                self.Image_Product?.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "no image"))
                            }
                            
                            let imgRect = UIBezierPath(rect: CGRect(x: 0, y: 0, width: (self.Image_Product?.frame.width)!, height: (self.Image_Product?.frame.height)!))
                            
                            self.TextView.textContainer.exclusionPaths = [imgRect]
                            self.TextView.isScrollEnabled = false
                            
                            let HtmlconvertDescription = (list as AnyObject).value(forKey: "description") as! String
                            do {
                                let finalstring    =  try NSAttributedString(data: HtmlconvertDescription.data(using: String.Encoding.utf8)!, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue],documentAttributes: nil)
                                 self.TextView.text = finalstring.string
                                
                            } catch {
                                print("Cannot convert html string to attributed string: \(error)")
                            }
                            
                        
                            let Frame = self.TextView.frame.size.height
                            
                            let newSize = self.TextView.sizeThatFits(CGSize(width: self.TextView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
                            self.TextView.frame.size = CGSize(width: max(newSize.width, self.TextView.frame.size.width), height: newSize.height)
                            
                            if Frame > newSize.height {
                                self.Constraint_TextViewHeight.constant = 140
                            }  else {
                               self.Constraint_TextViewHeight.constant = self.TextView.frame.size.height
                                
                            }
                            self.View_Prodcut.isHidden = false

                           let Product_Seen = ((list as AnyObject).value(forKey: "seen") as? String)!
                            if Product_Seen == "0" {
                                self.View_Prodcut.isHidden = false
                            }  else {
                            self.View_Prodcut.isHidden = true
                            }
                        }
                    } else {
                        LoderGifView.MyloaderHide(view: self.view)
                        UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            LoderGifView.MyloaderHide(view: self.view)
            if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)" {
                UIUtil.showMessage(title: "No Internet Connection", message:"Make sure your device is connected to the internet.", controller: self, okHandler: nil)
            } else  {
                UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
            }
        }
    }
    
    
    @IBAction func Action_RootDiscover(sender: AnyObject?) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.rootview_views(string: "discover")
    }
    
    @IBAction func Action_ProductHidden(sender: AnyObject?) {
        self.View_Prodcut.isHidden = true
         Call_UserSuggestedProductSeen()
    }
    
    @IBAction func Action_View_WardrobeWeb(sender: AnyObject?)  {
        
       Call_UserSuggestedProductSeen()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let WebView = storyBoard.instantiateViewController(withIdentifier: "Wardrobe_WebviewVC") as! Wardrobe_WebviewVC
         WebView.Str_url = self.ProductUrl
        present(WebView, animated: true, completion: nil)
        self.View_Prodcut.isHidden = true
    }
    
    // MARK: API Call_UserSuggestedProductSeen
    func Call_UserSuggestedProductSeen() {
        
        let params = [
            URLConstant.Param.PRODUCTID:self.ProductId
        ]
        /* MARK: URLConstant.API.USER_SUGGESTEDPRODUCT_SEEN Class in url and params (Product seen/Unseen ) */
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.USER_SUGGESTEDPRODUCT_SEEN,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                    } else {
                        if let msg = json.value(forKey:"message") as? String, msg == "Invalid auth token."{
                            UIUtil.showLogout(title: "", message:"It seems you logged-in on other device with same user. To continue with same device please log-in again.", controller: self, okHandler: nil)
                        } else {
                            UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                        }
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)" {
                UIUtil.showMessage(title: "No Internet Connection", message:"Make sure your device is connected to the internet.", controller: self, okHandler: nil)
            } else {
                UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
            }
        }
    }
    
    @IBAction func Action_notification(_ sender: Any) {
        LoderGifView.MyloaderHide(view: self.view)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "Notification_VC") as! Notification_VC
        present(profile, animated: true, completion: nil)
    }
    
    @IBAction func Action_Open(sender: AnyObject?) {
        var myimgArr = [] as NSArray
        
        myimgArr = ["WardrobeN1.jpg","WardrobeN2.jpg","WardrobeN3.jpg"]
        
        var images = [UIImage]()
        
        for i in 0..<myimgArr.count {
            images.append(UIImage(named: myimgArr[i] as! String)!)
        }
        img_bg?.animationImages = images
        img_bg?.image = images.last
        img_bg?.animationDuration = 0.4
        img_bg?.animationRepeatCount = 1
        img_bg?.startAnimating()
        Btn_Open.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.Wardrob_BtnAnimation()
        }
    }
    
     func Wardrob_BtnAnimation() {
        self.Btn_First.isHidden = false
        self.Btns_Second.isHidden = false
        self.Btn_Third.isHidden = false
        self.Btn_Fourth.isHidden = false
        self.Btn_Five.isHidden = false
        self.Btn_Six.isHidden = false
        
        self.Btn_First.isUserInteractionEnabled = true
        self.Btns_Second.isUserInteractionEnabled = true
        self.Btn_Third.isUserInteractionEnabled = true
        self.Btn_Fourth.isUserInteractionEnabled = true
        self.Btn_Five.isUserInteractionEnabled = true
        self.Btn_Six.isUserInteractionEnabled = true
    }
    
    // Admin Huntsman chat for flage - profile.Flage_PrivousVC = "wardrobe_admin"
    @IBAction func Action_WardrobeChat(sender: AnyObject?) {
            Call_UserSuggestedProductSeen()
            let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "Admin_ChatVC") as! Admin_ChatVC
            profile.Flage_PrivousVC = "wardrobe_admin"
            present(profile, animated: true, completion: nil)
            self.View_Prodcut.isHidden = true
    }
    
    @IBAction func Action_Chat(sender: AnyObject?) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "Admin_ChatVC") as! Admin_ChatVC
        profile.Flage_PrivousVC = "wardrobe_admin"
        present(profile, animated: true, completion: nil)
    }
    
    @IBAction func Action_WardrobeUserlist(sender: AnyObject?) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func navigateToWardrobeList(strType: String?) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let WardrobeUserlist = storyBoard.instantiateViewController(withIdentifier: "WardrobeUserlist") as! WardrobeUserlist
        WardrobeUserlist.strWardrobeType = strType!
        present(WardrobeUserlist, animated: true, completion: nil)
    }
}
