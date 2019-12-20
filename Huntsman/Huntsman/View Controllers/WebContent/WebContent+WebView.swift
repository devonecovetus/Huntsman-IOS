//
//  WebContent+WebView.swift
//  Audit
//
//  Created by Rupesh Chhabra on 29/03/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

extension WebContentViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView){
       // LoderGifView.MyloaderShow(view: view)
        //print("webViewDidStartLoad")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        LoderGifView.MyloaderHide(view: self.view)
        //print("webViewDidFinishLoad")
    }
    
    func webView(_webView: UIWebView, didFailLoadWithError error: NSError) {
        LoderGifView.MyloaderHide(view: self.view)
        //print("webview did fail load with error: \(error)")
    }
}
