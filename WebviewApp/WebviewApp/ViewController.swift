//
//  ViewController.swift
//  WebviewApp
//
//  Created by 심 승민 on 2018. 6. 18..
//  Copyright © 2018년 심 승민. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    private var webView: WKWebView!

    struct Constant {
        static let urlString = "https://m.baeminchan.com"
        static let js
            = "var p = document.querySelector('.app-download-popup'); if(p != null) { p.style.display = 'none'; }"
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
        let config = WKWebViewConfiguration()
        config.userContentController = WKUserContentController()
        let script = WKUserScript(source: Constant.js, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        config.userContentController.addUserScript(script)
        webView = WKWebView(frame: .zero, configuration: config)
        self.view.addSubview(webView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsUpdateConstraints() // updateViewConstraints() 강제호출 -> 오토레이아웃 초기화

        webView.navigationDelegate = self
        let urlRequest = URLRequest(url: URL(string: Constant.urlString)!)
        webView.load(urlRequest)
    }


    // MARK:- WKNavigationDelegate

    // 1 - 페이지 로딩 시 링크 이벤트
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        decisionHandler(.allow)
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

