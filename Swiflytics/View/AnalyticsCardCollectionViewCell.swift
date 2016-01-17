//
//  AnalyticsCardCollectionViewCell.swift
//  Swiflytics
//
//  Created by Ankit Aggarwal on 16/01/16.
//  Copyright © 2016 ankit.im. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }
}

protocol AnalyticsCardDelegate: NSObjectProtocol {
    func didPressRemoveCard(card: AnalyticsCard)
}

class AnalyticsCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet var cardTitle: UILabel!
    @IBOutlet var cardTitleContainer: UIView!
    @IBOutlet var dataTableView: UITableView!
    
    var card: AnalyticsCard!
    weak var delegate: AnalyticsCardDelegate?
    
    var gaAnalytics: GAAnalytics? {
        didSet {
            self.dataTableView.reloadData()
        }
    }
    
    @IBAction func removeCard(sender: AnyObject) {
        delegate?.didPressRemoveCard(card)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layerSetup()
    }
    
    override func layoutSubviews() {
        addCornerRadiusToContainer()
        super.layoutSubviews()
    }
    
    func addCornerRadiusToContainer() {
        cardTitleContainer.roundCorners([.TopLeft , .BottomRight], radius: 4)
    }
    
    func layerSetup() {
        layer.cornerRadius = 4
        layer.shadowColor = UIColor(white: 0, alpha: 0.2).CGColor
        layer.shadowOffset = CGSizeMake(1, 1);
        layer.shadowRadius = 2;
        layer.shadowOpacity = 1;
    }
}

extension AnalyticsCardCollectionViewCell: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gaAnalytics = gaAnalytics else { return 0 }
        return gaAnalytics.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(AnalyticsCardDataTableViewCell), forIndexPath: indexPath) as! AnalyticsCardDataTableViewCell
        guard let gaAnalytics = gaAnalytics else { return cell }
        cell.dimensionLabel.text = gaAnalytics.dimensionValues[indexPath.row]
        cell.metricLabel.text = gaAnalytics.metricValues[indexPath.row]
        return cell
    }
}

extension AnalyticsCardCollectionViewCell: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 26
    }
}

