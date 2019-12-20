//
//  TrunkShow_CalenderVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 30/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import XLPagerTabStrip
enum MyTheme {
    case light
    case dark
}
class TrunkShow_CalenderVC: UIViewController,IndicatorInfoProvider ,CalenderDelegate,UITableViewDelegate,UITableViewDataSource{
    var Month :Int = 0
    var Year:Int = 0
    var Day:Int = 0
    var Str_Page = ""
    var Str_day = ""
    var intpage : Int = 0
    var more : Int!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var Lbl_Month: UILabel!
    @IBOutlet weak var Lbl_Status: UILabel!
    @IBOutlet weak var Lbl_Month_YPosition: NSLayoutConstraint!
    @IBOutlet weak var Table_ViewContaintSize: NSLayoutConstraint!
    
    var Trunk_shows_Array = [] as NSMutableArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableview.estimatedRowHeight = 120.0
        tableview.rowHeight = UITableViewAutomaticDimension
        
        UserDefaults.standard.removeObject(forKey:"allcalendarlist")
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        Month  = month
        Year = year
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let now = Date()
        let dateString = formatter.string(from:now)
        let DateMonth = formatter.date(from: dateString)
        formatter.dateFormat = "MMMM"
        let GetDateMonth = formatter.string(from: DateMonth!)
        Lbl_Month.text = String(describing: GetDateMonth).uppercased()
        
        Str_day = ""
        callLoginAPI()
        
        ScrollView.addSubview(calenderView)
        calenderView.delegate = self
        calenderView.topAnchor.constraint(equalTo: ScrollView.topAnchor, constant: 10).isActive=true
        calenderView.rightAnchor.constraint(equalTo: ScrollView.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: ScrollView.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 365).isActive=true
        self.Lbl_Month_YPosition.constant = self.calenderView.frame.origin.y + self.calenderView.frame.size.height - 50
    }
    
    // MARK: -   -------Calendar Delegate Method ----
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    lazy var  calenderView: CalenderView = {
        let calenderView = CalenderView(theme: MyTheme.light)
        calenderView.translatesAutoresizingMaskIntoConstraints=false
        return calenderView
    }()
    
    func didTap_PrivousMonth(date:String)
    {
        print(date)
        let dateFmt = DateFormatter()
        dateFmt.timeZone = NSTimeZone.default
        dateFmt.dateFormat = "MMMM yyyy"
        
        // Get NSDate for the given string
        let date1 = dateFmt.date(from: date)
        let year = Calendar.current.component(.year, from: date1!)
        let month = Calendar.current.component(.month, from: date1!)
        
        Month = month
        Year = year
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMMM"
        let DateMonth = dateFormatter.string(from: date!)
        Lbl_Month.text = String(describing: DateMonth).uppercased()
        Str_day = ""
        callLoginAPI()
    }
    
    func didTap_NextMonth(date:String)
    {
        print(date)
        let dateFmt = DateFormatter()
        dateFmt.timeZone = NSTimeZone.default
        dateFmt.dateFormat = "MMMM yyyy"
        let date1 = dateFmt.date(from: date)
        let year = Calendar.current.component(.year, from: date1!)
        let month = Calendar.current.component(.month, from: date1!)
        
        Month  = month
        Year = year
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMMM"
        let DateMonth = dateFormatter.string(from: date!)
        Lbl_Month.text = String(describing: DateMonth).uppercased()
        Str_day = ""
        callLoginAPI()
    }
    func didTapDate(date: String, available: Bool)
    {
        print(date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date2 = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let DateMonth = dateFormatter.string(from: date2!)
        Str_day = DateMonth
        self.Lbl_Month_YPosition.constant = self.calenderView.frame.origin.y + self.calenderView.frame.size.height - 50
        self.callLoginApi_SelectedMonth()
    }
    
    // MARK: -   -------Api Calling for Event Show in month ----
    func callLoginAPI() {
        LoderGifView.MyloaderShow(view: self.view)
        
        let params = [
            URLConstant.Param.MONTH : Month,
            URLConstant.Param.YEAR : Year
        ]
        
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.USER_TRUNKCALENDAR,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let trunk_calendar = json.value(forKey: "trunk_calender") as? NSArray
                        if trunk_calendar?.count == 0{
                            UserDefaults.standard.removeObject(forKey:"allcalendarlist")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "load"), object: nil)

                            self.Lbl_Month_YPosition.constant = self.calenderView.frame.origin.y + self.calenderView.frame.size.height - 50
                            self.Trunk_shows_Array.removeAllObjects()
                            self.tableview.reloadData()
                            self.Table_ViewContaintSize.constant = self.tableview.contentSize.height + 10
                            
                            
                        }
                        else{
                            var EventListArray = [Int] ()
                            for Item in trunk_calendar!
                            {
                                let Date = ((Item as AnyObject).value(forKey: "date") as? String)!
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                let date = dateFormatter.date(from: Date)!
                                dateFormatter.dateFormat = "dd"
                                let finaldayEvent = dateFormatter.string(from: date)
                                EventListArray.append(Int(finaldayEvent)!)
                            }
                            UserDefaults.standard.removeObject(forKey:"allcalendarlist")
                            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject:EventListArray  as Any)
                            PreferenceUtil.saveCalendarList(list: encodedData as NSData)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "load"), object: nil)

                            self.Lbl_Month_YPosition.constant = self.calenderView.frame.origin.y + self.calenderView.frame.size.height - 50
                            LoderGifView.MyloaderHide(view: self.view)
                            self.callLoginApi_SelectedMonth()
                        }
                    }
                    else {
                        UIUtil.showMessage(title: "Alert!", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                    }
                }
                LoderGifView.MyloaderHide(view: self.view)
            }
        }) { (error) in
            print(error.localizedDescription)
            LoderGifView.MyloaderHide(view: self.view)
        }
    }
    
    // MARK: -   -------Api Calling for SelectedMonth ----
    
    func callLoginApi_SelectedMonth() {
        LoderGifView.MyloaderShow(view: self.view)
        let params = [
            URLConstant.Param.PAGE:Str_Page,
            URLConstant.Param.BOOKMARK:"0",
            URLConstant.Param.TYPE :"",
            URLConstant.Param.MONTH: String(Month),
            URLConstant.Param.YEAR :String(Year),
            URLConstant.Param.FILTERDATE :Str_day
        ]
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.TRUNKSHOW_GETAPPTRUNK,view: self.view, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        let TotalTrunk = json.value(forKey: "total_trunk") as? Int
                        if TotalTrunk == 0 {
                            
                            self.Trunk_shows_Array.removeAllObjects()
                            self.tableview.reloadData()
                            self.Table_ViewContaintSize.constant = self.tableview.contentSize.height + 10
                            self.Lbl_Status.text = "There are no trunk show"
                            self.Lbl_Status.isHidden = false
                            LoderGifView.MyloaderHide(view: self.view)
                            //UIUtil.showMessage(title: "Alert!", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                        }
                        else
                        {
                            self.more = json.value(forKey: "more") as? Int
                            LoderGifView.MyloaderHide(view: self.view)
                            self.Trunk_shows_Array = (json.value(forKey: "trunks") as! NSMutableArray)
                            self.Lbl_Status.isHidden = true
                            self.Table_ViewContaintSize.constant = 250
                            self.tableview.reloadData()
                            self.tableview.layoutIfNeeded()
                            self.Table_ViewContaintSize.constant = self.tableview.contentSize.height + 10
                            
                        }
                    }
                    else {
                        LoderGifView.MyloaderHide(view: self.view)
                        UIUtil.showMessage(title: "Alert!", message: (json.value(forKey: "message") as? String)!, controller: self, okHandler: nil)
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            LoderGifView.MyloaderHide(view: self.view)
        }
    }
    
    // MARK: -   -------Table view delegate and datasource Method ----
    func tableView(_ table_view: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Trunk_shows_Array.count
    }
    
    func tableView(_ table_view: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table_view.dequeueReusableCell(withIdentifier: "TrunkList_Cell", for: indexPath) as! TrunkList_Cell
        var list:NSDictionary
        list =  Trunk_shows_Array[indexPath.row]as! NSDictionary
        
        cell.Lbl_TrunkTitle.text = ((list as AnyObject).value(forKey: "trunk_title") as? String)!
        cell.Lbl_TrunkDescrip.text = ((list as AnyObject).value(forKey: "trunk_desc") as? String)!
        let string = ((list as AnyObject).value(forKey: "trunk_date") as? String)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let dateString = dateFormatter.string(from: date)
        cell.Lbl_Date.text = dateString
        
        if let bookmark = ((list as AnyObject).value(forKey: "bookmark") as? Int), bookmark != 0 {
            cell.Btn_BookMark .setImage(UIImage(named: "bookmark filled")!, for: UIControlState.normal)
        }
        
        if let follow = ((list as AnyObject).value(forKey: "follow") as? Int), follow != 0 {
            cell.Btn_like .setImage(UIImage(named: "follow filled")!, for: UIControlState.normal)
        }
        if let attend = ((list as AnyObject).value(forKey: "attend") as? Int), attend != 0 {
            cell.Btn_Attendent .setImage(UIImage(named: "attend  filled")!, for: UIControlState.normal)
        }
        
       
        if let pic = ((list as AnyObject).value(forKey: "thumb_image") as? String), pic != "" {
            cell.img_trunk.sd_setImage(with: URL(string: pic), placeholderImage: UIImage(named: "no image"))
        }else {
            cell.img_trunk.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "no image"))
        }
        
        return cell
        
    }
    func tableView(_ table_view: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var list:NSDictionary
        list =  Trunk_shows_Array[indexPath.row]as! NSDictionary
        let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "Trunk_DetailVC") as! Trunk_DetailVC
        profile.TrunkId = ((list as AnyObject).value(forKey: "id") as? String)!
        present(profile, animated: true, completion: nil)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: " Calender       ",image:UIImage(named: "Calender")!, highlightedImage:UIImage(named: "Calender"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
