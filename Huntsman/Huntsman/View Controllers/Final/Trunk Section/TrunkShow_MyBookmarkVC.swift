
//
//  TrunkShow_MyBookmarkVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 30/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import XLPagerTabStrip

// TrunkShow_MyBookmark_Delegate loder hide show  on view
protocol TrunkShow_MyBookmark_Delegate:class {
    func TrunkshowBookmark_LoderHide()
    func TrunkshowBookmark_LoderShow()
}

class TrunkShow_MyBookmarkVC: UIViewController ,IndicatorInfoProvider {
    
    var Trunks = [TrunkModel]()
    var filteredTrunks = [TrunkModel]()
    
    var delegate:TrunkShow_MyBookmark_Delegate?
    private let follow_bookmark_attend = Follow_Bookmark_Attend()
    
    var Str_Page = ""
    var intpage : Int = 0
    var more : Int!
    var pagereload : Int = 0
    
    var lodingApi: Bool!
    var ApiCall = ""
    var currentdate = ""
    var formatter = DateFormatter()

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet  weak var Tf_Search: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        follow_bookmark_attend.delegate = self
        ApiCall = "YES"
        let date = Date()
        formatter.dateFormat = "dd-MM-yyyy"
        currentdate = formatter.string(from: date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        if ApiCall == "YES"
        {
          
            self.lodingApi = true
            self.intpage = 0
            self.pagereload = 0
            self.Str_Page = String(self.intpage)
            self.callLoginAPI()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        ApiCall = "YES"
    }
    
    // MARK: API Calls
    func callLoginAPI() {
        
        self.delegate?.TrunkshowBookmark_LoderShow()
        let params = [
            URLConstant.Param.PAGE:Str_Page,
            URLConstant.Param.BOOKMARK:"1",
            URLConstant.Param.TYPE :"",
            URLConstant.Param.MONTH :"",
            URLConstant.Param.YEAR :"",
            URLConstant.Param.FILTERDATE :""
        ]
        
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.TRUNKSHOW_GETAPPTRUNK,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary
            {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let TotalTrunk = json.value(forKey: "total_trunk") as? Int
                        if TotalTrunk == 0 {
                            
                            self.Trunks.removeAll()
                            self.filteredTrunks.removeAll()
                            self.tableview.reloadData()
                            self.delegate?.TrunkshowBookmark_LoderHide()
                            let alert = CustomAlert (title:"",Message:(json.value(forKey: "message") as? String)!)
                            alert.show(animated: true)

                        }
                        else
                        {
                            let str_more = json.value(forKey: "more") as? String
                            self.more = Int(str_more!)!
                            
                            let Trunk_Array = (json.value(forKey: "trunks")  as! NSMutableArray)
                            
                            if self.pagereload == 0 {
                                
                                self.Trunks.removeAll()
                                
                                for item in Trunk_Array {
                                    
                                    guard let trunk = TrunkModel(id:((item as AnyObject).value(forKey: "id") as? String)!, photo: ((item as AnyObject).value(forKey: "image") as? String)!, date: ((item as AnyObject).value(forKey: "trunk_date") as? String)!,Enddate: ((item as AnyObject).value(forKey: "trunk_end_date") as? String)!, title: ((item as AnyObject).value(forKey: "trunk_title") as? String)!, desc: ((item as AnyObject).value(forKey: "trunk_desc") as? String)!, follow: ((item as AnyObject).value(forKey: "follow") as? Int)!, attend: ((item as AnyObject).value(forKey: "attend") as? Int)!, bookmark: ((item as AnyObject).value(forKey: "bookmark") as? Int)!) else {
                                        fatalError("Unable to instantiate meal2")
                                    }
                                    self.Trunks += [trunk]
                                }
                            }
                            else
                            {
                                for item in Trunk_Array {
                                    
                                    guard let trunk = TrunkModel(id:((item as AnyObject).value(forKey: "id") as? String)!, photo: ((item as AnyObject).value(forKey: "image") as? String)!, date: ((item as AnyObject).value(forKey: "trunk_date") as? String)!,Enddate: ((item as AnyObject).value(forKey: "trunk_end_date") as? String)!, title: ((item as AnyObject).value(forKey: "trunk_title") as? String)!, desc: ((item as AnyObject).value(forKey: "trunk_desc") as? String)!, follow: ((item as AnyObject).value(forKey: "follow") as? Int)!, attend: ((item as AnyObject).value(forKey: "attend") as? Int)!, bookmark: ((item as AnyObject).value(forKey: "bookmark") as? Int)!) else {
                                        fatalError("Unable to instantiate meal2")
                                    }
                                    
                                    self.Trunks += [trunk]
                                }
                            }
                            self.lodingApi = true
                            self.tableview.reloadData()
                            self.delegate?.TrunkshowBookmark_LoderHide()
                        }
                    }
                    else {
                        self.delegate?.TrunkshowBookmark_LoderHide()

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
            self.delegate?.TrunkshowBookmark_LoderHide()
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

extension TrunkShow_MyBookmarkVC:UITableViewDataSource, UITableViewDelegate, Follow_Bookmark_AttendDelegate, UIScrollViewDelegate, UITextFieldDelegate{
    
    // MARK: -   -------Table view delegate and datasource Method ----
    func tableView(_ table_view: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filteredTrunks.count != 0 {
            return filteredTrunks.count
        }
        return Trunks.count
    }
    
    func tableView(_ table_view: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table_view.dequeueReusableCell(withIdentifier: "TrunkList_Cell", for: indexPath) as! TrunkList_Cell
        
        // Fetches the appropriate trunks for the data source layout.
        var trunk : TrunkModel
        if filteredTrunks.count != 0 {
            trunk = filteredTrunks[indexPath.row]
        } else {
            trunk = Trunks[indexPath.row]
        }
        
        cell.img_trunk.sd_setImage(with: URL(string: trunk.photo), placeholderImage: UIImage(named: "no image"))
        
        let date = Date()
        let stringDate: String = date.userddMMMyyyyDate(str_date: trunk.date)
        cell.Lbl_Date.text = stringDate
        
        cell.Lbl_TrunkTitle.text = trunk.title
        
        cell.Lbl_TrunkDescrip.text = trunk.desc
        
        // ---- follow
        if trunk.follow != 0 {
            cell.Btn_like .setImage(UIImage(named: "follow filled")!, for: UIControlState.normal)
        }
        else{
            cell.Btn_like .setImage(UIImage(named: "follow")!, for: UIControlState.normal)
        }
        cell.Btn_like.tag = 100 + indexPath.row
        cell.Btn_like.addTarget(self, action: #selector(action_follow_unfollow), for: .touchUpInside)
        
        
        // ---- trunk
        
        if trunk.attend != 0 {
            cell.Btn_Attendent .setImage(UIImage(named: "attend  filled")!, for: UIControlState.normal)
        }
        else {
            cell.Btn_Attendent .setImage(UIImage(named: "attend")!, for: UIControlState.normal)
        }
        
        let StrEnddate: String = date.UserEventEnddate(str_date: trunk.End_date)
        
        if Calendar.current.compare(formatter.date(from:StrEnddate )!, to: formatter.date(from:currentdate )!, toGranularity: .day) == .orderedSame || Calendar.current.compare(formatter.date(from:currentdate )!, to: formatter.date(from:StrEnddate )!, toGranularity: .day) ==   .orderedAscending{
            cell.Btn_Attendent.isHidden = false
            cell.BookmarkLeading.constant = 48
        }
        else
        {
            cell.BookmarkLeading.constant = 10
            cell.Btn_Attendent.isHidden = true
        }
        
        cell.Btn_Attendent.tag = 300 + indexPath.row
        cell.Btn_Attendent.addTarget(self, action: #selector(action_attend_unattend), for: .touchUpInside)
        
        // ---- bookmark
        if trunk.bookmark != 0{
            cell.Btn_BookMark .setImage(UIImage(named: "bookmark filled")!, for: UIControlState.normal)
        }
        else {
            cell.Btn_BookMark .setImage(UIImage(named: "Bookmark")!, for: UIControlState.normal)
        }
        cell.Btn_BookMark.tag = 500  + indexPath.row
        cell.Btn_BookMark.addTarget(self, action: #selector(action_bookmark_unbookmark), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ table_view: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ApiCall = "NO"
        
        // Fetches the appropriate trunks for the data source layout.
        var trunk : TrunkModel
        if filteredTrunks.count != 0 {
            trunk = filteredTrunks[indexPath.row]
        } else {
            trunk = Trunks[indexPath.row]
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "Trunk_DetailVC") as! Trunk_DetailVC
        profile.TrunkId = trunk.id
        profile.CallBack_ForViewdisapper = CallBack_ForViewdisapper
        profile.callupdateback = callupdateback
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
                    self.callLoginAPI()
                }
            }
        } else {
            return;
        }
    }
    
    // ------- Follow unfollow section  -------- //
    @objc func action_follow_unfollow(sender: UIButton){
        
        // Fetches the appropriate trunks for the data source layout.
        var trunk : TrunkModel
        if filteredTrunks.count != 0 {
            trunk = filteredTrunks[sender.tag - 100]
        } else {
            trunk = Trunks[sender.tag - 100]
        }
        
        if trunk.follow == 0 {
            follow_bookmark_attend.call_followunfollow(type:"follow", follow_id: trunk.id, follow_type: "2", API: URLConstant.API.USER_FOLLOWACTION)
            
            if filteredTrunks.count != 0 {
                if let index = Trunks.index(where: { $0.id == trunk.id }) {
                    Trunks[index].follow = 1
                }
                if let index = filteredTrunks.index(where: { $0.id == trunk.id }) {
                    filteredTrunks[index].follow = 1
                }
            }else
            {
                if let index = Trunks.index(where: { $0.id == trunk.id }) {
                    Trunks[index].follow = 1
                }
            }
        } else {
            follow_bookmark_attend.call_followunfollow(type:"unfollow", follow_id: trunk.id, follow_type: "2", API: URLConstant.API.USER_UNFOLLOWACTION)
            
            if filteredTrunks.count != 0 {
                if let index = Trunks.index(where: { $0.id == trunk.id }) {
                    Trunks[index].follow = 0
                }
                if let index = filteredTrunks.index(where: { $0.id == trunk.id }) {
                    filteredTrunks[index].follow = 0
                }
            }else{
                if let index = Trunks.index(where: { $0.id == trunk.id }) {
                    Trunks[index].follow = 0
                }
            }
            
        }
        
        let indexPath = IndexPath(item: sender.tag - 100, section: 0)
        self.tableview.reloadRows(at: [indexPath], with: .fade)
    }
    
    func didRecieveFollowUpdate(response: String) {
    }
    
    // ------- Attend section  -------- //
    @objc func action_attend_unattend(sender: UIButton){
        
        // Fetches the appropriate trunks for the data source layout.
        var trunk : TrunkModel
        if filteredTrunks.count != 0 {
            trunk = filteredTrunks[sender.tag - 300]
        } else {
            trunk = Trunks[sender.tag - 300]
        }
        
        if trunk.attend == 0 {
            
            follow_bookmark_attend.call_attendunattend(type: "attend", attend_id: trunk.id, attend_type: "2", API: URLConstant.API.USER_ATTENDACTION)
            
            if filteredTrunks.count != 0 {
                if let index = Trunks.index(where: { $0.id == trunk.id }) {
                    Trunks[index].attend = 1
                }
                if let index = filteredTrunks.index(where: { $0.id == trunk.id }) {
                    filteredTrunks[index].attend = 1
                }
            }else{
                if let index = Trunks.index(where: { $0.id == trunk.id }) {
                    Trunks[index].attend = 1
                }
            }
            let messageTitle = "You are attending " + trunk.title + "."
            
//            UIUtil.showMessage(title: "Huntsman", message:messageTitle , controller: self, okHandler: nil)

            let alert = CustomAlert (title:"Huntsman",Message:messageTitle)
            alert.show(animated: true)

            let indexPath = IndexPath(item: sender.tag - 300, section: 0)
            self.tableview.reloadRows(at: [indexPath], with: .fade)

        } else {
            
            let messageTitle = "Are you sure you want to unattend  " + trunk.title + "?"
            let alert = UIAlertController(title: "Huntsman", message: messageTitle, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: handleConfirmUnattend(TrunkId:trunk.id  as NSString, TagIndex:sender.tag - 300 )
            ))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleConfirmUnattend(TrunkId:NSString ,TagIndex:Int) -> (_ alertAction:UIAlertAction) -> () {
        return { alertAction in
            
            self.follow_bookmark_attend.call_attendunattend(type: "unattend", attend_id: TrunkId as String, attend_type: "2", API: URLConstant.API.USER_UNATTENDACTION)
            
            if self.filteredTrunks.count != 0 {
                if let index = self.Trunks.index(where: { $0.id ==  TrunkId as String }) {
                    self.Trunks[index].attend = 0
                }
                if let index = self.filteredTrunks.index(where: { $0.id ==  TrunkId as String }) {
                    self.filteredTrunks[index].attend = 0
                }
            }else{
                if let index = self.Trunks.index(where: { $0.id ==  TrunkId as String }) {
                   self.Trunks[index].attend = 0
                }
            }
            let indexPath = IndexPath(item: TagIndex, section: 0)
            self.tableview.reloadRows(at: [indexPath], with: .fade)
        }
    }

    
    func didRecieveAttendUpdate(response: String, attendtype: String) {
    }
    
    // ------- Bookmark section  -------- //
    @objc func action_bookmark_unbookmark(sender: UIButton){
        
        // Fetches the appropriate trunks for the data source layout.
        var trunk : TrunkModel
        if filteredTrunks.count != 0 {
            trunk = filteredTrunks[sender.tag - 500]
        } else {
            trunk = Trunks[sender.tag - 500]
        }
        
        if trunk.bookmark == 0 {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "bookmark", bookmark_id: trunk.id, bookmark_type: "2", API: URLConstant.API.USER_BOOKMARKACTION)
            
            if filteredTrunks.count != 0 {
                if let index = Trunks.index(where: { $0.id == trunk.id }) {
                    Trunks[index].bookmark = 1
                }
                if let index = filteredTrunks.index(where: { $0.id == trunk.id }) {
                    filteredTrunks[index].bookmark = 1
                }
            }else{
                if let index = Trunks.index(where: { $0.id == trunk.id }) {
                    Trunks[index].bookmark = 1
                }
            }
            
        } else {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "unbookmark", bookmark_id: trunk.id, bookmark_type: "2", API: URLConstant.API.USER_UNBOOKMARKACTION)
            
            if filteredTrunks.count != 0 {
                if let index = Trunks.index(where: { $0.id == trunk.id }) {
                    Trunks.remove(at: index)
                }
                if let index = filteredTrunks.index(where: { $0.id == trunk.id }) {
                    filteredTrunks.remove(at: index)
                }
            }else{
                if let index = Trunks.index(where: { $0.id == trunk.id }) {
                    Trunks.remove(at: index)
                }
            }
            tableview.reloadData()
        }
    
    }
    
    func didRecieveBookmarkUpdate(response: String) {
    }
    
    func callupdateback(_ id:NSString, _ updation:NSString, _ follow:Int, _ attend:Int, _ bookmark:Int)->()
    {
        if updation == "1"
        {
            // Fetches the appropriate trunks for the data source layout.
            if filteredTrunks.count != 0 {
                
                if bookmark == 0{
                    if let index = Trunks.index(where: { $0.id == id as String }) {
                        Trunks.remove(at: index)
                    }
                    if let index = filteredTrunks.index(where: { $0.id == id as String }) {
                        filteredTrunks.remove(at: index)
                    }
                    tableview.reloadData()
                }
                else{
                    if let index = Trunks.index(where: { $0.id == id as String }) {
                        Trunks[index].follow = follow
                        Trunks[index].attend = attend
                        Trunks[index].bookmark = bookmark
                    }
                    if let index = filteredTrunks.index(where: { $0.id == id as String }) {
                        filteredTrunks[index].follow = follow
                        filteredTrunks[index].attend = attend
                        filteredTrunks[index].bookmark = bookmark
                        
                        let indexPath = IndexPath(item: index, section: 0)
                        self.tableview.reloadRows(at: [indexPath], with: .fade)
                    }
                }
                
            }else{
                if bookmark == 0{
                    if let index = Trunks.index(where: { $0.id == id as String }) {
                        Trunks.remove(at: index)
                    }
                    tableview.reloadData()
                }
                else{
                    if let index = Trunks.index(where: { $0.id == id as String }) {
                        Trunks[index].follow = follow
                        Trunks[index].attend = attend
                        Trunks[index].bookmark = bookmark
                        
                        let indexPath = IndexPath(item: index, section: 0)
                        self.tableview.reloadRows(at: [indexPath], with: .fade)
                    }
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
        
        if Trunks.count == 0 {
        } else {
            filteredTrunks = Trunks.filter {
                return $0.title.range(of: text, options: .caseInsensitive) != nil
            }
            tableview.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            tableview.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}
