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

    private var webView = WKWebView()
    private let url = URL(string: "https://m.baeminchan.com")!

    // MARK:- Life Cycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(webView)
        self.view.setNeedsUpdateConstraints() // updateViewConstraints() 강제호출 -> 오토레이아웃 초기화

        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
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

    private var didUpdateViewConstraints = false

    override func updateViewConstraints() {
        // 최초 한 번만 업데이트
        if !didUpdateViewConstraints {
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            didUpdateViewConstraints = true
        }
        super.updateViewConstraints()
    }


}

