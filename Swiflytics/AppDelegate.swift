//
//  AppDelegate.swift
//  Swiflytics
//
//  Created by Ankit Aggarwal on 15/01/16.
//  Copyright © 2016 ankit.im. All rights reserved.
//

import UIKit

let kGoogleAnalyticsScope = "https://www.googleapis.com/auth/analytics.readonly"
let kGoogleSigninAuthToggled = "GoogleSigninAuthToggled"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // Initialize google sign-in
        {
            var configureError: NSError?
            GGLContext.sharedInstance().configureWithError(&configureError)
            assert(configureError == nil, "Error configuring Google services: \(configureError)")
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().scopes.append(kGoogleAnalyticsScope)
        }()


        return true
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        let source: String = options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String
        return GIDSignIn.sharedInstance().handleURL(url, sourceApplication: source, annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }

    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error != nil) {
            print("\(error.localizedDescription)")
        }
        NSNotificationCenter.defaultCenter().postNotificationName(kGoogleSigninAuthToggled, object: nil)
    }

    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!, withError error: NSError!) {
        NSNotificationCenter.defaultCenter().postNotificationName(kGoogleSigninAuthToggled, object: nil)
    }
}

