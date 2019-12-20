//
//  Collapasable_Table.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 12/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class Collapasable_Table: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var mIndustryList = [] as NSArray
    
    var selectsection : Int = 0
    var previeusindex : Int = 0
    var ImageUpDownArraw = false

    var myFirstButton = UIButton()
    var img_updown = UIImageView()

    var IndustryList = [] as NSArray
    
    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PreferenceKey.INDUSTRY_LIST.isEmpty{
            
            WebserviceUtil.callGet(jsonRequest: URLConstant.API.ALL_INDUSTRY,view:self.view ,success: { (response) in
                if let json = response as? NSDictionary {
                    if let status = json.value(forKey: "status") as? String {
                        if status == "OK" {
                            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: json.value(forKey: "industries") as? NSArray as Any)
                            PreferenceUtil.saveIndustryList(list: encodedData as NSData)
                            
                            self.mIndustryList = NSKeyedUnarchiver.unarchiveObject(with: PreferenceUtil.getIndustryList() as Data) as! NSArray
                            
                            self.tableview.reloadData()
                            self.automaticallyAdjustsScrollViewInsets = false
                            self.tableview.contentInset = UIEdgeInsets (top: -34,left: 0,bottom: -20,right: 0)
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
                }
                else
                {
                    UIUtil.showMessage(title: "Huntsman", message:"Sorry, unable to process your request at this time. Please try again later.", controller: self, okHandler: nil)
                }
            }
        }
        else{
            mIndustryList = NSKeyedUnarchiver.unarchiveObject(with: PreferenceUtil.getIndustryList() as Data) as! NSArray
        }
        
        tableview.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return mIndustryList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let industryheader = mIndustryList[section]
        
        let Industyheader_title = ((industryheader as AnyObject).value(forKey: "title") as? String)!

        let customView = UIView()
        customView.frame = CGRect.init(x: 0, y: 0, width: Device.SCREEN_WIDTH, height: 40)
        customView.backgroundColor = UIColor.clear
        //give color to the view
        
        let lbl_title = UILabel()
        lbl_title.frame = CGRect.init(x: 10, y: 0, width: Device.SCREEN_WIDTH - 50 , height: 40)
        lbl_title.backgroundColor = UIColor.clear
        lbl_title.text = Industyheader_title
        lbl_title.textColor = UIColor(red: 143/255.0,
                                      green: 0/255.0,
                                      blue: 42/255.0,
                                      alpha: 1.0)
        lbl_title.font = UIFont(name: "GillSansMT-Regular" , size: 17)
        customView.addSubview(lbl_title)

        img_updown = UIImageView(frame: CGRect(x: Device.SCREEN_WIDTH - 35, y: 12, width: 16, height: 16))
        img_updown.backgroundColor = UIColor.clear
        img_updown.image = UIImage(named:"downarrow red")
        img_updown.contentMode = .scaleAspectFit
        img_updown.tag = 100 + section

        if selectsection == img_updown.tag {
            if ImageUpDownArraw == true{
                ImageUpDownArraw = false
                img_updown.image = UIImage(named:"downarrow red")
            } else {
                ImageUpDownArraw = true
                img_updown.image = UIImage(named:"uparrow red")
            }
        }
        
        customView.addSubview(img_updown)

        myFirstButton = UIButton(type: .custom)
        myFirstButton = UIButton(frame: CGRect(x: 0, y: 0, width: Device.SCREEN_WIDTH, height: 40))
        myFirstButton.tag = 100 + section
        myFirstButton.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        customView.addSubview(myFirstButton)
        
        return customView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if  selectsection == section + 100 && selectsection != previeusindex {
            previeusindex = selectsection;
            let industryheader = mIndustryList[section]
            IndustryList = (industryheader as AnyObject).value(forKey: "sub_industry") as! NSArray
            return IndustryList.count
        } else if selectsection == previeusindex && selectsection == section + 100 {
            previeusindex -= 1000
            return 0
        }
        return 0
    }
    
    @objc func buttonClicked(sender: UIButton!)
    {
        selectsection = sender.tag
        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?
        let industrylist = IndustryList[indexPath.row]
        cell?.textLabel?.text = ((industrylist as AnyObject).value(forKey: "title") as? String)!
        return cell!
    }
    
    func tableView(_ table_view: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let industrylist = IndustryList[indexPath.row]
        let id = ((industrylist as AnyObject).value(forKey: "id") as? String)!
        let Industy_Title = ((industrylist as AnyObject).value(forKey: "title") as? String)!
        
        let myDict = [ "SubCategoryId": id, "SubCategoryTitle":Industy_Title]

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationCategory"), object:myDict , userInfo: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "NotificationCategory"), object: nil)
    }
    
    @IBAction func crossClick(sender: AnyObject?){
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
