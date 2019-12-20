//
//  WebContentViewController.swift
//  Audit
//
//  Created by Rupesh Chhabra on 25/10/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class WebContentViewController: UIViewController {
    //MARK: Outlets & Variables:
    var strLinkType: String?
    var strTitle: String?
    @IBOutlet weak var webView_Content: UIWebView?
    @IBOutlet weak var lbl_Title: UILabel?

    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
     
        lbl_Title?.text = strTitle
        LoderGifView.MyloaderShow(view: view)
        if strTitle == "Terms & Conditions" {
            strLinkType = "https://www.huntsmansavilerow.com/the-company/legal/"
        } else {
            strLinkType = "https://www.huntsmansavilerow.com/the-company/privacy-cookie-policy/"
        }
        webView_Content?.loadRequest(URLRequest(url: URL(string: strLinkType!)!))
        if (strLinkType?.count)! > 0 {
            // webView_Content.loadHTMLString(strLinkType!, baseURL: nil)
            //print("strLinkType - \(strLinkType)")
            
        }
    }
    
    //MARK: Button Actions:
    @IBAction func btn_Back(_ sender: Any) {
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        webView_Content?.delegate = nil
        webView_Content = nil
     
        self.navigationController?.popViewController(animated: true)
    }
    
}


