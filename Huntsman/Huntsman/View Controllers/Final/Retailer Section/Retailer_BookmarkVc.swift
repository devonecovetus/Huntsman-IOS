//
//  Retailer_BookmarkVc.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 18/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol Retailer_BookmarkDelegate: class {
    func Retailer_BookmarkLoaderHide()
    func Retailer_BookmarkLoaderShow()
}

class Retailer_BookmarkVc: UIViewController ,IndicatorInfoProvider {
    
    // RetailerModel json value key and value
    var Retailers = [RetailerModel]()
    var delegate:Retailer_BookmarkDelegate?
    private let follow_bookmark_attend = Follow_Bookmark_Attend()

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var Tf_Search: UITextField!
    
    var Str_Page = ""
    var intpage : Int = 0
    var more : Int!
    var pagereload : Int = 0
    var ApiCall = ""
    var lodingApi: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ApiCall = "YES"
        follow_bookmark_attend.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        if ApiCall == "YES"
        {
            lodingApi = true
            intpage = 0
            pagereload = 0
            Str_Page = String(intpage)
            callList_GETALLRETAILERSAPI()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        ApiCall = "YES"
    }
    
    // MARK: API Calls
    func callList_GETALLRETAILERSAPI() {
        
        self.delegate?.Retailer_BookmarkLoaderShow()
        let params = [
            URLConstant.Param.PAGE:Str_Page,
            URLConstant.Param.BOOKMARK:"1",
            URLConstant.Param.NAME:Tf_Search.text!
        ]
      /*URLConstant.API.RETAILER_GETALLRETAILER class in api name and params..(for get bookmark list)*/
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.RETAILER_GETALLRETAILER,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let totaluser = json.value(forKey: "total_retailer") as? Int
                        
                        if totaluser == 0 {
                            self.Retailers.removeAll()
                            self.tableview.reloadData()
                            self.delegate?.Retailer_BookmarkLoaderHide()
                            let alert = CustomAlert (title:"",Message:(json.value(forKey: "message") as? String)!)
                            alert.show(animated: true)
                        }
                        else
                        {
                            let str_more = json.value(forKey: "more") as? String
                            self.more = Int(str_more!)!
                            let Retailers_Array = (json.value(forKey: "retailers")  as! NSMutableArray)
                            
                            if self.pagereload == 0 {
                                self.Retailers.removeAll()
                                for item in Retailers_Array {
                                    
                                    guard let retailer = RetailerModel(id:((item as AnyObject).value(forKey: "id") as? String)!, photo: ((item as AnyObject).value(forKey: "image") as? String)!, city: ((item as AnyObject).value(forKey: "city") as? String)!, distance: ((item as AnyObject).value(forKey: "distance") as? String)!, name: ((item as AnyObject).value(forKey: "name") as? String)!, desc: ((item as AnyObject).value(forKey: "about") as? String)!, bookmark: ((item as AnyObject).value(forKey: "bookmark") as? Int)!) else {
                                        fatalError("Unable to instantiate meal2")
                                    }
                                    self.Retailers += [retailer]
                                }
                            }
                            else
                            {
                                for item in Retailers_Array {
                                    
                                    guard let retailer = RetailerModel(id:((item as AnyObject).value(forKey: "id") as? String)!, photo: ((item as AnyObject).value(forKey: "image") as? String)!, city: ((item as AnyObject).value(forKey: "city") as? String)!, distance: ((item as AnyObject).value(forKey: "distance") as? String)!, name: ((item as AnyObject).value(forKey: "name") as? String)!, desc: ((item as AnyObject).value(forKey: "about") as? String)!, bookmark: ((item as AnyObject).value(forKey: "bookmark") as? Int)!) else {
                                        fatalError("Unable to instantiate meal2")
                                    }
                                    
                                    self.Retailers += [retailer]
                                }
                            }
                            
                            self.lodingApi = true
                            self.tableview.reloadData()
                        }
                        self.delegate?.Retailer_BookmarkLoaderHide()
                    }
                    else {
                        self.delegate?.Retailer_BookmarkLoaderHide()
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
           self.delegate?.Retailer_BookmarkLoaderHide()
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
    
    func  CallBack_ForViewdisapper()->()
    {
        ApiCall = "NO"
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "        Bookmarks ",image:UIImage(named: "MyBookmark")!, highlightedImage:UIImage(named: "MyBookmark"))
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        Tf_Search.text = ""
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
}

extension Retailer_BookmarkVc:UITableViewDataSource, UITableViewDelegate, Follow_Bookmark_AttendDelegate, UIScrollViewDelegate, UITextFieldDelegate{
    
    // MARK: -   -------Table view delegate and datasource Method ----
    func tableView(_ table_view: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Retailers.count
    }
    
    func tableView(_ table_view: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table_view.dequeueReusableCell(withIdentifier: "Retailer_Cell", for: indexPath) as! Retailer_Cell
        // Fetches the appropriate trunks for the data source layout.
        let retailer = Retailers[indexPath.row]
       
        if retailer.photo == ""{
            cell.Img_ProfilePic.sd_setImage(with: URL(string:""), placeholderImage: UIImage(named: "no image"))
        }
        else
        {
            cell.Img_ProfilePic.sd_setImage(with: URL(string: retailer.photo), placeholderImage: UIImage(named: "no image"))
        }
        
        cell.Lbl_city.text = retailer.city + ", " + retailer.distance
        
        cell.Lbl_name.text = retailer.name
        
        cell.Lbl_aboutuser.text = retailer.desc

        return cell
        
    }
    
    func tableView(_ table_view: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        ApiCall = "NO"
        
        // Fetches the appropriate trunks for the data source layout.
        let retailer = Retailers[indexPath.row]

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let RetailerDetail = storyBoard.instantiateViewController(withIdentifier: "Retailer_DetailVC") as! Retailer_DetailVC
        RetailerDetail.RetailerId = retailer.id
        RetailerDetail.callupdateRetailerDetail = callupdateRetailerDetail
        RetailerDetail.CallBack_ForViewdisapper = CallBack_ForViewdisapper
        present(RetailerDetail, animated: true, completion: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
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
                    callList_GETALLRETAILERSAPI()
                }
            }
        } else {
            return;
        }
    }
    
    
    func didRecieveBookmarkUpdate(response: String) {
    }
    func didRecieveFollowUpdate(response: String) {
    }
    func didRecieveAttendUpdate(response: String, attendtype: String) {
    }
    
    func callupdateRetailerDetail(_ id:NSString, _ updation:NSString, _ bookmark:Int)->()
    {
        if updation == "1"
        {
            if bookmark == 0{
                if let index = Retailers.index(where: { $0.id == id as String }) {
                    Retailers.remove(at: index)
                }
                tableview.reloadData()
            }
            else{
                if let index = Retailers.index(where: { $0.id == id as String }) {
                    Retailers[index].bookmark = bookmark
                    let indexPath = IndexPath(item: index, section: 0)
                    self.tableview.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    // Trunk list filter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == UIReturnKeyType.go{
            self.delegate?.Retailer_BookmarkLoaderHide()
            lodingApi = true
            intpage = 0
            pagereload = 0
            Str_Page = String(intpage)
            callList_GETALLRETAILERSAPI()
        }
        return textField.resignFirstResponder()
    }

}
