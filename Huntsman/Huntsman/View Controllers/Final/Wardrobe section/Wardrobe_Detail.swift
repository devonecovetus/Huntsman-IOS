//
//  Wardrobe_Detail.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 17/05/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class Wardrobe_Detail: UIViewController {
    
    @IBOutlet weak var Img_ProfilePic: UIImageView!
    @IBOutlet weak var Lbl_Title: UILabel!
    @IBOutlet weak var Lbl_Description: UILabel!
    @IBOutlet weak var Btn_AddRemoveHuntsman: UIButton!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    var CategoryId = ""
    var Category = ""
    var flag_updation = "0"
    
    var Dict = [:]
        as NSDictionary
    var Str_ProductId = ""
    var Str_InWardrobe = ""
    var BoolAddremoveWardrobe: Bool!
    var Inwardrobe : Int = 0
    // call back function --callupdateWardrobe
    var callupdateWardrobe:((_ ProductId:NSString, _ updation:NSString, _ Inwardrobe:Int)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Str_InWardrobe == "1"  {
            BoolAddremoveWardrobe = false
            Btn_AddRemoveHuntsman.setTitle("Remove from Huntsman Wardrobe", for: .normal)
        } else  {
            BoolAddremoveWardrobe = true
            Btn_AddRemoveHuntsman.setTitle("Add to Huntsman Wardrobe", for: .normal)
            
        }
        self.Call_AllProductDetail()
    }
    // MARK: API Call_AllProductDetail
    func Call_AllProductDetail() {
        LoderGifView.MyloaderShow(view: self.view)
        let params = [
            URLConstant.Param.PRODUCTID:Str_ProductId,
            ]
        /* MARK: API Call_AllProductDetail  (for product wardrobe detail ) */
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.WARDROBE_PRODUCTDETAIL,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        self.Dict = (json.value(forKey: "product_detail")  as! NSDictionary)
                        if let pic = ((self.Dict as AnyObject).value(forKey: "imgage") as? String), pic != "" {
                            self.Img_ProfilePic.sd_setImage(with: URL(string: pic), placeholderImage: UIImage(named: "no image"))
                        } else {
                            self.Img_ProfilePic.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "no image"))
                        }
                        
                        self.Img_ProfilePic.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        self.Img_ProfilePic.contentMode = .scaleAspectFit // OR .scaleAspectFill
                        self.Img_ProfilePic.clipsToBounds = true
                        
                        let HtmlconvertTitle = ((self.Dict as AnyObject).value(forKey: "title") as? String)
                        do {
                            let finalstring    =  try NSAttributedString(data: (HtmlconvertTitle?.data(using: String.Encoding.utf8)!)!, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue],documentAttributes: nil)
                            self.Lbl_Title.text =  finalstring.string
                            
                        } catch {
                            print("Cannot convert html string to attributed string: \(error)")
                        }
                        
                        let HtmlconvertDescription = ((self.Dict as AnyObject).value(forKey: "description") as? String)
                        do {
                            let finalstring    =  try NSAttributedString(data: (HtmlconvertDescription?.data(using: String.Encoding.utf8)!)!, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue],documentAttributes: nil)
                            self.Lbl_Description.text =  finalstring.string
                            
                        } catch {
                            print("Cannot convert html string to attributed string: \(error)")
                        }
                        LoderGifView.MyloaderHide(view: self.view)
                    }
                    else {
                        LoderGifView.MyloaderHide(view: self.view)
                        UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            LoderGifView.MyloaderHide(view: self.view)
            if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)"   {
                UIUtil.showMessage(title: "No Internet Connection", message:"Make sure your device is connected to the internet.", controller: self, okHandler: nil)
            }  else  {
                UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
            }
        }
    }
    
    @IBAction func ActionBack(sender: AnyObject?)  {
        self.dismiss(animated: true, completion: nil)
        callupdateWardrobe?(Str_ProductId as NSString, flag_updation as NSString,Inwardrobe)
    }
    
    @IBAction func Action_AddRemoveWardrobe(sender: AnyObject?) {
        if BoolAddremoveWardrobe == true  {
            BoolAddremoveWardrobe = false
            Call_AddRemoveToWardrobe(StrAction: "add", StrProductId: Str_ProductId as NSString, Str_Category: Category as NSString)
        }  else {
            BoolAddremoveWardrobe = true
            Call_AddRemoveToWardrobe(StrAction: "remove", StrProductId: Str_ProductId as NSString, Str_Category: Category as NSString)
        }
    }
    
    func Call_AddRemoveToWardrobe(StrAction:NSString,StrProductId:NSString,Str_Category:NSString) {
        LoderGifView.MyloaderShow(view: self.view)
        let params = [
            URLConstant.Param.PRODUCTID:StrProductId,
            URLConstant.Param.CATEGORY:Str_Category,
            URLConstant.Param.CATEGORY_ID:CategoryId,
            URLConstant.Param.STR_ACTION:StrAction,
            ] as [String : Any]
        
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.WARDROBE_ADDREMOVEPRODUCT,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK"  {
                        //(json.value(forKey: "message") as? String)!
                        UIUtil.showMessage(title:"Your Huntsman stylist has added a suggestion for your wardrobe" , message: "", controller: self, okHandler: nil)
                        LoderGifView.MyloaderHide(view: self.view)
                        
                        if self.BoolAddremoveWardrobe == true {
                            self.Inwardrobe = 0
                            self.Btn_AddRemoveHuntsman.setTitle("Add to Huntsman Wardrobe", for: .normal)
                        }  else {
                            self.Inwardrobe = 1
                            self.Btn_AddRemoveHuntsman.setTitle("Remove from Huntsman Wardrobe", for: .normal)
                        }
                        self.flag_updation = "1"
                    }  else {
                        LoderGifView.MyloaderHide(view: self.view)
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
            LoderGifView.MyloaderHide(view: self.view)
            if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)" {
                UIUtil.showMessage(title: "No Internet Connection", message:"Make sure your device is connected to the internet.", controller: self, okHandler: nil)
            } else  {
                UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

