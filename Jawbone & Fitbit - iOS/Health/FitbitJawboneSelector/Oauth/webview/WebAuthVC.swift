//
//  WebAuthVC.swift
//  Health
//

import UIKit
import WebKit

class WebAuthVC: UIViewController, WKNavigationDelegate {
    
    //properties
   // @IBOutlet var containerView: UIView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var windowView: UIView!
    weak var navigationDelegate: WKNavigationDelegate?
    let preferences = WKPreferences()
    let configuration = WKWebViewConfiguration()
    //let appdelegate:UIApplicationDelegate? = UIApplication.sharedApplication().delegate
    var delegate:codeResponder?
    
    //Incoming
    var urlRequest:URLRequest?
    var codeToSave:String = ""
    
    //MARK: View Loading
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }//eom
    
    override func viewDidAppear(_ animated: Bool)
    {
        let viewFrame = self.windowView.frame
        let webView = WKWebView(frame: viewFrame, configuration: WKWebViewConfiguration())
        webView.frame = self.windowView.frame
        webView.navigationDelegate = self
        self.view.addSubview(webView as WKWebView)
        webView.load(self.urlRequest!)
    }
    
    @IBAction func cancelPressed(_ sender: AnyObject)
    {
        self.dismiss(animated: true, completion: {})
    }
    //MARK: - UIWEBVIEW DELEGATE
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: NSError?)
    {
        print("Webview fail with error \(error)");
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        let urlRequest = navigationAction.request
        let absoluteURL = urlRequest.url
        let absoluteString = absoluteURL?.absoluteString
        
        if (absoluteString!.localizedCaseInsensitiveContains("?code="))
        {
            // Return code to Jawbone instance to further OAuth processing.
            self.delegate = Jawbone.instance
            self.delegate?.receiveAuthCode(absoluteString!)
            self.dismiss(animated: true, completion: {})
            // webview navigation action
            decisionHandler(.cancel)
        } else {
            // webview navigation action
            decisionHandler(.allow)
        }
    }
    
    // Error Handling method found from: http://www.appcoda.com/webkit-framework-intro/
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        webView.removeFromSuperview()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    //MARK: Memory
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
