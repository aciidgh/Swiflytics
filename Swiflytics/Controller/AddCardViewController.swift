//
//  AddCardViewController.swift
//  Swiflytics
//
//  Created by Ankit Aggarwal on 16/01/16.
//  Copyright © 2016 ankit.im. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController, StoryboardInstantiable {
    
    typealias ViewController = AddCardViewController
    static let storyboardID = "AddCardViewControllerID"
 
    @IBOutlet var dimensionButton: UIButton!
    @IBOutlet var metricButton: UIButton!
    @IBOutlet var dimensionLabel: UILabel!
    @IBOutlet var metricLabel: UILabel!
    @IBOutlet var cardNameField: UITextField!
    
    var metric: AnalyticsMetric? {
        didSet {
            self.updateView()
        }
    }
    var dimension: AnalyticsDimension? {
        didSet {
            self.updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    func updateView() {
        
        if let dimension = dimension {
            self.dimensionLabel.text = dimension.rawValue
        }
        
        if let metric = metric {
            self.metricLabel.text = metric.rawValue
        }
    }

    @IBAction func dimensionButtonPressed(sender: AnyObject?) {
        let controller = UIAlertController(title: "Select Dimension", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for x in AnalyticsDimension.allValues() {
            let action = UIAlertAction(title: x.rawValue, style: .Default, handler: { action in
                self.dimension = x
            })
            controller.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        controller.addAction(cancelAction)
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func metricButtonPressed(sender: AnyObject?) {
        let controller = UIAlertController(title: "Select Metric", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for x in AnalyticsMetric.allValues() {
            let action = UIAlertAction(title: x.rawValue, style: .Default, handler: { action in
                self.metric = x
            })
            controller.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        controller.addAction(cancelAction)
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject?) {
        
        guard let cardName = self.cardNameField.text where cardName.characters.count > 0 else {
            showAlertWithText("Enter name of the card", onViewController: self)
            return
        }
        
        guard let metric = self.metric else {
            showAlertWithText("Select a metric", onViewController: self)
            return
        }
        
        guard let dimension = self.dimension else {
            showAlertWithText("Select a dimension", onViewController: self)
            return
        }
        
        let card = AnalyticsCard(cardName: cardName, dimension: dimension, metric: metric)
        CardManager.sharedManager.addCard(card)
        navigationController?.popViewControllerAnimated(true)
    }
}
