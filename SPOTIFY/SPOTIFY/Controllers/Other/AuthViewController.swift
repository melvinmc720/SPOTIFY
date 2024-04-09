//
//  AuthViewController.swift
//  SPOTIFY
//
//  Created by milad marandi on 1/13/24.
//

import UIKit
import WebKit

class AuthViewController: UIViewController , WKNavigationDelegate {
    
    private let SpotifyURL = URL(string: "https://accounts.spotify.com/en/login")
    public var CompletionHandler: ((Bool) -> Void)?
    
    private let webview:WKWebView = {
        let preference = WKWebpagePreferences()
        preference.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preference
        let webview = WKWebView(frame: .zero, configuration:configuration)
        return webview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.navigationDelegate = self
        guard let url = AuthManager.shared.SignInURL else{
            return
        }
        webview.load(URLRequest(url: url))
        view.addSubview(webview)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webview.bounds = view.bounds
        webview.center = view.center
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webview.url else {
            return
        }
        
        //exchange the token for RealToken
        guard let token = URLComponents(string: url.absoluteString)?.queryItems?.first(where: {$0.name == "code"})?.value else {
            print("you got an error here")
            return
        }
        print("real token: \(token)")
        AuthManager.shared.ExchangeCodeForToken(code: token, completion: { success in
            self.navigationController?.popToRootViewController(animated: true)
            self.CompletionHandler!(success)
            
        })
    }
    
}
