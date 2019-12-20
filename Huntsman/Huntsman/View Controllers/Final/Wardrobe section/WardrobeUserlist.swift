//
//  WardrobeUserlist.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 16/05/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class WardrobeUserlist: UIViewController,SWRevealViewControllerDelegate {
    
    var strWardrobeType = String()
    @IBOutlet weak var Btn_Menu: UIButton!
    @IBOutlet weak var tableview: UITableView!
    
    var Section = [] as NSArray
    var Dict = [:] as NSDictionary
    
    var ProductId = ""
    var Str_Category = ""
    var Str_CategoryId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.estimatedRowHeight = 190.0
        tableview.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.Call_WardrobeUserList()
    }
    
    func Call_WardrobeUserList() {
        LoderGifView.MyloaderShow(view: self.view)
        
/*        let params = [
                   URLConstant.Param.PAGE:Str_Page,
                   URLConstant.Param.PRODUCT_LIST:"all",
                   URLConstant.Param.CATEGORY_ID:CategoryId,
                   ] */
        
        /* MARK:  URLConstant.API.WARDROBUSER in api name (for user wardrobe list)*/
        WebserviceUtil.callGet(jsonRequest: URLConstant.API.WARDROBUSER,view:self.view ,success: { (response) in
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        LoderGifView.MyloaderHide(view: self.view)
                        if (json.value(forKey: "wardrobe") as? NSDictionary) != nil {
                            self.Dict = (json.value(forKey: "wardrobe") as! NSDictionary)
                            self.Section = self.Dict.allKeys as NSArray
                            self.tableview.reloadData()
                            self.automaticallyAdjustsScrollViewInsets = false
                            self.tableview.contentInset = UIEdgeInsets (top: 0,left: 0,bottom: -20,right: 0)
                        }
                        else
                        {
                            let alert = CustomAlert (title:"",Message:(json.value(forKey: "message") as? String)!)
                            alert.show(animated: true)
                            self.Section = []
                            self.tableview.reloadData()
                        }
                    }
                    else {
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
            if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)"
            {
                UIUtil.showMessage(title: "No Internet Connection", message:"Make sure your device is connected to the internet.", controller: self, okHandler: nil)
            }
            else
            {
                UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
            }
        }
    }
    
    @IBAction func Action_AddOutfits(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let AddoutFits = storyBoard.instantiateViewController(withIdentifier: "WardrobeCategoryOutfit") as! WardrobeCategoryOutfit
        present(AddoutFits, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension WardrobeUserlist:UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customView = UIView()
        customView.frame = CGRect.init(x: 0, y: 0, width:  Device.SCREEN_WIDTH, height: 40)
        customView.backgroundColor = UIColor.clear
        let lbl_title = UILabel()
        lbl_title.frame = CGRect.init(x: 5, y: 0, width:  Device.SCREEN_WIDTH - 50 , height: 40)
        lbl_title.backgroundColor = UIColor.clear
        lbl_title.text = (Section [section] as! String).uppercased()
        print(lbl_title.text as Any)

        lbl_title.font = UIFont(name: "Gill Sans" , size: 19.0)
        customView.addSubview(lbl_title)
        let lbl_line = UILabel()
        lbl_line.frame = CGRect.init(x: 5, y: 34, width:40 , height: 2)
        lbl_line.backgroundColor = UIColor(red: 143/255.0,
                                           green: 0/255.0,
                                           blue: 42/255.0,
                                           alpha: 1.0)
        customView.addSubview(lbl_line)
        return customView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.Section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let Str_Title = (self.Section [section] as! String)
        let Rows = self.Dict[Str_Title] as! NSArray
        return Rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "WardrobUser_Cell", for: indexPath) as! WardrobUser_Cell
        
        let Str_Title = (self.Section[indexPath.section] as! String)
        let Row = self.Dict[Str_Title] as! NSArray
        let list = Row[indexPath.row] as! NSDictionary

        if let pic = list["imgage"] as? String, pic != "" {
            cell.Img_ProfilePic.sd_setImage(with: URL(string: pic), placeholderImage: UIImage(named: "no image"))
        } else {
            cell.Img_ProfilePic.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "no image"))
        }

        let HtmlconvertTitle = list["title"] as? String
        do {
            let finalstring    =  try NSAttributedString(data: (HtmlconvertTitle?.data(using: String.Encoding.utf8)!)!, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue],documentAttributes: nil)
            cell.Lbl_Title.text = finalstring.string
            
        } catch {
            print("Cannot convert html string to attributed string: \(error)")
        }
        
        
        let HtmlconvertDescription = list["description"] as? String
        do {
            let finalstring    =  try NSAttributedString(data: (HtmlconvertDescription?.data(using: String.Encoding.utf8)!)!, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue],documentAttributes: nil)
            cell.Lbl_Description.text = finalstring.string
            
        } catch {
            print("Cannot convert html string to attributed string: \(error)")
        }

        cell.Btn_RemoveWardrobe.tag = (indexPath.section*100) + indexPath.row
        cell.Btn_RemoveWardrobe.addTarget(self, action: #selector(Btn_Remove(sender:)), for: .touchUpInside)
      
        return cell
    }
    
    func tableView(_ table_view: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Str_Title = (self.Section[indexPath.section] as! String)
        let Row = self.Dict[Str_Title] as! NSArray
        let list = Row[indexPath.row] as! NSDictionary
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let WardrobeDetail = storyBoard.instantiateViewController(withIdentifier: "Wardrobe_Detail") as! Wardrobe_Detail
        WardrobeDetail.Str_ProductId = (list["product_id"] as? String)!
        WardrobeDetail.Str_InWardrobe = "1"
        WardrobeDetail.Category = (list["category"] as? String)!
        WardrobeDetail.CategoryId = (list["category_id"] as? String)!
        
        present(WardrobeDetail, animated: true, completion: nil)
    }
    
    @objc func Btn_Remove(sender: UIButton)  {
        
        let section = sender.tag / 100
        let row = sender.tag % 100
        let Str_Title = (self.Section[section] as! String)
        let Row = self.Dict[Str_Title] as! NSArray
        let list = Row[row] as! NSDictionary
        print(list)
        
        ProductId = (list["product_id"] as? String)!
        Str_Category = (list["category"] as? String)!
        Str_CategoryId = (list["category_id"] as? String)!
        
        let alert = UIAlertController(title: "Huntsman", message: "Do you want to remove this product from your wardrobe?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: RemoveHandeler))
        self.present(alert, animated: true, completion: nil)
        
    }
    func RemoveHandeler(alert: UIAlertAction!)
    {
        Call_AddRemoveToWardrobe()
    }
    // MARK: API Call_AddRemoveToWardrobe
    func Call_AddRemoveToWardrobe() {
        LoderGifView.MyloaderShow(view: self.view)
        
        let params = [
            URLConstant.Param.PRODUCTID:ProductId,
            URLConstant.Param.CATEGORY:Str_Category,
            URLConstant.Param.CATEGORY_ID:Str_CategoryId,
            URLConstant.Param.STR_ACTION:"remove",
            
            ] as [String : Any]
        // MARK: URLConstant.API.WARDROBE_ADDREMOVEPRODUCT class in api name and parmas...
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.WARDROBE_ADDREMOVEPRODUCT,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        LoderGifView.MyloaderHide(view: self.view)
                        self.Call_WardrobeUserList()
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
            if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)"
            {
                UIUtil.showMessage(title: "No Internet Connection", message:"Make sure your device is connected to the internet.", controller: self, okHandler: nil)
            }
            else
            {
                UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
            }
        }
    }

    @IBAction func ActionBack(sender: AnyObject?){
        self.dismiss(animated: true, completion: nil)
    }
}
