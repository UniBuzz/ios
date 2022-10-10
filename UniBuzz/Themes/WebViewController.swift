//
//  WebViewController.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 10/10/22.
//


import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    //MARK: - Properties
    var webView: WKWebView!
    var link = "https://www.google.com"
    
    //MARK: - Lifecycle
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: - Lifecycle
    func configureUI() {
        guard let url = URL(string: link) else {return}
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
