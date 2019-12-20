
//
//  Trunk_tablecell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 20/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
// Trunk_TableCell_DiscoverDelegate attentd event 
protocol Trunk_TableCell_DiscoverDelegate {
    
    func Trunk_DiscoverEvents(trunk_id:String)
    func Trunk_DiscoverUnattendAlert(TrunkTitle:String, type:String, TrunkId:String, TagIndex:Int)
}

class Trunk_tablecell: UITableViewCell {
    
    var Trunks = [TrunkModel]()
    var Is_UnattendExist:Bool?

    private let follow_bookmark_attend = Follow_Bookmark_Attend()
    var delegate:Trunk_TableCell_DiscoverDelegate?
    
    @IBOutlet weak var collectiontrunk: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        follow_bookmark_attend.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(Trunk_tablecell.TrunkHandlerUnattend), name: NSNotification.Name(rawValue: "TrunkUnattentNotification"), object: nil)
    }
}

extension Trunk_tablecell : UICollectionViewDataSource ,UICollectionViewDelegate, Follow_Bookmark_AttendDelegate{
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Trunks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Trunk_collectioncell", for: indexPath) as! Trunk_collectioncell
                
        let trunk = Trunks[indexPath.row]
       
        cell.img_trunk.sd_setImage(with: URL(string: trunk.photo), placeholderImage: UIImage(named: "no image"))
        cell.Lbl_TrunkTitle.text = trunk.title
        cell.Lbl_TrunkDescrip.text = trunk.desc

        let string = trunk.date

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if dateFormatter.date(from: string) != nil {
            let date = dateFormatter.date(from: string)
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let dateString = dateFormatter.string(from: date!)
            let array = dateString.components(separatedBy: "-")
            cell.Lbl_Year.text = array [2]
            cell.Lbl_Date.text = array [0]
            cell.Lbl_Month.text = array [1]
            
        } else {
            cell.Lbl_Year.text = ""
            cell.Lbl_Date.text = ""
            cell.Lbl_Month.text = ""
        }
        
        // ---- follow
        if trunk.follow != 0 {
            cell.Btn_like .setImage(UIImage(named: "follow filled")!, for: UIControlState.normal)
        } else{
            cell.Btn_like .setImage(UIImage(named: "follow")!, for: UIControlState.normal)
        }
        cell.Btn_like.tag = 100 + indexPath.row
        cell.Btn_like.addTarget(self, action: #selector(action_follow_unfollow), for: .touchUpInside)
        
        // ---- trunk
        if trunk.attend != 0 {
            cell.Btn_Attendent .setImage(UIImage(named: "attend  filled")!, for: UIControlState.normal)
        } else {
            cell.Btn_Attendent .setImage(UIImage(named: "attend")!, for: UIControlState.normal)
        }
        cell.Btn_Attendent.tag = 300 + indexPath.row
        cell.Btn_Attendent.addTarget(self, action: #selector(action_attend_unattend), for: .touchUpInside)
        
        // ---- bookmark
        if trunk.bookmark != 0{
            cell.Btn_BookMark .setImage(UIImage(named: "bookmark filled")!, for: UIControlState.normal)
        }  else {
            cell.Btn_BookMark .setImage(UIImage(named: "Bookmark")!, for: UIControlState.normal)
        }
        cell.Btn_BookMark.tag = 500  + indexPath.row
        cell.Btn_BookMark.addTarget(self, action: #selector(action_bookmark_unbookmark), for: .touchUpInside)
     
        return cell
    }
    
    // ------- Follow unfollow section  -------- //
    @objc func action_follow_unfollow(sender: UIButton){
        
        // Fetches the appropriate trunks for the data source layout.
        let trunk = Trunks[sender.tag - 100]
       
        if trunk.follow == 0 {
            follow_bookmark_attend.call_followunfollow(type:"follow", follow_id: trunk.id, follow_type: "2", API: URLConstant.API.USER_FOLLOWACTION)
            
            if let index = Trunks.index(where: { $0.id == trunk.id }) {
                Trunks[index].follow = 1
            }
            
        } else {
            follow_bookmark_attend.call_followunfollow(type:"unfollow", follow_id: trunk.id, follow_type: "2", API: URLConstant.API.USER_UNFOLLOWACTION)
            
            if let index = Trunks.index(where: { $0.id == trunk.id }) {
                Trunks[index].follow = 0
            }
        }
        let indexPath = IndexPath(item: sender.tag - 100, section: 0)
        self.collectiontrunk.reloadItems(at: [indexPath])
    }
    
    func didRecieveFollowUpdate(response: String) {
    }
    
    // ------- Attend section  -------- //
    @objc func action_attend_unattend(sender: UIButton){
        
        // Fetches the appropriate trunks for the data source layout.
        let  trunk = Trunks[sender.tag - 300]
      
        if trunk.attend == 0 {
            
            let messageTitle = "You are attending " + trunk.title + "."
            let alert = CustomAlert (title:"Huntsman",Message:messageTitle)
            alert.show(animated: true)

            follow_bookmark_attend.call_attendunattend(type: "attend", attend_id: trunk.id, attend_type: "2", API: URLConstant.API.USER_ATTENDACTION)
            
            if let index = Trunks.index(where: { $0.id == trunk.id }) {
                Trunks[index].attend = 1
            }
            let indexPath = IndexPath(item: sender.tag - 300, section: 0)
            self.collectiontrunk.reloadItems(at: [indexPath])
        } else {
            delegate?.Trunk_DiscoverUnattendAlert(TrunkTitle:trunk.title, type: "AlertShowUnattend", TrunkId: trunk.id , TagIndex: sender.tag - 300 )
            Is_UnattendExist = true
        }
    }
  
    @objc func TrunkHandlerUnattend(notification: NSNotification)  {
        if Is_UnattendExist == true {
            print(notification)
            Is_UnattendExist = false
            let myDict = notification.object as? [String: Any]
            let Str_Index = myDict!["Tag_Index"]
            follow_bookmark_attend.call_attendunattend(type: "unattend", attend_id: (myDict! ["TrunkId"] as? String)!, attend_type: "2", API: URLConstant.API.USER_UNATTENDACTION)
            
            if let index = Trunks.index(where: { $0.id == (myDict! ["TrunkId"] as? String)! }) {
                Trunks[index].attend = 0
            }
            let indexPath = IndexPath(item: Str_Index as! Int, section: 0)
            self.collectiontrunk.reloadItems(at: [indexPath])
        }
    }
    
    func didRecieveAttendUpdate(response: String, attendtype: String) {
    }

    // ------- Bookmark section  -------- //
    @objc func action_bookmark_unbookmark(sender: UIButton){
        
        // Fetches the appropriate trunks for the data source layout.
        let trunk = Trunks[sender.tag - 500]
      
        if trunk.bookmark == 0 {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "bookmark", bookmark_id: trunk.id, bookmark_type: "2", API: URLConstant.API.USER_BOOKMARKACTION)
            
            if let index = Trunks.index(where: { $0.id == trunk.id }) {
                Trunks[index].bookmark = 1
            }
            
        } else {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "unbookmark", bookmark_id: trunk.id, bookmark_type: "2", API: URLConstant.API.USER_UNBOOKMARKACTION)
            
            if let index = Trunks.index(where: { $0.id == trunk.id }) {
                Trunks[index].bookmark = 0
            }
        }
        
        let indexPath = IndexPath(item: sender.tag - 500, section: 0)
        self.collectiontrunk.reloadItems(at: [indexPath])
    }
    
    func didRecieveBookmarkUpdate(response: String) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let trunk = Trunks[indexPath.row]
        delegate?.Trunk_DiscoverEvents(trunk_id:trunk.id)
    }
  
}

