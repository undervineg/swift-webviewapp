//
//  ViewController.swift
//  WebviewApp
//
//  Created by 심 승민 on 2018. 6. 18..
//  Copyright © 2018년 심 승민. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class ViewController: UIViewController, WKNavigationDelegate {

    private weak var webView: WKWebView!

    struct Constant {
        static let jsFileName = "JSInjection"
        static let jsType = "js"
        static let jsEventName = "slideNavi"
    }

    enum RequestPath: String {
        case main = "https://m.baeminchan.com"
        case search = "/search.php"
    }


    // MARK:- Life Cycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    override func loadView() {
        super.loadView()
        setupWebView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsUpdateConstraints()

        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: RequestPath.main.rawValue)!))
    }


    // MARK:- WKNavigationDelegate

    // 1 - 페이지 로딩 시 링크 이벤트
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if navigationAction.navigationType == .linkActivated, let url = navigationAction.request.url {
            decisionHandler(.cancel)
            switch url.path {
            case RequestPath.search.rawValue: presentSafariViewController(url)
            default: break
            }
        } else {
            decisionHandler(.allow)
        }

    }

    private func presentSafariViewController(_ url: URL) {
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = true
        let safariController = SFSafariViewController(url: url, configuration: config)
        safariController.delegate = self
        self.present(safariController, animated: true, completion: nil)
    }

    // 2
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

    }

    // 3
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        completionHandler(.performDefaultHandling, nil)
    }

    // 4 - 쿠키 세팅을 통한 세션 유지
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        decisionHandler(.allow)
    }

    // 5 - 페이지 로딩 시
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {

    }

    // 6 - 페이지 로딩 완료 이벤트, 최근 세션시간 저장
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

    }


    // MARK:- UI

    private func setupWebView() {
        guard
            let bundle = Bundle.main.path(forResource: Constant.jsFileName, ofType: Constant.jsType),
            let content = try? String(contentsOfFile: bundle, encoding: .utf8) else { return }
        let config = WKWebViewConfiguration()
        config.userContentController = WKUserContentController()
        let script = WKUserScript(source: content, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        config.userContentController.addUserScript(script)
        config.userContentController.add(self, name: Constant.jsEventName)
        webView = WKWebView(frame: .zero, configuration: config)
        self.view.addSubview(webView)
    }

    private var hasLoadedConstraints = false

    override func updateViewConstraints() {
        // 최초 한 번만 업데이트
        if !hasLoadedConstraints {
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            hasLoadedConstraints = true
        }
        super.updateViewConstraints()
    }


}

extension ViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == Constant.jsEventName {
            if let body = message.body as? String,
                let jsonObject = body.parseToJSON() {
                print("Message from JS: ", jsonObject)
            }
        }
    }

}

extension String {
    func parseToJSON() -> Any? {
        var result: Any?
        if let data = self.data(using: .utf8, allowLossyConversion: false) {
            do {
                result = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            } catch {
                print(error)
            }
        }
        return result
    }
}
