# Web App

## WebKit

<img src="img/step1.png" width="50%"></img>

### WKWebView 추가
- !! 별 거 하지도 않았는데.. 다음 에러가 떠서 하얀화면만 나옴
- 해결: 아래 3개 메소드는 구현해줘야 함

```swift
func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
	decisionHandler(.allow)
}

func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
	decisionHandler(.allow)
}

func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
	completionHandler(.performDefaultHandling, nil)
}
```

### 웹에서 사이트 로딩 과정 디버깅
- Safari > Develop > Simulator 메뉴 활용
- 일부 요소값 변경해 봄

<img src="img/step2.png" width="100%"></img>

### 학습 내용
>- **[WKNavigationDelegate]()**
>- **[WebKitView vs. WebView]()**


<br/>

## 커스텀 페이지 로딩

<img src="img/step3.png" width="50%"></img>

### 앱에서만 팝업 제거하여 커스텀 로딩
- WKUserScript 유저 스크립트 클래스 활용: 자바스크립트 구현
- **단, 스크립트 생성 시 injectionTime을 페이지 로딩 후(.atDocumentEnd)로, forMainFrameOnly는 false로 지정해야 적용된다****.**

```swift
override func loadView() {
    super.loadView()
    let config = WKWebViewConfiguration()
    config.userContentController = WKUserContentController()
    let script = WKUserScript(source: Constant.js, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
    config.userContentController.addUserScript(script)
    webView = WKWebView(frame: .zero, configuration: config)
    self.view.addSubview(webView)
}
```