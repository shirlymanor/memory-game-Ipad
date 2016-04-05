//
//  WKWebViewController.swift
//  AppBrowsers
//
//  Created by Shirly Manor on 3/26/16.
//  Copyright © 2016 AF. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WKWebViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var progressIndicator: UIProgressView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    
    var reloadCancelButton : UIBarButtonItem?
    var urlString : String?
    var webview : WKWebView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // "Done" button to dismiss
        self.enableCustomBackButtom()
        
        // Reload/Cancel
        reloadCancelButton = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .Plain, target: self, action: #selector(WKWebViewController.tappedReloadCancelButton))
        navigationItem.setRightBarButtonItem(reloadCancelButton, animated: false)
        print("before subview")
        // Add webview as a subview
        
        progressIndicator.setProgress(0.0, animated: false)
        backButton.enabled = false
        forwardButton.enabled = false
        
        webview!.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webview!.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
        
        
        view.insertSubview(webview!, belowSubview: progressIndicator)
        print("after subview")
        // Adjust constraints
        webview!.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: webview!, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: -44)
        
        let widthConstraint = NSLayoutConstraint(item: webview!, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([heightConstraint, widthConstraint])
        
        // Load the URL
        if let urlString = urlString {
            webview!.loadRequest(NSURLRequest(URL: NSURL(string: urlString)!))
        }
        
        
        
    }
    deinit {
        webview!.removeObserver(self, forKeyPath: "loading")
        webview!.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        if (keyPath == "loading") {
            backButton.enabled = webview!.canGoBack
            forwardButton.enabled = webview!.canGoForward
            reloadCancelButton!.image = webview!.loading ? UIImage(named: "icon_stop") : UIImage(named: "icon_refresh")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = webview!.loading
            if (webview!.loading == false) {
                titleTextField.text = webview!.URL?.absoluteString
            }
        } else if (keyPath == "estimatedProgress") {
            progressIndicator.hidden = webview!.estimatedProgress == 1
            progressIndicator.setProgress(Float(webview!.estimatedProgress), animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func tappedBackButton(sender: AnyObject) {
    }
    
    @IBAction func tappedForwardButton(sender: AnyObject) {
    }
    
    
    func tappedReloadCancelButton() -> () {
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        titleTextField.frame = CGRect(x:0, y: 0, width: size.width, height: 30)
    }
    
}


extension UIViewController: UIGestureRecognizerDelegate {
    func didTapDone() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func enableCustomBackButtom() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: Selector("UIViewController.didTapDone"))
        
        // Do this so you don't break the swipe to go back gesture when customizing back button
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
    }
}
