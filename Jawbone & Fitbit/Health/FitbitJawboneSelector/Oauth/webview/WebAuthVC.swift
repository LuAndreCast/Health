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
    var urlRequest:NSURLRequest?
    var codeToSave:String = ""
    
    //MARK: View Loading
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }//eom
    
    override func viewDidAppear(animated: Bool)
    {
        let viewFrame = self.windowView.frame
        let webView = WKWebView(frame: viewFrame, configuration: WKWebViewConfiguration())
        webView.frame = self.windowView.frame
        webView.navigationDelegate = self
        self.view.addSubview(webView as WKWebView)
        webView.loadRequest(self.urlRequest!)
    }
    
    @IBAction func cancelPressed(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    //MARK: - UIWEBVIEW DELEGATE
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
    {
        print("Webview fail with error \(error)");
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void)
    {
        let urlRequest = navigationAction.request
        let absoluteURL = urlRequest.URL
        let absoluteString = absoluteURL?.absoluteString
        
        if (absoluteString!.localizedCaseInsensitiveContainsString("?code="))
        {
            // Return code to Jawbone instance to further OAuth processing.
            self.delegate = Jawbone.instance
            self.delegate?.receiveAuthCode(absoluteString!)
            self.dismissViewControllerAnimated(true, completion: {})
            // webview navigation action
            decisionHandler(.Cancel)
        } else {
            // webview navigation action
            decisionHandler(.Allow)
        }
    }
    
    // Error Handling method found from: http://www.appcoda.com/webkit-framework-intro/
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        webView.removeFromSuperview()
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    
    //MARK: Memory
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
