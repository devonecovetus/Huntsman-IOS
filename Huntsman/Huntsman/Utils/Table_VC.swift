
//
//  Table_VC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 19/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class Table_VC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table_view: UITableView!
    
    var mInterestList = [] as NSArray
    
    var InterestSelectTitle = [] as NSMutableArray
    var InterestSelectId = [] as NSMutableArray
    
    var InterestPassedTitle = ""
    var InterestPassedId = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if InterestPassedTitle.isEmpty || InterestPassedTitle == ""{
            print("empty")
        }else{
            let arr = InterestPassedTitle.components(separatedBy: ",")
            for item in arr {
                InterestSelectTitle.add(item)
            }
            
            let arrid = InterestPassedId.components(separatedBy: ",")
            for item2 in arrid {
                InterestSelectId.add(item2)
            }
        }
        
        if PreferenceKey.INTEREST_LIST.isEmpty{
            
            LoderGifView.MyloaderShow(view: view)
            
            WebserviceUtil.callGet(jsonRequest: URLConstant.API.ALL_INTEREST,view:self.view, success: { (response) in
                if let json = response as? NSDictionary {
                    if let status = json.value(forKey: "status") as? String {
                        if status == "OK" {
                            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: json.value(forKey: "interest") as? NSArray as Any)
                            PreferenceUtil.saveInterestList(list: encodedData as NSData)
                            
                            self.mInterestList = NSKeyedUnarchiver.unarchiveObject(with: PreferenceUtil.getInterestList() as Data) as! NSArray
                            
                            self.table_view.reloadData()
                        }
                        else {
                            // parsing status error
                        }
                    }
                    LoderGifView.MyloaderHide(view: self.view)
                }
            }) { (error) in
                print(error.localizedDescription)
                LoderGifView.MyloaderHide(view: self.view)
                if error.localizedDescription == "The operation couldn’t be completed. (No Internet Connection error 503.)"
                {
                    UIUtil.showMessage(title: "No Internet Connection", message:"Make sure your device is connected to the internet.", controller: self, okHandler: nil)
                } else
                {
                    UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
                }
            }
        }
        else
        {
            mInterestList = NSKeyedUnarchiver.unarchiveObject(with: PreferenceUtil.getInterestList() as Data) as! NSArray
        }
     
        table_view.tableFooterView = UIView()
    }
    
    func tableView(_ table_view: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mInterestList.count
    }
    
    func tableView(_ table_view: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table_view.dequeueReusableCell(withIdentifier: "Industry_Cell", for: indexPath) as! Industry_Cell
        
        let industrylist = mInterestList[indexPath.row]
        
        cell.lblText.text = (industrylist as AnyObject).value(forKey: "interest_title") as? String
        
        if InterestSelectId.contains((mInterestList[indexPath.row] as AnyObject).value(forKey: "id") as? String as Any)
        {
            cell.lblText.textColor = UIColor(red: 143/255.0,
                                             green: 0/255.0,
                                             blue: 42/255.0,
                                             alpha: 1.0)
            cell.ImageView.image = UIImage(named:"CheckBoxNew")
            cell.ImageView.isHidden = false
        } else {
            cell.ImageView.isHidden = true
            cell.lblText.textColor = UIColor.lightGray
        }
        return cell
    }
    
    func tableView(_ table_view: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if InterestSelectId.contains((mInterestList[indexPath.row] as AnyObject).value(forKey: "id") as? String as Any)
        {
            InterestSelectId.remove((mInterestList[indexPath.row] as AnyObject).value(forKey: "id") as? String as Any)
            InterestSelectTitle.remove((mInterestList[indexPath.row] as AnyObject).value(forKey: "interest_title") as? String as Any)

        } else {
            InterestSelectId.add((mInterestList[indexPath.row] as AnyObject).value(forKey: "id") as? String as Any)
            InterestSelectTitle.add((mInterestList[indexPath.row] as AnyObject).value(forKey: "interest_title") as? String as Any)
        }
        
        table_view.reloadData()
    }
    
    @IBAction func doneClick(sender: AnyObject?){
        
        if InterestSelectTitle.count == 0
        {
            UIUtil.showMessage(title: "", message: "Please select interest", controller: self, okHandler: nil)
        }
        else{
            let string_Interesttitle = InterestSelectTitle.componentsJoined(by: ",")
            let string_interestid = InterestSelectId.componentsJoined(by: ",")
            let interestcount = Int(InterestSelectId.count)
            
            let string_Interesttitlezero = InterestSelectTitle[0]
            
            let myDict = ["InterestId": string_interestid, "InterestTitle":string_Interesttitle, "InterestCount":interestcount, "ZeroInterest":string_Interesttitlezero] as [String : Any]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationInterest"), object:myDict , userInfo: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func crossClick(sender: AnyObject?){
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
