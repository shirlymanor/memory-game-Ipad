
//  ViewController.swift
//  AppBrowsers
//
//  Created by Shirly Manor on 3/26/16.
//  Copyright © 2016 AF. All rights reserved.
//

import UIKit
import SafariServices


class ViewController: UIViewController {
    
    @IBOutlet weak var urlTextField: UITextField!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        urlTextField.text = "https://s3-us-west-2.amazonaws.com/shirlymanor/PRMemoryGame/index.html"
        let svc = SFSafariViewController(URL: NSURL(string: urlTextField.text!)!)
        presentViewController(svc, animated: true) {
            let width: CGFloat = 66
            let x: CGFloat = self.view.frame.width - width
            
            // It can be any overlay. May be your logo image here inside an imageView.
            let overlay = UIView(frame: CGRect(x: x, y: 20, width: width, height: 44))
            overlay.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            svc.view.addSubview(overlay)
            //Try to hide the address bar
            svc.navigationController?.setToolbarItems(svc.toolbarItems, animated: false)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func openWithSafariVC(sender: AnyObject) {
        let svc = SFSafariViewController(URL: NSURL(string: urlTextField.text!)!)
        presentViewController(svc, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "openWithWebVC" {
            let webVC = segue.destinationViewController as! WKWebViewController
            webVC.urlString = urlTextField.text
            print(urlTextField.text)
        }
        
    }
    
    
}

