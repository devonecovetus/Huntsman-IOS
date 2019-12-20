//
//  WardrobeCategoryOutfit.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 16/05/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class WardrobeCategoryOutfit: UIViewController {
    var ArrayWardrobeCategory = [] as NSArray
    @IBOutlet weak var CollectionviewWardrobe: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Call_WardrobeCategories()
    }
    // MARK: Api call Call_WardrobeCategories
    func Call_WardrobeCategories() {
        LoderGifView.MyloaderShow(view: self.view)
        
        /* MARK: URLConstant.API.WARDROBE_CATEGGORIES class in api name  (for get wardrobe category ) */
        WebserviceUtil.callGet(jsonRequest: URLConstant.API.WARDROBE_CATEGGORIES,view:self.view ,success: { (response) in
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        LoderGifView.MyloaderHide(view: self.view)
                        self.ArrayWardrobeCategory = (json.value(forKey: "wardrobe_cat")  as! NSArray)
                        self.CollectionviewWardrobe.reloadData()
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
    @IBAction func ActionBack(sender: AnyObject?){
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension WardrobeCategoryOutfit : UICollectionViewDataSource ,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ArrayWardrobeCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WardrobeCollection_Cell", for: indexPath) as! WardrobeCollection_Cell
        
        let list = ArrayWardrobeCategory[indexPath.row]
        cell.Lbl_category.text = ((list as AnyObject).value(forKey: "category") as? String)!
        let url =  ((list as AnyObject).value(forKey: "img") as? String)!
        cell.img.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "no image"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Did---Trunckcell collectiondidselect \(indexPath) ")
        let list = ArrayWardrobeCategory[indexPath.row]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let AddoutFits = storyBoard.instantiateViewController(withIdentifier: "WardrobeAllProductCategory") as! WardrobeAllProductCategory
        AddoutFits.CategoryId = ((list as AnyObject).value(forKey: "category_id") as? String)!
        present(AddoutFits, animated: true, completion: nil)
    }
}

