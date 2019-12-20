//
//  Member_tablecell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 20/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

protocol Member_TableCell_DiscoverDelegate {
    func Member_DiscoverEvents(type:String, member_id:String,Name:String ,Photo:String)
}

class Member_tablecell: UITableViewCell {
  
    var Members = [MemberModel]()
    private let follow_bookmark_attend = Follow_Bookmark_Attend()

    var delegate:Member_TableCell_DiscoverDelegate?

    @IBOutlet weak var collectionwardrobe: UICollectionView!
    
    var HuntsmanMemberArray = [] as NSArray
    
    override func awakeFromNib() {
        super.awakeFromNib()
        follow_bookmark_attend.delegate = self
    }
}

extension Member_tablecell : UICollectionViewDataSource, Follow_Bookmark_AttendDelegate {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Member_cell", for: indexPath) as! Member_cell
        
        let member = Members[indexPath.row]

        if member.photo == "" {
            cell.img_profile.sd_setImage(with: URL(string:""), placeholderImage: UIImage(named: "no image"))
        } else  {
            cell.img_profile.sd_setImage(with: URL(string: member.photo), placeholderImage: UIImage(named: "no image"))
        }

        cell.lbl_name.text = member.name
        
        let dateStr = member.since
        let dateFmt = DateFormatter()
        dateFmt.timeZone = NSTimeZone.default
        dateFmt.dateFormat =  "yyyy-MM-dd  HH:mm:ss"
        
        if dateFmt.date(from: dateStr) != nil {
            let date = dateFmt.date(from: dateStr)
            let year = Calendar.current.component(.year, from: date!)
            
            cell.lbl_since.text = String(year)
        } else  {
           cell.lbl_since.text = ""
        }
        
        cell.lbl_industry.text = member.industry
        
        cell.lbl_noevent.text = member.attend_events
        
        cell.Btn_Comment.tag = 100  + indexPath.row
        cell.Btn_Comment.addTarget(self, action: #selector(action_Message), for: .touchUpInside)
        
        // ---- bookmark
        if member.bookmark != 0{
            cell.Btn_Bookmark .setImage(UIImage(named: "bookmark black")!, for: UIControlState.normal)
        }  else {
            cell.Btn_Bookmark .setImage(UIImage(named: "bookmark")!, for: UIControlState.normal)
        }
        cell.Btn_Bookmark.tag = 500  + indexPath.row
        cell.Btn_Bookmark.addTarget(self, action: #selector(action_bookmark_unbookmark), for: .touchUpInside)

        return cell
    }
    
    // ------- Bookmark section  -------- //
    @objc func action_bookmark_unbookmark(sender: UIButton){
        
        // Fetches the appropriate trunks for the data source layout.
        let member = Members[sender.tag - 500]
        
        if member.bookmark == 0 {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "bookmark", bookmark_id: member.id, bookmark_type: "3", API: URLConstant.API.USER_BOOKMARKACTION)
            
            if let index = Members.index(where: { $0.id == member.id }) {
                Members[index].bookmark = 1
            }
            
        } else {
            follow_bookmark_attend.call_bookmarkunbookmark(type: "unbookmark", bookmark_id: member.id, bookmark_type: "3", API: URLConstant.API.USER_UNBOOKMARKACTION)
            
            if let index = Members.index(where: { $0.id == member.id }) {
                Members[index].bookmark = 0
            }
        }
        
        let indexPath = IndexPath(item: sender.tag - 500, section: 0)
        self.collectionwardrobe.reloadItems(at: [indexPath])
    }
    
    func didRecieveBookmarkUpdate(response: String) {
    }
    func didRecieveFollowUpdate(response: String) {
    }
    func didRecieveAttendUpdate(response: String, attendtype: String) {
    }
    
    @objc func action_Message(sender: UIButton){
        // Fetches the appropriate trunks for the data source layout.
        let member = Members[sender.tag - 100]
        if member.photo == ""{
            delegate?.Member_DiscoverEvents(type: "message",member_id: member.id,Name:member.name ,Photo:"")
        }
        else
        {
            delegate?.Member_DiscoverEvents(type: "message",member_id: member.id,Name:member.name ,Photo:member.photo)
        }
        
    }
    
}

extension Member_tablecell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Fetches the appropriate trunks for the data source layout.
        let member = Members[indexPath.row]
        delegate?.Member_DiscoverEvents(type: "detail",member_id: member.id,Name:"" ,Photo:"")
    }
}
