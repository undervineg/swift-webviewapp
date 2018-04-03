//
//  ViewController.swift
//  WebViewApp
//
//  Created by TaeHyeonLee on 2018. 3. 30..
//  Copyright © 2018년 ChocOZerO. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class ViewController: UIViewController, WKNavigationDelegate, SFSafariViewControllerDelegate {

    private weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard setWebView() else { return }
        guard let url = URL(string: "https://m.baeminchan.com") else { return }
        let urlRequest = URLRequest(url: url)
        self.webView.load(urlRequest)
    }

    private func setWebView() -> Bool {
        let webConfiguration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        guard let jsFile = Bundle.main.path(forResource: "Injection", ofType: "js") else { return false }
        guard let jsString = try? String(contentsOfFile: jsFile, encoding: String.Encoding.utf8) else { return false }
        let userScript = WKUserScript(source: jsString, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        contentController.addUserScript(userScript)
        webConfiguration.userContentController = contentController
        webView = WKWebView(frame: view.frame, configuration: webConfiguration)
        webView.navigationDelegate = self
        view.addSubview(webView)
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.description.contains("search.php") {
            let webVC = SFSafariViewController(url: navigationAction.request.url!)
            webVC.delegate = self
            self.present(webVC, animated: true, completion: nil)
        }
        decisionHandler(.allow)
    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

}

