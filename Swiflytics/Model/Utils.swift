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