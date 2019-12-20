//
//  NewsFeed_ListVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 10/04/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class NewsFeed_ListVC: UIViewController,SWRevealViewControllerDelegate {
    
    @IBAction func btn_Menu(_ sender: Any) {
        Tf_Search.resignFirstResponder()
    }
    
    var Feeds = [FeedsModel]()
    var filteredFeeds = [FeedsModel]()

    private let follow_bookmark_attend = Follow_Bookmark_Attend()
        
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var Btn_Menu: UIButton!
    @IBOutlet weak var Btn_Count: UIButton!

    @IBOutlet weak var Tf_Search: UITextField!
    
    var Str_Page = ""
    var intpage : Int = 0
    var more : Int!
    var pagereload : Int = 0
    var lodingApi: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.revealViewController().delegate = self
        Btn_Menu.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
        
        follow_bookmark_attend.delegate = self
        
        tableview.estimatedRowHeight = 500
        tableview.rowHeight = UITableViewAutomaticDimension
        
        intpage = 0
        Str_Page = String(intpage)
        callFeedListAPI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.Btn_Count.setTitle("\(DiscoverNotificationCount.NotificationCount)", for: .normal)
    }
    // MARK: API callFeedListAPI
    func callFeedListAPI() {
        
        LoderGifView.MyloaderShow(view: self.view)
        
        let params = [
            URLConstant.Param.PAGE:Str_Page
        ]
        /*NEWSFEEDLIST for getallfeeds */
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.NEWSFEEDLIST,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let TotalFeeds = json.value(forKey: "total_feed") as? Int
                        if TotalFeeds == 0 {
                            
                            self.Feeds.removeAll()
                            self.filteredFeeds.removeAll()
                            
                            LoderGifView.MyloaderHide(view: self.view)
                            UIUtil.showMessage(title: "", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                        }
                        else
                        {
                            LoderGifView.MyloaderHide(view: self.view)
                            let newfeedarray = (json.value(forKey: "feeds")  as! NSMutableArray)
                            
                            if newfeedarray.count == 0
                            {}
                            else
                            {
                                let str_more = json.value(forKey: "more") as? String
                                self.more = Int(str_more!)!
                                if self.pagereload == 0 {
                                    
                                    self.Feeds.removeAll()
                                    
                                    for item in newfeedarray {
                                        
                                        guard let feed = FeedsModel(id:((item as AnyObject).value(forKey: "id") as? String)!, title: ((item as AnyObject).value(forKey: "feed_title") as? String)!, date: ((item as AnyObject).value(forKey: "added_at") as? String)!, decs: ((item as AnyObject).value(forKey: "feed_desc") as? String)!, photo: ((item as AnyObject).value(forKey: "image") as? NSArray)!, likecount: ((item as AnyObject).value(forKey: "like_count") as? Int)!, follow: ((item as AnyObject).value(forKey: "follow") as? Int)!) else {
                                            fatalError("Unable to instantiate meal2")
                                        }
                                        self.Feeds += [feed]
                                    }
                                }
                                else
                                {
                                    for item in newfeedarray {
                                        
                                        guard let feed = FeedsModel(id:((item as AnyObject).value(forKey: "id") as? String)!, title: ((item as AnyObject).value(forKey: "feed_title") as? String)!, date: ((item as AnyObject).value(forKey: "added_at") as? String)!, decs: ((item as AnyObject).value(forKey: "feed_desc") as? String)!, photo: ((item as AnyObject).value(forKey: "image") as? NSArray)!, likecount: ((item as AnyObject).value(forKey: "like_count") as? Int)!, follow: ((item as AnyObject).value(forKey: "follow") as? Int)!) else {
                                            fatalError("Unable to instantiate meal2")
                                        }
                                        self.Feeds += [feed]
                                    }
                                }
                                self.lodingApi = true
                                self.tableview.reloadData()
                            }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension NewsFeed_ListVC : UITableViewDelegate,UITableViewDataSource, Follow_Bookmark_AttendDelegate, UIScrollViewDelegate, UITextFieldDelegate{
    
    // MARK: -   -------Table view delegate and datasource Method ----
    func tableView(_ table_view: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filteredFeeds.count != 0 {
            return filteredFeeds.count
        }
        return Feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "newsfeed_listcell", for: indexPath) as! newsfeed_listcell
        
        // Fetches the appropriate trunks for the data source layout.
        var feed : FeedsModel
        if filteredFeeds.count != 0 {
            feed = filteredFeeds[indexPath.row]
        } else {
            feed = Feeds[indexPath.row]
        }
        
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
        
        cell.lbldesc.text = feed.decs
        
        if feed.photo.count == 0 {
            
            cell.view_img1.isHidden = false
            cell.view_img2.isHidden = true
            cell.view_img3.isHidden = true
            cell.ImageView11.image = UIImage(named:"no image")
        }
        else  if feed.photo.count == 1 {
            
            cell.view_img1.isHidden = false
            cell.view_img2.isHidden = true
            cell.view_img3.isHidden = true
            cell.ImageView11.sd_setImage(with: URL(string: feed.photo[0] as! String), placeholderImage: UIImage(named: "no image"))
            
        } else  if feed.photo.count == 2 {
            
            cell.view_img1.isHidden = true
            cell.view_img2.isHidden = false
            cell.view_img3.isHidden = true
            cell.ImageView21.sd_setImage(with: URL(string: feed.photo[0] as! String), placeholderImage: UIImage(named: "no image"))
            cell.ImageView22.sd_setImage(with: URL(string: feed.photo[1] as! String), placeholderImage: UIImage(named: "no image"))

        } else  if feed.photo.count == 3 {
            
            cell.view_img1.isHidden = true
            cell.view_img2.isHidden = true
            cell.view_img3.isHidden = false
            cell.ImageView31.sd_setImage(with: URL(string: feed.photo[0] as! String), placeholderImage: UIImage(named: "no image"))
            cell.ImageView32.sd_setImage(with: URL(string: feed.photo[1] as! String), placeholderImage: UIImage(named: "no image"))
            cell.ImageView33.sd_setImage(with: URL(string: feed.photo[2] as! String), placeholderImage: UIImage(named: "no image"))
        } else
        {
            cell.view_img1.isHidden = true
            cell.view_img2.isHidden = true
            cell.view_img3.isHidden = false
            cell.ImageView31.sd_setImage(with: URL(string: feed.photo[0] as! String), placeholderImage: UIImage(named: "no image"))
            cell.ImageView32.sd_setImage(with: URL(string: feed.photo[1] as! String), placeholderImage: UIImage(named: "no image"))
            cell.ImageView33.sd_setImage(with: URL(string: feed.photo[2] as! String), placeholderImage: UIImage(named: "no image"))
        }
        
        cell.lbllike.text = String(feed.likecount) + " like"
        
        // ---- follow
        if feed.follow != 0 {
            cell.Btn_like.setImage(UIImage(named: "follow filled")!, for: UIControlState.normal)
        }
        else{
            cell.Btn_like.setImage(UIImage(named: "follow")!, for: UIControlState.normal)
        }
        cell.Btn_like.tag = 100 + indexPath.row
        cell.Btn_like.addTarget(self, action: #selector(action_follow_unfollow), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ table_view: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Fetches the appropriate trunks for the data source layout.
        var feed : FeedsModel
        if filteredFeeds.count != 0 {
            feed = filteredFeeds[indexPath.row]
        } else {
            feed = Feeds[indexPath.row]
        }

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "NewsFeed_DetailVC") as! NewsFeed_DetailVC
        profile.NewsFeedId = feed.id
        profile.callupdatebackfeed = callupdatebackfeed
        present(profile, animated: true, completion: nil)
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
                    callFeedListAPI()
                }
            }
        } else {
            return;
        }
    }
    
    // ------- Follow unfollow section  -------- //
    @objc func action_follow_unfollow(sender: UIButton){
        
        // Fetches the appropriate trunks for the data source layout.
        var feed : FeedsModel
        if filteredFeeds.count != 0 {
            feed = filteredFeeds[sender.tag - 100]
        } else {
            feed = Feeds[sender.tag - 100]
        }

        if feed.follow == 0 {
            follow_bookmark_attend.call_followunfollow(type:"follow", follow_id: feed.id, follow_type: "5", API: URLConstant.API.USER_FOLLOWACTION)

            let likecount = feed.likecount + 1

            if filteredFeeds.count != 0 {
                if let index = Feeds.index(where: { $0.id == feed.id }) {
                    Feeds[index].follow = 1
                    Feeds[index].likecount = likecount
                }
                if let index = filteredFeeds.index(where: { $0.id == feed.id }) {
                    filteredFeeds[index].follow = 1
                    filteredFeeds[index].likecount = likecount
                }
            }else
            {
                if let index = Feeds.index(where: { $0.id == feed.id }) {
                    Feeds[index].follow = 1
                    Feeds[index].likecount = likecount
                }
            }
        } else {
            
           follow_bookmark_attend.call_followunfollow(type:"unfollow", follow_id: feed.id, follow_type: "5", API: URLConstant.API.USER_UNFOLLOWACTION)

            let likecount = feed.likecount - 1

            if filteredFeeds.count != 0 {
                if let index = Feeds.index(where: { $0.id == feed.id }) {
                    Feeds[index].follow = 0
                    Feeds[index].likecount = likecount
                }
                if let index = filteredFeeds.index(where: { $0.id == feed.id }) {
                    filteredFeeds[index].follow = 0
                    filteredFeeds[index].likecount = likecount
                }
            }else{
                if let index = Feeds.index(where: { $0.id == feed.id }) {
                    Feeds[index].follow = 0
                    Feeds[index].likecount = likecount
                }
            }

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
    
    func callupdatebackfeed(_ id:NSString, _ updation:NSString, _ follow:Int, _ likecount:Int)->()
    {
        if updation == "1"
        {
            // Fetches the appropriate trunks for the data source layout.
            if filteredFeeds.count != 0 {
                if let index = Feeds.index(where: { $0.id == id as String }) {
                    Feeds[index].follow = follow
                    Feeds[index].likecount = likecount
                }
                if let index = filteredFeeds.index(where: { $0.id == id as String }) {
                    filteredFeeds[index].follow = follow
                    filteredFeeds[index].likecount = likecount
                    
                    let indexPath = IndexPath(item: index, section: 0)
                    self.tableview.reloadRows(at: [indexPath], with: .fade)
                }
                
            }else{
                if let index = Feeds.index(where: { $0.id == id as String }) {
                    Feeds[index].follow = follow
                    Feeds[index].likecount = likecount
                    
                    let indexPath = IndexPath(item: index, section: 0)
                    self.tableview.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    
    // Trunk list filter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{

        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        print(txtAfterUpdate)

        if string == " " {
        } else if string == "" {
            getSearchArrayContains(txtAfterUpdate)
        } else {
            getSearchArrayContains(txtAfterUpdate)
        }
        return true
    }

    func getSearchArrayContains(_ text : String) {
        
        if Feeds.count == 0 {
            
        } else {
            filteredFeeds = Feeds.filter {
                return $0.title.range(of: text, options: .caseInsensitive) != nil
            }
            tableview.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            tableview.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    @IBAction func Action_notification(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "Notification_VC") as! Notification_VC
        present(profile, animated: true, completion: nil)
    }
}

