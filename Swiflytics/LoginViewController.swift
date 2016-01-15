//
//  LoginViewController.swift
//  Swiflytics
//
//  Created by Ankit Aggarwal on 15/01/16.
//  Copyright © 2016 ankit.im. All rights reserved.
//

import UIKit

@objc class LoginViewController: UIViewController, GIDSignInUIDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveToggleAuthUINotification:", name: kGoogleSigninAuthToggled, object: nil)
    }

    @IBAction func connectTapped(sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kGoogleSigninAuthToggled, object: nil)
    }

    @objc func receiveToggleAuthUINotification(notification: NSNotification) {
        guard notification.name == kGoogleSigninAuthToggled else {
            return
        }

        guard let user = GIDSignIn.sharedInstance().currentUser else {
            print("Auth failed")
            return
        }
        print("auth success \(user)")
    }
}

