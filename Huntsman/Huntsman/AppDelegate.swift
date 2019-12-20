//
//  AppDelegate.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 27/02/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//
/*

*/
import UIKit
import CoreData
import UserNotifications
import Firebase
import Fabric
import Crashlytics
import BRYXBanner
import GooglePlaces


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,SWRevealViewControllerDelegate{

    var window: UIWindow?
    var IsApi_Appdelegate:Bool?

    var industry_list: [NSManagedObject] = []
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        // Register with APNs
        GMSPlacesClient.provideAPIKey("AIzaSyBt13UEXUFjra-5UmOa9Y4rOO5a0msgj3w")
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.registerForRemoteNotifications()
        self.registerForLocalNotifications()
        
        // ----- Removing userdefaults -----
        UserDefaults.standard.removeObject(forKey:"allcalendarlist")
        UserDefaults.standard.removeObject(forKey:"allmaplist")
                
        //    If required
        if  PreferenceUtil.getUser().token.isEmpty {
        } else {
            IsApi_Appdelegate = true
            //MARK: URLConstant.API.ALL_INDUSTRY class in api name.(for get all industries)
            WebserviceUtil.callGet(jsonRequest: URLConstant.API.ALL_INDUSTRY,view:window!, success: { (response) in
                if let json = response as? NSDictionary {
                    if let status = json.value(forKey: "status") as? String {
                        if status == "OK" {
                            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: json.value(forKey: "industries") as? NSArray as Any)
                            PreferenceUtil.saveIndustryList(list: encodedData as NSData)
                        }
                        else {
                        }
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
            
            IsApi_Appdelegate = true
            //MARK: URLConstant.API.ALL_INTEREST class in api name.. (for get all interest )
            WebserviceUtil.callGet(jsonRequest: URLConstant.API.ALL_INTEREST ,view:window!, success: { (response) in
                if let json = response as? NSDictionary {
                    if let status = json.value(forKey: "status") as? String {
                        if status == "OK" {
                            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: json.value(forKey: "interest") as? NSArray as Any)
                            PreferenceUtil.saveInterestList(list: encodedData as NSData)
                        }
                        else {
                        }
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
       
        let profilecop = PreferenceUtil.getProfileComplete()
        if profilecop == "yes"
        {
            rootview_views(string: "discover")
        }
        else{
            
        }
        return true
    }
 
    
    // App root set
    func rootview_views(string : String) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let frontNavigationController:UINavigationController
        let rearNavigationController:UINavigationController
        let revealController = SWRevealViewController()
        var mainRevealController = SWRevealViewController()
        
        let SideMenu = mainStoryboard.instantiateViewController(withIdentifier:  "SideMenu_ViewController")as! SideMenu_ViewController
        
        if string == "discover"
        {
            let Discover_V = mainStoryboard.instantiateViewController(withIdentifier: "Discover_VC") as! Discover_VC
            frontNavigationController =  UINavigationController(rootViewController: Discover_V)
        } else
        {
            let Discover_V = mainStoryboard.instantiateViewController(withIdentifier: "ProfileScreen_VC") as! ProfileScreen_VC
            frontNavigationController =  UINavigationController(rootViewController: Discover_V)
        }
        
        rearNavigationController = UINavigationController(rootViewController: SideMenu)
        frontNavigationController.navigationBar.isHidden = true
        rearNavigationController.navigationBar.isHidden = true
        
        revealController.frontViewController = frontNavigationController
        revealController.rearViewController = rearNavigationController
        revealController.delegate = self
        mainRevealController  = revealController
        
        self.window?.rootViewController = mainRevealController
    }
    
    func Call_LoginScreen()
    {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        if Device.IS_IPHONE_5
//        {
//            mainStoryboard = UIStoryboard(name: "Iphone5", bundle: nil)
//        }
//        else
//        {
//            mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        }
        let login_vc = mainStoryboard.instantiateViewController(withIdentifier: "Signup_SignInVc") as! Signup_SignInVc
        let naviationcontroller =  UINavigationController(rootViewController: login_vc)
        naviationcontroller.navigationBar.isHidden = true
        self.window?.rootViewController = naviationcontroller
    }

    // Handle remote notification registration.
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        PreferenceUtil.saveUserdevicetoken(token: token)
        
        if  PreferenceUtil.getUser().token.isEmpty {
        }
        else
        {
          self.CallApiupdateDeviceId()
        }
    }

    // MARK : Call api update deiviceId for push notification.......
    func CallApiupdateDeviceId() {
        let params = [
            URLConstant.Param.DEVICEID:PreferenceUtil.getUserdevicetoken() ,
            URLConstant.Param.DEVICETYPE: "Iphone"
        ]
        WebserviceUtil.callPost(jsonRequest: URLConstant.API.USER_UPDATE_DEVICEID,view:window!, params: params, success: { (response) in
            
            if let json = response as? NSDictionary {
                
                if let status = json.value(forKey: "status") as? String {
                    if status == "OK" {
                        
                    }
                    else {
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
        PreferenceUtil.saveUserdevicetoken(token: "")
    }

    func registerForLocalNotifications() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.alert, .sound, .badge];
            center.requestAuthorization(options: options) {
                (granted, error) in
                if !granted {
                    print("Notification permission not granted")
                    PreferenceUtil.saveUserdevicetoken(token: "")
                }
            }
            center.getNotificationSettings { (settings) in
                if settings.authorizationStatus != .authorized {
                    // Notifications not allowed
                    print("Notification not authorized")
                }
            }
            
        } else {
            // Fallback on earlier versions
            let notificationSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        }
    }
    // Recive Push notifcation from server
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("Recived: \(userInfo)")
        let state = UIApplication.shared.applicationState
        if state == .inactive {
            if let aps = userInfo["aps"] as? NSDictionary {
                if let alert = aps["alert"] as? NSDictionary {
                    
                    let StrTypeId = String(format: "%@", alert.value(forKey: "type_id") as! CVarArg)
                    let StrEntityId = String(format: "%@", alert.value(forKey: "entity_id") as! CVarArg)
                    let Str_Title = String(format: "%@", alert.value(forKey: "title") as! CVarArg)
                    
                    let storyBoard: UIStoryboard  = UIStoryboard(name: "Main", bundle: nil)
                    
                    let profilecop = PreferenceUtil.getProfileComplete()
                    if profilecop == "yes"
                    {
                    switch StrTypeId
                    {
                    case "1":
                        let profile = storyBoard.instantiateViewController(withIdentifier: "NewsFeed_DetailVC") as! NewsFeed_DetailVC
                        profile.NewsFeedId = StrEntityId
                        profile.BackNotification_Vc = "PushNotifcation"
                        let naviationcontroller =  UINavigationController(rootViewController: profile)
                        naviationcontroller.navigationBar.isHidden = true
                        
                        if let window = self.window, let rootViewController = window.rootViewController {
                            var currentController = rootViewController
                            while let presentedController = currentController.presentedViewController {
                                currentController = presentedController
                            }
                            currentController.present(naviationcontroller, animated: true, completion: nil)
                        }
                        
                    case "2":
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
                        let profile = storyBoard.instantiateViewController(withIdentifier: "Trunk_DetailVC") as! Trunk_DetailVC
                        profile.TrunkId = StrEntityId
                        profile.BackNotification_Vc = "PushNotifcation"
                        let naviationcontroller =  UINavigationController(rootViewController: profile)
                        naviationcontroller.navigationBar.isHidden = true
                        if let window = self.window, let rootViewController = window.rootViewController {
                            var currentController = rootViewController
                            while let presentedController = currentController.presentedViewController {
                                currentController = presentedController
                            }
                            currentController.present(naviationcontroller, animated: true, completion: nil)
                        }
                        
                    case "3":
                        let EventDetail = storyBoard.instantiateViewController(withIdentifier: "Event_DetailVC") as! Event_DetailVC
                        EventDetail.EventId = StrEntityId
                        EventDetail.BackNotification_Vc = "PushNotifcation"
                        let naviationcontroller =  UINavigationController(rootViewController: EventDetail)
                        naviationcontroller.navigationBar.isHidden = true
                        
                        if let window = self.window, let rootViewController = window.rootViewController {
                            var currentController = rootViewController
                            while let presentedController = currentController.presentedViewController {
                                currentController = presentedController
                            }
                            currentController.present(naviationcontroller, animated: true, completion: nil)
                        }
                        
                    case "4":
                        
                        let RetailerDetail = storyBoard.instantiateViewController(withIdentifier: "Retailer_DetailVC") as! Retailer_DetailVC
                        RetailerDetail.RetailerId = StrEntityId
                        RetailerDetail.BackNotification_Vc = "PushNotifcation"
                        let naviationcontroller =  UINavigationController(rootViewController: RetailerDetail)
                        naviationcontroller.navigationBar.isHidden = true
                        if let window = self.window, let rootViewController = window.rootViewController {
                            var currentController = rootViewController
                            while let presentedController = currentController.presentedViewController {
                                currentController = presentedController
                            }
                            currentController.present(naviationcontroller, animated: true, completion: nil)
                        }
                        
                    case "5":
                        
                        let profile = storyBoard.instantiateViewController(withIdentifier: "Message_DetailVC") as! Message_DetailVC
                        profile.str_messageto = StrEntityId
                        profile.To_UserName = Str_Title
                        profile.BackNotification_Vc = "PushNotifcation"
                        
                        let naviationcontroller =  UINavigationController(rootViewController: profile)
                        naviationcontroller.navigationBar.isHidden = true

                        if let window = self.window, let rootViewController = window.rootViewController {
                            var currentController = rootViewController
                            while let presentedController = currentController.presentedViewController {
                                currentController = presentedController
                            }
                            currentController.present(naviationcontroller, animated: true, completion: nil)
                        }

                    case "6":
                        let WebView = storyBoard.instantiateViewController(withIdentifier: "Wardrobe_WebviewVC") as! Wardrobe_WebviewVC
                        WebView.Str_url = StrEntityId
                        WebView.BackNotification_Vc = "PushNotifcation"
                        let naviationcontroller =  UINavigationController(rootViewController: WebView)
                        naviationcontroller.navigationBar.isHidden = true
                         self.window?.rootViewController = naviationcontroller
                        if let window = self.window, let rootViewController = window.rootViewController {
                            var currentController = rootViewController
                            while let presentedController = currentController.presentedViewController {
                                currentController = presentedController
                            }
                            currentController.present(naviationcontroller, animated: true, completion: nil)
                        }
                        
                    case "7":
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
                        let profile = storyBoard.instantiateViewController(withIdentifier: "Admin_ChatVC") as! Admin_ChatVC
                        profile.Flage_PrivousVC = "wardrobe_admin"
                        profile.BackNotification_Vc = "PushNotifcation"
                        let naviationcontroller =  UINavigationController(rootViewController: profile)
                        naviationcontroller.navigationBar.isHidden = true
                        if let window = self.window, let rootViewController = window.rootViewController {
                            var currentController = rootViewController
                            while let presentedController = currentController.presentedViewController {
                                currentController = presentedController
                            }
                            currentController.present(naviationcontroller, animated: true, completion: nil)
                        }
                        
                    case "8":
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
                        let profile = storyBoard.instantiateViewController(withIdentifier: "Admin_ChatVC") as! Admin_ChatVC
                        profile.Flage_PrivousVC = "trunkshow_admin"
                        profile.RequestBookingId = StrEntityId
                        profile.BackNotification_Vc = "PushNotifcation"
                        let naviationcontroller =  UINavigationController(rootViewController: profile)
                        naviationcontroller.navigationBar.isHidden = true
                        
                        if let window = self.window, let rootViewController = window.rootViewController {
                            var currentController = rootViewController
                            while let presentedController = currentController.presentedViewController {
                                currentController = presentedController
                            }
                            currentController.present(naviationcontroller, animated: true, completion: nil)
                        }
                        
                    case "9":

                        let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
                        let profile = storyBoard.instantiateViewController(withIdentifier: "Admin_ChatVC") as! Admin_ChatVC
                        profile.Flage_PrivousVC = "wardrobe_admin"
                        profile.UserAdminChat = "User_AdminChat"
                        profile.BackNotification_Vc = "PushNotifcation"
                        let naviationcontroller =  UINavigationController(rootViewController: profile)
                        naviationcontroller.navigationBar.isHidden = true
                        
                        if let window = self.window, let rootViewController = window.rootViewController {
                            var currentController = rootViewController
                            while let presentedController = currentController.presentedViewController {
                                currentController = presentedController
                            }
                            currentController.present(naviationcontroller, animated: true, completion: nil)
                        }
                    default:
                        print("No match")
                    }
                   }
                }
            }
            completionHandler(.newData)
     }
        else if state == .active || state == .background
        {
            
            if let aps = userInfo["aps"] as? NSDictionary {
                
                if let alert = aps["alert"] as? NSDictionary {
                    let StrTypeId = String(format: "%@", alert.value(forKey: "type_id") as! CVarArg)
                    let StrEntityId = String(format: "%@", alert.value(forKey: "entity_id") as! CVarArg)
                    let Str_Title = String(format: "%@", alert.value(forKey: "title") as! CVarArg)
                    
                    let banner = Banner(
                        title:Str_Title,
                        subtitle: String(format: "%@", alert.value(forKey: "message") as! CVarArg),
                        image: UIImage(named: "huntsman app logo"),
                        backgroundColor: UIColor.lightGray
                        )
                    {
                        print("banner tapped!")
                        let storyBoard: UIStoryboard  = UIStoryboard(name: "Main", bundle: nil)
                        let profilecop = PreferenceUtil.getProfileComplete()
                        if profilecop == "yes"
                            {
                        switch StrTypeId
                        {
                        case "1":
                            let profile = storyBoard.instantiateViewController(withIdentifier: "NewsFeed_DetailVC") as! NewsFeed_DetailVC
                            profile.NewsFeedId = StrEntityId
                            profile.BackNotification_Vc = "PushNotifcation"
                            let naviationcontroller =  UINavigationController(rootViewController: profile)
                            naviationcontroller.navigationBar.isHidden = true
                            // self.window?.rootViewController = naviationcontroller
                            if let window = self.window, let rootViewController = window.rootViewController {
                                var currentController = rootViewController
                                while let presentedController = currentController.presentedViewController {
                                    currentController = presentedController
                                }
                                currentController.present(naviationcontroller, animated: true, completion: nil)
                            }
                        case "2":
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
                            let profile = storyBoard.instantiateViewController(withIdentifier: "Trunk_DetailVC") as! Trunk_DetailVC
                            profile.TrunkId = StrEntityId
                            profile.BackNotification_Vc = "PushNotifcation"
                            let naviationcontroller =  UINavigationController(rootViewController: profile)
                            naviationcontroller.navigationBar.isHidden = true
                            if let window = self.window, let rootViewController = window.rootViewController {
                                var currentController = rootViewController
                                while let presentedController = currentController.presentedViewController {
                                    currentController = presentedController
                                }
                                currentController.present(naviationcontroller, animated: true, completion: nil)
                            }
                            
                        case "3":
                            let EventDetail = storyBoard.instantiateViewController(withIdentifier: "Event_DetailVC") as! Event_DetailVC
                            EventDetail.EventId = StrEntityId
                            EventDetail.BackNotification_Vc = "PushNotifcation"
                            let naviationcontroller =  UINavigationController(rootViewController: EventDetail)
                            naviationcontroller.navigationBar.isHidden = true
                            if let window = self.window, let rootViewController = window.rootViewController {
                                var currentController = rootViewController
                                while let presentedController = currentController.presentedViewController {
                                    currentController = presentedController
                                }
                                currentController.present(naviationcontroller, animated: true, completion: nil)
                            }
                            
                        case "4":
                            let RetailerDetail = storyBoard.instantiateViewController(withIdentifier: "Retailer_DetailVC") as! Retailer_DetailVC
                            RetailerDetail.RetailerId = StrEntityId
                            RetailerDetail.BackNotification_Vc = "PushNotifcation"
                            let naviationcontroller =  UINavigationController(rootViewController: RetailerDetail)
                            naviationcontroller.navigationBar.isHidden = true
                            if let window = self.window, let rootViewController = window.rootViewController {
                                var currentController = rootViewController
                                while let presentedController = currentController.presentedViewController {
                                    currentController = presentedController
                                }
                                currentController.present(naviationcontroller, animated: true, completion: nil)
                            }
                            
                        case "5":
                            
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let profile = storyBoard.instantiateViewController(withIdentifier: "Message_DetailVC") as! Message_DetailVC
                            profile.str_messageto = StrEntityId
                            profile.To_UserName = Str_Title
                            let naviationcontroller =  UINavigationController(rootViewController: profile)
                            naviationcontroller.navigationBar.isHidden = true

                            if let window = self.window, let rootViewController = window.rootViewController {
                                var currentController = rootViewController
                                while let presentedController = currentController.presentedViewController {
                                    currentController = presentedController
                                }
                                currentController.present(naviationcontroller, animated: true, completion: nil)
                            }
                            
                        case "6":
                            let WebView = storyBoard.instantiateViewController(withIdentifier: "Wardrobe_WebviewVC") as! Wardrobe_WebviewVC
                            WebView.Str_url = StrEntityId
                            WebView.BackNotification_Vc = "PushNotifcation"
                            let naviationcontroller =  UINavigationController(rootViewController: WebView)
                            naviationcontroller.navigationBar.isHidden = true
                            if let window = self.window, let rootViewController = window.rootViewController {
                                var currentController = rootViewController
                                while let presentedController = currentController.presentedViewController {
                                    currentController = presentedController
                                }
                                currentController.present(naviationcontroller, animated: true, completion: nil)
                            }
                            
                        case "7":
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
                            let profile = storyBoard.instantiateViewController(withIdentifier: "Admin_ChatVC") as! Admin_ChatVC
                            profile.Flage_PrivousVC = "wardrobe_admin"
                            profile.BackNotification_Vc = "PushNotifcation"
                            let naviationcontroller =  UINavigationController(rootViewController: profile)
                            naviationcontroller.navigationBar.isHidden = true
                            if let window = self.window, let rootViewController = window.rootViewController {
                                var currentController = rootViewController
                                while let presentedController = currentController.presentedViewController {
                                    currentController = presentedController
                                }
                                currentController.present(naviationcontroller, animated: true, completion: nil)
                            }
                            
                        case "8":
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
                            let profile = storyBoard.instantiateViewController(withIdentifier: "Admin_ChatVC") as! Admin_ChatVC
                            profile.Flage_PrivousVC = "trunkshow_admin"
                            profile.RequestBookingId = StrEntityId
                            profile.BackNotification_Vc = "PushNotifcation"
                            let naviationcontroller =  UINavigationController(rootViewController: profile)
                            naviationcontroller.navigationBar.isHidden = true
                            if let window = self.window, let rootViewController = window.rootViewController {
                                var currentController = rootViewController
                                while let presentedController = currentController.presentedViewController {
                                    currentController = presentedController
                                }
                                currentController.present(naviationcontroller, animated: true, completion: nil)
                            }
                            
                        case "9":
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Trunk", bundle: nil)
                            let profile = storyBoard.instantiateViewController(withIdentifier: "Admin_ChatVC") as! Admin_ChatVC
                            profile.Flage_PrivousVC = "wardrobe_admin"
                            profile.UserAdminChat = "User_AdminChat"
                            profile.BackNotification_Vc = "PushNotifcation"
                            
                            let naviationcontroller =  UINavigationController(rootViewController: profile)
                            naviationcontroller.navigationBar.isHidden = true
                            
                            if let window = self.window, let rootViewController = window.rootViewController {
                                var currentController = rootViewController
                                while let presentedController = currentController.presentedViewController {
                                    currentController = presentedController
                                }
                                currentController.present(naviationcontroller, animated: true, completion: nil)
                            }
                            
                        default:
                            print("No match")
                        }
                      }
                    }
                    banner.hasShadows = false
                    banner.show(duration: 2.0)
                }
            }
            completionHandler(.newData)
        }
    }

    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            self.saveContext()
        }
    }

    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Huntsman")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    @available(iOS 10.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

