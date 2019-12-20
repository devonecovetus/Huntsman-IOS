//
//  Wardorbe_tablecell.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 20/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class Wardorbe_tablecell: UITableViewCell {

    @IBOutlet weak var collectionwardrobe: UICollectionView!
    var WardrobeArray =  [] as NSArray

}

extension Wardorbe_tablecell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WardrobeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Wardrobe_cell", for: indexPath) as! Wardrobe_cell
        let list = WardrobeArray[indexPath.row]
        
        cell.lblcategory.text = ((list as AnyObject).value(forKey: "category") as? String)!
        cell.lbltitle.text = ((list as AnyObject).value(forKey: "title") as? String)!

        if let pic = ((list as AnyObject).value(forKey: "image") as? String), pic != "" {
            cell.img_dress.sd_setImage(with: URL(string: pic), placeholderImage: UIImage(named: "no image"))
        }else {
            cell.img_dress.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "no image"))
        }
        return cell
    }
    
}

extension Wardorbe_tablecell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Did---videoCelll-seledct \(indexPath) ")
    }
}
