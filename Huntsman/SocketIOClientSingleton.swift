//
//  SocketIOClientSingleton.swift
//  socket.io_chat_swift
//
//  Created by Nguyen Bon on 12/24/15.
//  Copyright © 2015 SmartDev LLC. All rights reserved.
//


import Foundation
import SocketIO

public class SocketIOClientSingleton  {
    
    static let instance = SocketIOClientSingleton()
    var socket:SocketIOClient!
    private init() {
        self.socket = SocketIOClient(socketURL: NSURL(string: "https://chat.huntsmansavilerow.com")!  as URL)
        //http://chat.huntsmansavilerow.com
       //  self.socket = SocketIOClient(socketURL: NSURL(string: "http://chat.clubappadmin.huntsmansavilerow.com")!  as URL)
        //self.socket = SocketIOClient(socketURL: NSURL(string: "http://chat.huntsmansavilerow.com")!  as URL)
     //   self.socket  = SocketIOClient(socketURL: URL(string: "https://chat.huntsmansavilerow.com")!, config: [.log(false), .forceWebsockets(true)])
        
         //self.socket = SocketIOClient(socketURL: URL(string: "http://chat.huntsmansavilerow.com")!, config: [.log(false), .compress])
        
       // self.socket = SocketIOClient(socketURL: URL(string: "https://chat.huntsmansavilerow.com")!, config: [.log(false), .compress, .connectParams(["token": "asdasdasdsa"])])
        
        

    }

}

