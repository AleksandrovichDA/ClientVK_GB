//
//  LoginFormController.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 14.09.17.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit
import WebKit
import FirebaseAuth
import FirebaseDatabase

class LoginFormController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    let vkService = VKService()
    var requestHandle : DatabaseHandle?
    
    @IBOutlet weak var webview: WKWebView! {
        didSet{
            webview.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: String(Configuration.shared.clientID)),
            URLQueryItem(name: "display", value: Configuration.shared.displayMode),
            URLQueryItem(name: "redirect_uri", value: Configuration.shared.redirectURI),
            URLQueryItem(name: "scope", value: String(Configuration.shared.scope)),
            URLQueryItem(name: "response_type", value: Configuration.shared.responseType),
            URLQueryItem(name: "v", value: Configuration.shared.versionAPI)
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        //request.httpShouldHandleCookies = false
        webview.load(request)
    }
}

extension LoginFormController: WKNavigationDelegate {
    
    func checkUserData() {
        //* Фейковая авторизация для Firebase
        let login = "DENIS@MAIL.RU"
        let password = "DENIS"
        Auth.auth().signIn(withEmail: login, password: password)
        
        //* Запись логов входа
        let dbLink = Database.database().reference()
        let userLogin = UserLogin(String(VKService.userId))
        dbLink.child("UserLogin").updateChildValues([userLogin.id: userLogin.toAnyObject])
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        VKService.userId = Int(params["user_id"]!)!
        let token = params["access_token"]
        decisionHandler(.allow)
        print("Токен \(token)")
        checkUserData()
        VKService.token = (token)!
        self.userDefaults.set(token, forKey: "token")
        
        UserDefaults.init(suiteName: "group.lastNews")?.setValue(token, forKey: "token")
        
        self.performSegue(withIdentifier: "firstWindow", sender: nil)
    }
}
