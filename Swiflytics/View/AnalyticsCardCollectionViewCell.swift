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

class AnalyticsCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet var cardTitle: UILabel!
    @IBOutlet var cardTitleContainer: UIView!
    
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
