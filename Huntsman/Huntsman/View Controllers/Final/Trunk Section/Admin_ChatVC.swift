//
//  Admin_ChatVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 08/05/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import SocketIO
class Admin_ChatVC: UIViewController,InputbarDelegate {
    
    var Flage_PrivousVC = ""
    var RequestBookingId = ""
    var UserAdminChat = ""

    private  var socket:SocketIOClient?
  
    @IBOutlet weak var tableview: UITableView!
    
    var Message_Array = [] as NSMutableArray
    
    @IBOutlet weak var inputbar: Inputbar!
    
    var ApiTimer: Timer!
    var BackNotification_Vc = ""

    override func viewDidLoad() {
        super.viewDidLoad()
      //  socket?.off("connect")
        tableview.estimatedRowHeight = 65
        tableview.rowHeight = UITableViewAutomaticDimension
        
        self.inputbar.placeholder = nil
        self.inputbar.delegate = self
        self.inputbar.rightButtonImage = (UIImage(named: "send"))
        
        NotificationCenter.default.addObserver(self, selector: #selector(Message_DetailVC.ReceivedNotification), name: NSNotification.Name(rawValue: "KeyboarkUpDwon"), object: nil)
        // SocketIOClientSingleton socket server url
        socket = SocketIOClientSingleton.instance.socket
        socket?.connect()
        print("socket config= \(socket?.config)")
        print("RequestBookingId = \(RequestBookingId)")
       // socket event
        LoderGifView.MyloaderShow(view: self.view)
        socket?.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            let  UserId = PreferenceUtil.getUser().id
            self.socket?.emit("load id", UserId)
            self.GotconnectionAdminTrunk()
        }
        
        socket?.on(clientEvent: .disconnect) {data, ack in
           
            print("socket disconnect Reconnect")
            self.socket?.connect()
            let  UserId = PreferenceUtil.getUser().id
            self.socket?.emit("load id", UserId)
            
           // self.GotconnectionAdminTrunk()
        }
        socket?.on(clientEvent: .reconnectAttempt) {data, ack in
            print("socket reconnectAttempt")
            LoderGifView.MyloaderHide(view: self.view)
            self.socket?.reconnects = true
        }
       
        self.socket?.forceNew = true
        if socket?.status == .connected {
            print( "Your connection admin connected")
            self.GotconnectionAdminTrunk()
        }
        socket?.connect()
    }
    
    func GotconnectionAdminTrunk() {
        
        let  UserId = PreferenceUtil.getUser().id
        //   for wardrobe admin chat
        if Flage_PrivousVC == "wardrobe_admin"  {
            
            socket?.off("get past chats")
            socket?.off("chat message")
            
            if UserAdminChat == "User_AdminChat"
            {
                socket?.emit("get past chats", UserId, "Admin" , "1" )
            }
            else
            {
                socket?.emit("get past chats", UserId, "wardrobe_admin" , "1" )
            }
            socket?.on("get past chats") {data, ack in
                let jsonText = data[0] as! NSString
                var dictonary:NSDictionary?
                
                if let data = jsonText.data(using: String.Encoding.utf8.rawValue) {
                    
                    do {
                        dictonary = try ((JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary))
                        if let myDictionary = dictonary
                        {
                            print(" Socket response \(myDictionary["chats"]!)")
                            let tempNames: NSArray = (myDictionary["chats"] as? NSArray)!
                            self.Message_Array = (tempNames.mutableCopy() as? NSMutableArray)!
                            self.tableview.reloadData()
                            if self.Message_Array.count == 0
                            {
                            }
                            else
                            {
                                let indexPath = IndexPath(row: self.Message_Array.count - 1, section: 0)
                                self.tableview.scrollToRow(at: indexPath, at: .bottom, animated: false)
                            }
                        }
                        LoderGifView.MyloaderHide(view: self.view)
                    } catch let error as NSError {
                        print(error)
                        LoderGifView.MyloaderHide(view: self.view)
                    }
                }
            }
            
            socket?.on("chat message") {data, ack in
                let jsonText = data[1] as! NSString
                var dictonary:NSDictionary?
                if let data = jsonText.data(using: String.Encoding.utf8.rawValue) {
                    do {
                        dictonary = try ((JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary))
                        if let myDictionary = dictonary
                        {
                            let tempNames: NSArray = (myDictionary["response"] as? NSArray)!
                            let chat_mutablearray   = (tempNames.mutableCopy() as? NSMutableArray)!
                            let list = chat_mutablearray[0] as! NSDictionary
                            
                            let ToId = (list as AnyObject).value(forKey: "from") as? String
                            let msg = (list as AnyObject).value(forKey: "msg") as? String
                            if msg == ""
                            {}
                            else{
                                let  UserId = PreferenceUtil.getUser().id
                                let numuserid = UserId as NSNumber
                                let Str_userId : String = numuserid.stringValue
                                if ToId == Str_userId
                                {
                                }
                                else
                                {
                                    if self.Flage_PrivousVC == ToId  ||  ToId == "Admin"
                                    {
                                        self.addReciveMessage(ToId: ToId, message: msg)
                                    }
                                    
                                }
                            }
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
        }
    // for  trunk request booking chat individual
        else if Flage_PrivousVC == "trunkshow_admin"
        {
            socket?.off("get past chats trunk")
            socket?.off("chat message trunk")

            socket?.emit("get past chats trunk", UserId, "trunkshow_admin",RequestBookingId, "1" )
            socket?.on("get past chats trunk") {data, ack in
                let jsonText = data[0] as! NSString
                var dictonary:NSDictionary?
                
                if let data = jsonText.data(using: String.Encoding.utf8.rawValue) {
                    
                    do {
                        dictonary = try ((JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary))
                        if let myDictionary = dictonary
                        {
                            print(" Socket response \(myDictionary["chats"]!)")
                            let tempNames: NSArray = (myDictionary["chats"] as? NSArray)!
                            self.Message_Array   = (tempNames.mutableCopy() as? NSMutableArray)!
                            self.tableview.reloadData()
                            if self.Message_Array.count == 0
                            {
                            }
                            else
                            {
                                let indexPath = IndexPath(row: self.Message_Array.count - 1, section: 0)
                                self.tableview.scrollToRow(at: indexPath, at: .bottom, animated: false)
                            }
                           LoderGifView.MyloaderHide(view: self.view)
                        }
                    } catch let error as NSError {
                        print(error)
                         LoderGifView.MyloaderHide(view: self.view)
                    }
                }
            }
            socket?.on("chat message trunk") {data, ack in
                
                let jsonText = data[1] as! NSString
                var dictonary:NSDictionary?
                
                if let data = jsonText.data(using: String.Encoding.utf8.rawValue) {
                    
                    do {
                        dictonary = try ((JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary))
                        if let myDictionary = dictonary
                        {
                            let tempNames: NSArray = (myDictionary["response"] as? NSArray)!
                            let chat_mutablearray   = (tempNames.mutableCopy() as? NSMutableArray)!
                            let list = chat_mutablearray[0] as! NSDictionary
                            
                            let ToId = (list as AnyObject).value(forKey: "from") as? String
                            let msg = (list as AnyObject).value(forKey: "msg") as? String
                            let RequestId = (list as AnyObject).value(forKey: "request_id") as? String
                            if msg == ""
                            {}
                            else{
                                let  UserId = PreferenceUtil.getUser().id
                                let numuserid = UserId as NSNumber
                                let Str_userId : String = numuserid.stringValue
                                if ToId == Str_userId
                                {
                                }
                                else
                                {
                                    if RequestId == self.RequestBookingId
                                    {
                                        self.addReciveMessage(ToId: ToId, message: msg)
                                    }
                                }
                            }
                            print("toid  \(String(describing: ToId)) ;;; Msg \(String(describing: msg)) ... reuestid \(String(describing: RequestId))")
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
        }
    }
    private func addReciveMessage(ToId:String?, message:String?) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentdate = formatter.string(from: date)
        let JsonSendToSocket: [String: AnyObject] = [
            "from": ToId as AnyObject,
            "from_name": ToId as AnyObject,
            "msg": message as AnyObject,
            "msgtime": currentdate as AnyObject
        ]
        self.Message_Array.add(JsonSendToSocket)
        scrollToBottom()
    }
    
    @objc func ReceivedNotification(notification: NSNotification)
    {
        let myDict = notification.userInfo
        
        let KeybordType = (myDict! ["someKey"] as? String)!
        
        if KeybordType == "KeyboarUp" {
            
            let height = (myDict! ["height"] as? String)!
            
            var height_float = Float(0.0)
            if Device.IS_IPHONE_5
            {
                height_float = Float(height) - 14
            }
            else{
                height_float = Float(height) - 44
            }
            tableview.contentInset = UIEdgeInsetsMake(0, 0, CGFloat(height_float), 0)
            if self.Message_Array.count == 0
            {}
            else
            {
                let indexPath = IndexPath(row: self.Message_Array.count - 1, section: 0)
                tableview.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        } else
        {
            tableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            if self.Message_Array.count == 0
            {}
            else
            {
                let indexPath = IndexPath(row: self.Message_Array.count - 1, section: 0)
                tableview.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func inputbarDidPressRightButton(_ inputbar2: Inputbar!) {
        self.view.endEditing(true)
        let  LoginUsername = PreferenceUtil.getUser().name
        
        let  UserId = PreferenceUtil.getUser().id
        let xNSNumber = UserId as NSNumber
        let Str_userId : String = xNSNumber.stringValue
        
        let message = inputbar2.text
        if !message()!.isEmpty {
            if Flage_PrivousVC == "wardrobe_admin"  {
                let JsonSendToSocket: [String: AnyObject] = [
                    "yname": Str_userId as AnyObject,
                    "msg": message() as AnyObject,
                    "from_name": LoginUsername as AnyObject,
                    "to_name": "Huntsman" as AnyObject
                ]
                addMessage(LoginUserid: Str_userId, message: message())
                
                if UserAdminChat == "User_AdminChat"
                {
                    socket?.emit("chat message","Admin" ,JsonSendToSocket)
                }
                else
                {
                    socket?.emit("chat message","wardrobe_admin" ,JsonSendToSocket)
                }
            }
            else if Flage_PrivousVC == "trunkshow_admin"
            {
                let JsonSendToSocket: [String: AnyObject] = [
                    "yname": Str_userId as AnyObject,
                    "msg": message() as AnyObject,
                    "from_name": LoginUsername as AnyObject,
                    "trunk_id": RequestBookingId as AnyObject,
                    "to_name": "Huntsman" as AnyObject
                ]
                addMessage(LoginUserid: Str_userId, message: message())
                socket?.emit("chat message trunk","trunkshow_admin" ,JsonSendToSocket)
            }
            else
            {
                
            }
        }
    }
    //  For Add message local function
    private func addMessage(LoginUserid:String?, message:String?) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentdate = formatter.string(from: date)
        
        let  LoginUsername = PreferenceUtil.getUser().name
        
        let JsonSendToSocket: [String: AnyObject] = [
            "from": LoginUserid as AnyObject,
            "from_name": LoginUsername as AnyObject,
            "msg": message as AnyObject,
            "msgtime": currentdate as AnyObject
        ]
        self.Message_Array.add(JsonSendToSocket)
        
        scrollToBottom()
    }
    
    private func scrollToBottom() {
        let indexPath = IndexPath(row: (self.Message_Array.count) - 1, section: 0)
        tableview.beginUpdates()
        tableview.insertRows(at: [indexPath], with: UITableViewRowAnimation.none)
        tableview.endUpdates()
        self.tableview.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    func inputbarDidPressLeftButton(_ inputbar: Inputbar!) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        self.view.keyboardTriggerOffset = self.inputbar.frame.size.height
        
        self.view.addKeyboardPanning { (keyboardFrameInView: CGRect, opening: Bool, closing: Bool) in
            
            var toolBarFrame:CGRect = self.inputbar.frame
            toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height
            self.inputbar.frame = toolBarFrame
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        self.view.endEditing(true)
        self.view.removeKeyboardControl()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func crossClick(sender: AnyObject?)
    {
        if BackNotification_Vc == "PushNotifcation" {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.rootview_views(string: "discover")
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension Admin_ChatVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Message_Array.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  list = Message_Array[indexPath.row] as! NSDictionary
        let FromId   = ((list as AnyObject).value(forKey: "from") as? String)!
        
        let  userId = PreferenceUtil.getUser().id
        let Str_UserId = String(userId)
        
        if ((FromId == Str_UserId))
        {
            let cellright = tableview.dequeueReusableCell(withIdentifier: "RightChat_Cell", for: indexPath) as! RightChat_Cell
            cellright.Lbl_RightChatText.text =  ((list as AnyObject).value(forKey: "msg") as? String)!
            let string = ((list as AnyObject).value(forKey: "msgtime") as? String)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if dateFormatter.date(from: string) != nil
            {
                let date = dateFormatter.date(from: string)!
                dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm a"
                cellright.Lbl_RightDate.text = dateFormatter.string(from: date)
            }
            else
            {
                cellright.Lbl_RightDate.text = ""
            }
            let image = UIImage(named: "red bubble")
            cellright.img_red.image = image?
                .resizableImage(withCapInsets:
                    UIEdgeInsetsMake(11, 12, 11, 12),
                                resizingMode: .stretch)
                .withRenderingMode(.alwaysTemplate)
            
            cellright.img_red.tintColor = UIColor(red: 138/255.0,
                                                  green: 34/255.0,
                                                  blue: 52/255.0,
                                                  alpha: 1.0)
            return cellright
            
        } else {
            let cell = tableview.dequeueReusableCell(withIdentifier: "ChatLeft_Cell", for: indexPath) as! ChatLeft_Cell
            
            cell.Lbl_LeftChatText.text =  ((list as AnyObject).value(forKey: "msg") as? String)!
            
            let string = ((list as AnyObject).value(forKey: "msgtime") as? String)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if dateFormatter.date(from: string) != nil
            {
                let date = dateFormatter.date(from: string)!
                dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm a"
                cell.Lbl_leftDate.text = dateFormatter.string(from: date)
            }
            else
            {
                cell.Lbl_leftDate.text = ""
            }
            
            let image = UIImage(named: "grey bubble")
            cell.img_grey.image = image?
                .resizableImage(withCapInsets:
                    UIEdgeInsetsMake(11, 12, 11, 12),
                                resizingMode: .stretch)
                .withRenderingMode(.alwaysTemplate)
            cell.img_grey.tintColor = UIColor(red: 87/255.0,
                                              green: 87/255.0,
                                              blue: 91/255.0,
                                              alpha: 1.0)
            return cell
        }
    }
}
