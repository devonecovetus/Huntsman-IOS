//
//  Wardrobe_WebviewVC.swift
//  Huntsman
//
//  Created by Rupesh Chhabra on 25/05/18.
//  Copyright © 2018 covetus llc. All rights reserved.
//

import UIKit

class Wardrobe_WebviewVC: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    var Str_url = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL (string:Str_url )
        let requestObj = URLRequest(url: url!)
        webView.loadRequest(requestObj)
    }

    @IBAction func crossClick(sender: AnyObject?){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
