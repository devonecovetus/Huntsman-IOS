//
//  SideMenu_ViewController.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 22/03/18.
//  Copyright © 2018 covetus llc. All rights reserved.


import UIKit
struct SideMenuStruct {
    static var someStringConstant = ""
}

class SideMenu_ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SWRevealViewControllerDelegate  {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var Image_view: UIImageView!
    @IBOutlet weak var Lbl_userName: UILabel!
    @IBOutlet weak var Btn_Edit: UIButton!
    @IBOutlet weak var Btn_Setting: UIButton!

    // Local huntsman title and image array declaration
    var Array_SideMenuList = ["Discover","Trunk Shows","Events","News Feeds","Messaging","Huntsman Members","My Huntsman Wardrobe","Retailers"]
    var Array_GrayImage = ["Discover","Trunkshow","Event","NewsFeed","Messaging","HuntsmanMember","Wardrob","Retailer"]
    var Array_WhiteImage = ["DiscoverWhite","TrunkshowWhite","EventWhite","NewsFeedWhite","MessagingWhite","HuntsmenMemberWhite","WardrobWhite","RetailerWhite"]

    override func viewDidLoad() {
        super.viewDidLoad()
        SideMenuStruct.someStringConstant = ""
        Btn_Edit.titleLabel?.minimumScaleFactor = 0.5
        Btn_Edit.titleLabel?.adjustsFontSizeToFitWidth = true
        
        let  username = PreferenceUtil.getUser().name
        let  lastname = PreferenceUtil.getUser().lastname
        Lbl_userName.text = username.uppercased() + " " + lastname.uppercased()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let VariableStatus = SideMenuStruct.someStringConstant
        
        if  VariableStatus == "Profile" {
            UserDefaults.standard.removeObject(forKey:"Row_Selected")
            Btn_Setting.backgroundColor = .clear
             self.Btn_Setting.setTitleColor(UIColor(red: 85/255.0,green: 85/255.0,blue: 85/255.0,alpha: 1.0), for: UIControlState.normal)
            self.Btn_Setting.setImage(UIImage(named: "Setting"), for: .normal)

            Btn_Edit.backgroundColor = UIColor(red: 143/255.0, green: 0/255.0, blue: 42/255.0, alpha: 1.0)
            self.Btn_Edit.setTitleColor(UIColor.white, for: .normal)
            self.Btn_Edit.setImage(UIImage(named: "EditProfile white"), for: .normal)

            tableview.reloadData()
        } else  if  VariableStatus == "Setting" {
            UserDefaults.standard.removeObject(forKey:"Row_Selected")
            Btn_Edit.backgroundColor = .clear
            self.Btn_Edit.setTitleColor(UIColor(red: 85/255.0,green: 85/255.0,blue: 85/255.0,alpha: 1.0), for: UIControlState.normal)
            self.Btn_Edit.setImage(UIImage(named: "EditProfile"), for: .normal)

            Btn_Setting.backgroundColor = UIColor(red: 143/255.0, green: 0/255.0, blue: 42/255.0,  alpha: 1.0)
            self.Btn_Setting.setTitleColor(UIColor.white, for: .normal)
            self.Btn_Setting.setImage(UIImage(named: "Setting white"), for: .normal)
            tableview.reloadData()
        } else {
            self.Btn_Setting.setTitleColor(UIColor(red: 85/255.0,green: 85/255.0,blue: 85/255.0,alpha: 1.0), for: UIControlState.normal)
            self.Btn_Edit.setTitleColor(UIColor(red: 85/255.0,green: 85/255.0,blue: 85/255.0,alpha: 1.0), for: UIControlState.normal)
            Btn_Setting.backgroundColor = .clear
            Btn_Edit.backgroundColor = .clear
            self.Btn_Edit.setImage(UIImage(named: "EditProfile"), for: .normal)
            self.Btn_Setting.setImage(UIImage(named: "Setting"), for: .normal)
        }
        
        let profileImg = PreferenceUtil.getUser().profilepic
        if  profileImg != "" {
            self.Image_view.sd_setImage(with: URL(string: profileImg), placeholderImage: UIImage(named: "no image"))
        } else {
            self.Image_view.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "no image"))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    @IBAction func setting_action(_ sender: Any) {
        
        SideMenuStruct.someStringConstant = "Setting"
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "Privacy_VC") as! Privacy_VC
        self.revealViewController().pushFrontViewController(profile, animated: true)
    }
    // profile screen detail
    @IBAction func profile_action(_ sender: Any) {
        SideMenuStruct.someStringConstant = "Profile"
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "ProfileScreen_VC") as! ProfileScreen_VC
        self.revealViewController().pushFrontViewController(profile, animated: true)
    }
    //  App logout
    @IBAction func ActionLogout(_ sender: Any) {
        LoderGifView.MyloaderShow(view: view)
        WebserviceUtil.callGet(jsonRequest: URLConstant.API.USER_Logout ,view:self.view, success: { (response) in
            if let json = response as? NSDictionary {
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        LoderGifView.MyloaderHide(view: self.view)
                        SideMenuStruct.someStringConstant = ""
                        let TokenSave = PreferenceUtil.getUserdevicetoken()
                        print(TokenSave)
                        
                        let defaults = UserDefaults.standard
                        let dictionary = defaults.dictionaryRepresentation()
                        dictionary.keys.forEach { key in
                            defaults.removeObject(forKey: key)
                        }
                        print("Device Token: \(TokenSave)")
                        PreferenceUtil.saveUserdevicetoken(token: TokenSave)
                        let TokenSave1 = PreferenceUtil.getUserdevicetoken()
                        print(TokenSave1)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.Call_LoginScreen()
                    } else {
                        LoderGifView.MyloaderHide(view: self.view)
                    }
                }
            }
        }) { (error) in
            LoderGifView.MyloaderHide(view: self.view)
            print(error.localizedDescription)
        }
    }
    
    // Table delegate and datasourc method
    func tableView(_ table_view: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array_SideMenuList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "SideMenu_Cell", for: indexPath) as! SideMenu_Cell
        let row_type = PreferenceUtil.get(key: PreferenceKey.SIDEMENU_ROWSELECT)
        
         if (Device.IS_IPHONE_5) {
            cell.Lbl_Title?.font = cell.Lbl_Title?.font.withSize(16)
         }
        cell.Lbl_Title?.text = Array_SideMenuList [indexPath.row]

        if  row_type == Array_SideMenuList [indexPath.row]{
            cell.Image_View?.image = UIImage(named: Array_WhiteImage [indexPath.row])
            cell.Lbl_Title?.textColor = UIColor.white
            cell.Bg_View?.backgroundColor = UIColor(red: 143/255.0, green: 0/255.0, blue: 42/255.0, alpha: 1.0)
        } else {
            cell.Image_View?.image = UIImage(named: Array_GrayImage [indexPath.row])
            cell.Lbl_Title?.textColor = UIColor.darkGray
            cell.Bg_View?.backgroundColor = UIColor.clear
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "Discover_VC") as! Discover_VC
            self.revealViewController().pushFrontViewController(profile, animated: true)
        } else if indexPath.row == 1 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "Trunk_ShowsVC") as! Trunk_ShowsVC
            self.revealViewController().pushFrontViewController(profile, animated: true)
        } else if indexPath.row == 2 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "Event_BaseVC") as! Event_BaseVC
            self.revealViewController().pushFrontViewController(profile, animated: true)
        } else if indexPath.row == 3 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "NewsFeed_ListVC") as! NewsFeed_ListVC
            self.revealViewController().pushFrontViewController(profile, animated: true)
        } else if indexPath.row == 4 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "Message_BaseVC") as! Message_BaseVC
            self.revealViewController().pushFrontViewController(profile, animated: true)
        } else if indexPath.row == 5 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "HuntsMember_BaseVC") as! HuntsMember_BaseVC
            self.revealViewController().pushFrontViewController(profile, animated: true)
        } else if indexPath.row == 6 {
           let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
           let profile = storyBoard.instantiateViewController(withIdentifier: "Wardrobe_AnimationVC") as! Wardrobe_AnimationVC
           self.revealViewController().pushFrontViewController(profile, animated: true)
        } else if indexPath.row == 7{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profile = storyBoard.instantiateViewController(withIdentifier: "Retailers_BaseVC") as! Retailers_BaseVC
            self.revealViewController().pushFrontViewController(profile, animated: true)
        }
        SideMenuStruct.someStringConstant = ""
        PreferenceUtil.save(key: PreferenceKey.SIDEMENU_ROWSELECT, value: Array_SideMenuList [indexPath.row])
        tableview.reloadData()
    }
}

