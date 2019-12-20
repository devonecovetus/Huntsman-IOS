//
//  WardrobeAllProductCategory.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 16/05/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class WardrobeAllProductCategory: UIViewController {
    var All_ProductCategory = [WardrobeCateModel]()
    
    var Str_Page = ""
    var intpage : Int = 0
    var more : Int!
    
    var pagereload : Int = 0
    var lodingApi: Bool!
    var CategoryId = ""
    var ProductCategoryId = ""
    var Category = ""
    var ProductId = ""
    var ProductIndex : Int = 0
    
    @IBOutlet weak var tableview: UITableView!
    var ProductCategory = [] as NSMutableArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.intpage = 0
        self.pagereload = 0
        self.Str_Page = String(self.intpage)
        self.Call_AllProductByCategory()
    }
    
    // MARK: API Call_AllProductByCategory
    func Call_AllProductByCategory() {
        LoderGifView.MyloaderShow(view: self.view)
        
        let params = [
            URLConstant.Param.PAGE:Str_Page,
            URLConstant.Param.PRODUCT_LIST:"all",
            URLConstant.Param.CATEGORY_ID:CategoryId,
            ]
       /* MARK: URLConstant.API.WARDROBE_PRODUCT_BYCATEGORY class in api name and params .(for get all category list)*/
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.WARDROBE_PRODUCT_BYCATEGORY,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let Productall = (json.value(forKey: "products")  as! NSMutableArray)
                        if Productall.count == 0
                        {
                            self.All_ProductCategory.removeAll()
                            self.tableview.reloadData()
                            LoderGifView.MyloaderHide(view: self.view)
                        }
                        else
                        {
                            let str_more = json.value(forKey: "more") as? String
                            self.more = Int(str_more!)!
                            let Productall = (json.value(forKey: "products")  as! NSMutableArray)
                            
                            if self.pagereload == 0 {
                                self.All_ProductCategory.removeAll()
                                for item in Productall {
                                    
                                    guard let Product = WardrobeCateModel(product_id: ((item as AnyObject).value(forKey: "product_id") as? String)!, category_id: ((item as AnyObject).value(forKey: "category_id") as? String)!, category: ((item as AnyObject).value(forKey: "category") as? String)!, title: ((item as AnyObject).value(forKey: "title") as? String)!, description: ((item as AnyObject).value(forKey: "description") as? String)!, in_wardrobe: ((item as AnyObject).value(forKey: "in_wardrobe") as? Int)!, imgage: ((item as AnyObject).value(forKey: "imgage") as? String)!, added_at:((item as AnyObject).value(forKey: "added_at") as? String)!) else
                                    {
                                        fatalError("Unable to instantiate meal2")
                                    }
                                    self.All_ProductCategory += [Product]
                                }
                            }
                            else
                            {
                                for item in Productall {
                                    guard let Product = WardrobeCateModel(product_id: ((item as AnyObject).value(forKey: "product_id") as? String)!, category_id: ((item as AnyObject).value(forKey: "category_id") as? String)!, category: ((item as AnyObject).value(forKey: "category") as? String)!, title: ((item as AnyObject).value(forKey: "title") as? String)!, description: ((item as AnyObject).value(forKey: "description") as? String)!, in_wardrobe: ((item as AnyObject).value(forKey: "in_wardrobe") as? Int)!, imgage: ((item as AnyObject).value(forKey: "imgage") as? String)!, added_at:((item as AnyObject).value(forKey: "added_at") as? String)!) else
                                    {
                                        fatalError("Unable to instantiate meal2")
                                    }
                                    self.All_ProductCategory += [Product]
                                }
                            }
                        }
                        self.lodingApi = true
                        self.tableview.reloadData()
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension WardrobeAllProductCategory:UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate{
    
    // MARK: -   ------- Table view delegate and datasource Method ------
    func tableView(_ table_view: UITableView, numberOfRowsInSection section: Int) -> Int {
        return All_ProductCategory.count
    }
    
    func tableView(_ table_view: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table_view.dequeueReusableCell(withIdentifier: "WardrobUser_Cell", for: indexPath) as! WardrobUser_Cell
        
        let Product : WardrobeCateModel
        
        Product = All_ProductCategory[indexPath.row]
        
        cell.Img_ProfilePic.sd_setImage(with: URL(string: Product.imgage), placeholderImage: UIImage(named: "no image"))
        if Product.in_wardrobe == 0
        {
            cell.Btn_AddRemoveWardrobe.setTitle("Add to Huntsman Wardrobe", for: .normal)
        }
        else
        {
            cell.Btn_AddRemoveWardrobe.setTitle("Remove from Huntsman Wardrobe", for: .normal)
        }
        cell.Btn_AddRemoveWardrobe.tag = 100 + indexPath.row
        cell.Btn_AddRemoveWardrobe.addTarget(self, action: #selector(Btn_AddRemove(sender:)), for: .touchUpInside)
       
        
        let HtmlconvertTitle = Product.title
        do {
            let finalstring    =  try NSAttributedString(data: HtmlconvertTitle.data(using: String.Encoding.utf8)!, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue],documentAttributes: nil)
             cell.Lbl_Title.text = finalstring.string
            
        } catch {
            print("Cannot convert html string to attributed string: \(error)")
        }
        
        let HtmlconvertDescription = Product.description
        do {
            let finalstring    =  try NSAttributedString(data: HtmlconvertDescription.data(using: String.Encoding.utf8)!, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue],documentAttributes: nil)
            cell.Lbl_Description.text = finalstring.string
            
        } catch {
            print("Cannot convert html string to attributed string: \(error)")
        }
        
        return cell
    }
    
    func tableView(_ table_view: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Product : WardrobeCateModel
        Product = All_ProductCategory[indexPath.row]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let WardrobeDetail = storyBoard.instantiateViewController(withIdentifier: "Wardrobe_Detail") as! Wardrobe_Detail
        WardrobeDetail.callupdateWardrobe = callupdateWardrobe
        WardrobeDetail.Str_ProductId = Product.product_id
        let inwardrobe = Product.in_wardrobe
        WardrobeDetail.Str_InWardrobe = String(inwardrobe)
        WardrobeDetail.Category = Product.category
        WardrobeDetail.CategoryId = Product.category_id
        present(WardrobeDetail, animated: true, completion: nil)
    }
    
    func callupdateWardrobe(_ ProductId:NSString, _ updation:NSString, _ Inwardrobe:Int)->()
    {
        if updation == "1"
        {
            if let index = self.All_ProductCategory.index(where: { $0.product_id == ProductId as String }) {
                self.All_ProductCategory[index].in_wardrobe = Inwardrobe
            }
            self.tableview.reloadData()
        }
    }
    
    @objc func Btn_AddRemove(sender: UIButton)  {
        ProductIndex = sender.tag - 100
        let Product : WardrobeCateModel
        Product = All_ProductCategory[sender.tag - 100]
        ProductId = Product.product_id
        Category = Product.category
        ProductCategoryId = Product.category_id
        let Str_InWardrobe = Product.in_wardrobe
        if Str_InWardrobe == 0
        {
            let alert = UIAlertController(title: "Huntsman", message: "Do you want to add this product to your wardrobe?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: Add_Handeler))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Huntsman", message: "Do you want to remove this product from your wardrobe?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: RemoveHandeler))
            self.present(alert, animated: true, completion: nil)
        }
    }
   
    func RemoveHandeler(alert: UIAlertAction!)
    {
        Call_AddRemoveToWardrobe(StrAction: "remove", StrProductId: ProductId as NSString, Str_Category: Category as NSString, Str_CategoryId: ProductCategoryId as NSString)
    }
    
    func Add_Handeler(alert: UIAlertAction!)
    {
        Call_AddRemoveToWardrobe(StrAction: "add", StrProductId: ProductId as NSString, Str_Category: Category as NSString, Str_CategoryId: ProductCategoryId as NSString)
    }
     /* MARK: Api  URLConstant.API.WARDROBE_ADDREMOVEPRODUCT (for add remove wardrobe api ) */
    func  Call_AddRemoveToWardrobe(StrAction:NSString,StrProductId:NSString,Str_Category:NSString,Str_CategoryId:NSString) {
        LoderGifView.MyloaderShow(view: self.view)
        let params = [
            URLConstant.Param.PRODUCTID:StrProductId,
            URLConstant.Param.CATEGORY:Str_Category,
            URLConstant.Param.CATEGORY_ID:Str_CategoryId,
            URLConstant.Param.STR_ACTION:StrAction,
            ] as [String : Any]
        
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.WARDROBE_ADDREMOVEPRODUCT,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        LoderGifView.MyloaderHide(view: self.view)
                        if StrAction == "add"
                        {
                            if let index = self.All_ProductCategory.index(where: { $0.product_id == StrProductId as String }) {
                                self.All_ProductCategory[index].in_wardrobe = 1
                            }
                        }
                        else
                        {
                            if let index = self.All_ProductCategory.index(where: { $0.product_id == StrProductId as String }) {
                                self.All_ProductCategory[index].in_wardrobe = 0
                            }
                        }
                        let indexPath = IndexPath(item: self.ProductIndex, section: 0)
                        self.tableview.reloadRows(at: [indexPath], with: .fade)
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let height:Int = Int(tableview.contentOffset.y + tableview.frame.size.height)
        let TableHeight:Int =  Int(tableview.contentSize.height)
        
        if (height >= TableHeight)
        {
            if (more == 0) {
                return;
            } else {
                if lodingApi == true
                {
                    lodingApi = false
                    pagereload = 1
                    intpage = intpage + 10
                    Str_Page = String(intpage)
                    self.Call_AllProductByCategory()
                }
            }
        } else {
            return;
        }
    }
}
