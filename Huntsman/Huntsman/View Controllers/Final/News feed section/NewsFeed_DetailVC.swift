//
//  NewsFeed_DetailVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 11/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class NewsFeed_DetailVC: UIViewController {
    
    var Feeds = [FeedsModel]()
    private let follow_bookmark_attend = Follow_Bookmark_Attend()
    @IBOutlet weak var tableview: UITableView!
    var NewsFeedId = ""
        
    var Is_Follow:Bool?
    var flag_updation = "0"
    var flag_follow = 0
    var flag_likecount = 0
    var BackNotification_Vc = ""

    var callupdatebackfeed:((_ id:NSString, _ updation:NSString, _ follow:Int, _ likecount:Int)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.estimatedRowHeight = 900
        tableview.rowHeight = UITableViewAutomaticDimension
        
        follow_bookmark_attend.delegate = self

        callFeedDetailAPI()
    }
    
    // MARK: API Calls
    func callFeedDetailAPI() {
        
        LoderGifView.MyloaderShow(view: self.view)
        
        let params = [
            URLConstant.Param.FEEDDETAIL:NewsFeedId
        ]
        
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.NEWSFEEDDETAIL,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        
                        let newfeedarray = (json.value(forKey: "feeds")  as! NSMutableArray)
                        if newfeedarray.count == 0
                        {
                            
                        }
                        else
                        {
                            self.Feeds.removeAll()
                            
                            for item in newfeedarray {
                                
                                guard let feed = FeedsModel(id:((item as AnyObject).value(forKey: "feed_id") as? String)!, title: ((item as AnyObject).value(forKey: "feed_title") as? String)!, date: ((item as AnyObject).value(forKey: "added_at") as? String)!, decs: ((item as AnyObject).value(forKey: "feed_desc") as? String)!, photo: ((item as AnyObject).value(forKey: "image") as? NSArray)!, likecount: ((item as AnyObject).value(forKey: "like_count") as? Int)!, follow: ((item as AnyObject).value(forKey: "follow") as? Int)!) else {
                                    fatalError("Unable to instantiate meal2")
                                }
                                
                                self.Feeds += [feed]
                            }
                        }
                        LoderGifView.MyloaderHide(view: self.view)
                        
                        self.tableview.reloadData()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func crossClick(sender: AnyObject?){
        if BackNotification_Vc == "PushNotifcation" {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.rootview_views(string: "discover")
        } else {
        self.dismiss(animated: true, completion: nil)
        callupdatebackfeed?(NewsFeedId as NSString, flag_updation as NSString, flag_follow,flag_likecount)
        }
    }
}

extension NewsFeed_DetailVC : UITableViewDelegate,UITableViewDataSource, Follow_Bookmark_AttendDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "newsfeed_listcell", for: indexPath) as! newsfeed_listcell
        
        let feed = Feeds[indexPath.row]
        
        
        let HtmlStringconvert = feed.title
        do {
            let finalstring    =  try NSAttributedString(data: HtmlStringconvert.data(using: String.Encoding.utf8)!, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue],documentAttributes: nil)
            cell.lblText.text = finalstring.string
            
        } catch {
            print("Cannot convert html string to attributed string: \(error)")
        }
        
        let date = Date()
       
        let stringDate: String = date.UserNewsfeedDate(str_date: feed.date)
        cell.lbldate.text = stringDate.uppercased()
        
        let HtmlStringconvertDescription = feed.decs
        do {
            let finalstring    =  try NSAttributedString(data: HtmlStringconvertDescription.data(using: String.Encoding.utf8)!, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue],documentAttributes: nil)
            cell.lbldesc.text = finalstring.string
            
        } catch {
            print("Cannot convert html string to attributed string: \(error)")
        }
        
        if feed.photo.count == 0 {
            var imageView : UIImageView
            imageView  = UIImageView(frame:CGRect(x:0, y:0, width:Int(Device.SCREEN_WIDTH - 10), height:Int(cell.view_img1.frame.size.height)))
            imageView.image = UIImage(named:"no image")
            imageView.contentMode = .scaleToFill
            imageView.clipsToBounds = true
            
            cell.scroll_view.addSubview(imageView)
        }
        else {
            
            var IntXAxis:Int = 0
            var Intheight:Int = 0
            
            for pic in feed.photo {
                
                var imageView : UIImageView
                imageView  = UIImageView(frame:CGRect(x:IntXAxis, y:0, width: Int(Device.SCREEN_WIDTH - 10), height:Int(cell.view_img1.frame.size.height)))
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleToFill
                
                imageView.sd_setImage(with: URL(string: pic as! String), placeholderImage: UIImage(named: "no image"))
                cell.scroll_view.addSubview(imageView)
                
                IntXAxis = IntXAxis + Int(Device.SCREEN_WIDTH - 10)
                Intheight =  Int(cell.view_img1.frame.size.height)
            }
            
            cell.scroll_view.contentSize = CGSize(width: IntXAxis, height: Intheight)
        }
        
        cell.lbllike.text = String(feed.likecount) + " like"
        
        // ---- follow
        if feed.follow != 0 {
            cell.Btn_like.setImage(UIImage(named: "follow filled")!, for: UIControlState.normal)
            self.flag_follow = 1
            self.Is_Follow = true
        }
        else{
            cell.Btn_like.setImage(UIImage(named: "follow")!, for: UIControlState.normal)
            self.flag_follow = 0
            self.Is_Follow = false
        }
        
        cell.Btn_like.tag = 100 + indexPath.row
        cell.Btn_like.addTarget(self, action: #selector(action_follow_unfollow), for: .touchUpInside)
        
        return cell
    }
    
    // ------- Follow unfollow section  -------- //
    @objc func action_follow_unfollow(sender: UIButton){
        
        // Fetches the appropriate trunks for the data source layout.
        let feed = Feeds[sender.tag - 100]
        
        if feed.follow == 0 {
            
            follow_bookmark_attend.call_followunfollow(type:"follow", follow_id: feed.id, follow_type: "5", API: URLConstant.API.USER_FOLLOWACTION)
            
            let likecount = feed.likecount + 1
            
            if let index = Feeds.index(where: { $0.id == feed.id }) {
                Feeds[index].follow = 1
                Feeds[index].likecount = likecount
            }
            
            self.flag_likecount = likecount
            self.flag_follow = 1
            self.Is_Follow = true
            self.flag_updation = "1"

        } else {
            
            follow_bookmark_attend.call_followunfollow(type:"unfollow", follow_id: feed.id, follow_type: "5", API: URLConstant.API.USER_UNFOLLOWACTION)
            
            let likecount = feed.likecount - 1
           
            if let index = Feeds.index(where: { $0.id == feed.id }) {
                Feeds[index].follow = 0
                Feeds[index].likecount = likecount
            }
            
            self.flag_likecount = likecount
            self.flag_updation = "1"

            self.flag_follow = 0
            self.Is_Follow = false
        }
        
        let indexPath = IndexPath(item: sender.tag - 100, section: 0)
        self.tableview.reloadRows(at: [indexPath], with: .fade)
    }
    
    func didRecieveFollowUpdate(response: String) {
    }
    func didRecieveAttendUpdate(response: String, attendtype: String) {
    }
    func didRecieveBookmarkUpdate(response: String) {
    }
    
}
