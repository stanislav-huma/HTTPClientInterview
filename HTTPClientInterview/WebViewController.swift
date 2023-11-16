//
//  WebViewController.swift
//  HTTPClientInterview
//
//  Created by Ash Censo on 16.11.2023.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView?
    
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: url) {
            webView?.load(URLRequest(url: url))
        }
    }
}
