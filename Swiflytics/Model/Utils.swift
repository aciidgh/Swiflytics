//
//  Utils.swift
//  Swiflytics
//
//  Created by Ankit Aggarwal on 15/01/16.
//  Copyright © 2016 ankit.im. All rights reserved.
//

protocol StoryboardInstantiable {
    typealias ViewController
    static var storyboardID: String { get }
    static func instance(storyboard: UIStoryboard) ->ViewController?
}

extension StoryboardInstantiable {
    static func instance(storyboard: UIStoryboard) -> ViewController? {
        return storyboard.instantiateViewControllerWithIdentifier(Self.storyboardID) as? ViewController
    }
}

func onMainThread(closure: () -> ()) {
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        closure()
    })
}

func showAlertWithText(text: String, onViewController vc: UIViewController) {
    let controller = UIAlertController(title: "Oops", message: text, preferredStyle: UIAlertControllerStyle.Alert)
    let cancelAction = UIAlertAction(title: "Okay", style: .Cancel, handler: nil)
    controller.addAction(cancelAction)
    vc.presentViewController(controller, animated: true, completion: nil)
}