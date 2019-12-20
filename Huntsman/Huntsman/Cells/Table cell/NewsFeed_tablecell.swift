//
//  NewsFeed_tablecell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 20/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
protocol Feed_tablecell_DiscoverDelegate {
    
    func Feed_DiscoverEvents(feed_id:String)
}

class NewsFeed_tablecell: UITableViewCell {
    
    var Feeds = [FeedsModel]()
    
    var delegate:Feed_tablecell_DiscoverDelegate?

    @IBOutlet weak var collectionnewsfeed: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension NewsFeed_tablecell : UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Feeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Newsfeed_collectioncell", for: indexPath) as! Newsfeed_collectioncell

        let feed = Feeds[indexPath.row]
        
        let HtmlStringconvertTitle = feed.title
        do {
            let finalstring    =  try NSAttributedString(data: HtmlStringconvertTitle.data(using: String.Encoding.utf8)!, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue],documentAttributes: nil)
            cell.Lbl_FeedDescrip.text = finalstring.string
        } catch {
            print("Cannot convert html string to attributed string: \(error)")
        }
        let string = feed.date

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if dateFormatter.date(from: string) != nil {
            let date = dateFormatter.date(from: string)
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            cell.Lbl_Date.text = dateFormatter.string(from: date!)
        }  else {
            cell.Lbl_Date.text = ""
        }
        
        if feed.photo.count == 0 {
            cell.Img_Feed.image = UIImage(named:"no image")
        } else {
            cell.Img_Feed.sd_setImage(with: URL(string: feed.photo[0] as! String), placeholderImage: UIImage(named: "no image"))
        }
        return cell
    }
}

extension NewsFeed_tablecell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feed = Feeds[indexPath.row]
        delegate?.Feed_DiscoverEvents(feed_id: feed.id)
    }
  
}

