//
//  Wardrobe_WebviewVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 25/05/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit
import WebKit

class Wardrobe_WebviewVC: UIViewController, WKUIDelegate,WKNavigationDelegate  {
    
    @IBOutlet weak var View_BgWEbview: UIView!
    
    var Str_url = ""
    var BackNotification_Vc = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        View_BgWEbview.addSubview(webView)
        
         [webView.topAnchor.constraint(equalTo: View_BgWEbview.topAnchor),
         webView.bottomAnchor.constraint(equalTo: View_BgWEbview.bottomAnchor),
         webView.leftAnchor.constraint(equalTo: View_BgWEbview.leftAnchor),
         webView.rightAnchor.constraint(equalTo: View_BgWEbview.rightAnchor)].forEach  { anchor in
            anchor.isActive = true
        }
        if let url = URL(string: Str_url) {
            webView.load(URLRequest(url: url))
        }
        // loder show
        LoderGifView.MyloaderShow(view: self.view)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished navigating to url")
        // loder hide
        LoderGifView.MyloaderHide(view: self.view)
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        print("webview did fail load with error: \(error)")
        LoderGifView.MyloaderHide(view: self.view)
    }
    
    // crossClick dismis VC
    @IBAction func crossClick(sender: AnyObject?){
        if BackNotification_Vc == "PushNotifcation" {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.rootview_views(string: "discover")
        } else
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

