//
//  WebserviceUtil.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 28/02/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import Foundation

class WebserviceUtil {
    
    //  Api Post method using URLSession
    class func callPost(jsonRequest url: String ,view :UIView , params: [String: Any]?, success: @escaping ((Any?)) -> Void ,failure: @escaping ((Error)->Void)) {
      
        
        print("url = \(url)")
        print("params = \(params)")
        
        if Reachability.isConnectedToNetwork(){
            
            print("Internet Connection Available!")
            let uploadUrl = URL(string: url)!
            print("url = \(uploadUrl)")
            let boundary: NSString = "----CustomFormBoundarycC4YiaUFwM44F6rT"
            let body: NSMutableData = NSMutableData()
            
            // parameters to send i.e. text
            if params!.count > 0 {
                let paramsArray = params?.keys
                for item in paramsArray! {
                    body.append(("--\(boundary)\r\n" as String).data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                    body.append("Content-Disposition: form-data; name=\"\(item)\"\r\n\r\n" .data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                    body.append("\(params![item]!)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
                }
            }
            
            
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            var request = URLRequest(url: uploadUrl)
            request.httpMethod = "POST"
            request.httpBody = body as Data
            request.timeoutInterval = 20
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            //    If required
            if  PreferenceUtil.getUser().token.isEmpty {
            } else {
                print("PreferenceUtil.getUser().token = \(PreferenceUtil.getUser().token)")
                request.addValue(PreferenceUtil.getUser().token, forHTTPHeaderField: URLConstant.Param.TOKEN_HEADER)
            }
            
            let config: URLSessionConfiguration = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 30.0
            config.timeoutIntervalForResource = 60.0
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: request) {data, response, _ in
                
                if response != nil && data != nil {
                    let str = String.init(data: data!, encoding: .utf8)
                    print("\(url)  str = \(String(format: "%@", str!))")
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] {
                            DispatchQueue.main.async {
                                print(json)
                                success(json)
                            }
                        }
                    } catch let parseError {
                        DispatchQueue.main.async {
                            failure(parseError)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                         failure(NSError(domain: "Huntsman", code: 503, userInfo: nil))
                      }
                    }
                 }
            task.resume()
        } else {
               DispatchQueue.main.async {
              failure(NSError(domain: "No Internet Connection", code: 503, userInfo: nil))
            }
        }
      
    }
//  Api get method using URLSession
    class func callGet(jsonRequest url: String,view:UIView, success: @escaping ((Any?)) -> Void ,failure: @escaping ((Error)->Void)) {
        
        print("url = \(url)")
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "GET"
           request.setValue(PreferenceUtil.getUser().token, forHTTPHeaderField: URLConstant.Param.TOKEN_HEADER)
            print(PreferenceUtil.getUser().token)
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                
                if response != nil && data != nil {
                    let str = String.init(data: data!, encoding: .utf8)
                    print(" \(url) str = \(String(format: "%@", str!))")
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                        print(json)
                        DispatchQueue.main.async {
                            success(json)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            failure(error)
                            failure(NSError(domain: "Huntsman", code: 503, userInfo: nil))

                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        failure(NSError(domain: "Huntsman", code: 503, userInfo: nil))
                    }
                }
            })
            
            task.resume()
        }else
        {
            
            if #available(iOS 10.0, *) {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let aVariable = appDelegate.IsApi_Appdelegate
                if aVariable == true
                {
                    appDelegate.IsApi_Appdelegate = false
                }
                else
                {
                     DispatchQueue.main.async {
                    failure(NSError(domain: "No Internet Connection", code: 503, userInfo: nil))
                    }
                }
            }
         }
     }
}

