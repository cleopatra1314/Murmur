//
//  PopupViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/8/27.
//

import Foundation
import UIKit
import WebKit

class TermsOfServiceViewController: UIViewController {
    
    var termsOfServiceWebView: WKWebView?
    let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutWebView()
    }
    
    func layoutWebView() {
        
//        termsOfServiceWebView = WKWebView(frame: CGRect(x: 10, y: 10, width: fullScreenSize.width*0.8, height: fullScreenSize.height*0.8))
        termsOfServiceWebView = WKWebView(frame: self.view.frame)
        termsOfServiceWebView?.navigationDelegate = self
        
        if let url {
            let request = URLRequest(url: url)
            if let termsOfServiceWebView {
                termsOfServiceWebView.load(request)
                self.view.addSubview(termsOfServiceWebView)
                self.view.bringSubviewToFront(termsOfServiceWebView)
            }
        }
        
    }
    
}

extension TermsOfServiceViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    
    }
    
}
