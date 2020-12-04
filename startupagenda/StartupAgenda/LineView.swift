//
//  LineView.swift
//  StartUpAgendaInterface
//
//  Created by Mark Cornelisse on 08/08/15.
//  Copyright (c) 2015 Over de muur producties. All rights reserved.
//

import UIKit

@IBDesignable class LineView: UIView {
    @IBInspectable var horizontalInset: CGFloat = 1
    @IBInspectable var verticalInset: CGFloat = 1
    @IBInspectable var thickNess: CGFloat = 1
    @IBInspectable var lineColor: UIColor = UIColor.blackColor()
    
    var lineLayer: CAShapeLayer?
    
    // MARK: New in this class
    
    func createLinePath(rect: CGRect) -> CGPath {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, rect.minX, rect.midY)
        CGPathAddLineToPoint(path, nil, rect.maxX, rect.midY)
        return path
    }
    
    // MARK: Inherited from super.
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if lineLayer == nil {
            lineLayer = CAShapeLayer()
            self.layer.addSublayer(lineLayer!)
        }
        lineLayer!.frame = CGRectInset(bounds, horizontalInset, verticalInset)
        lineLayer!.path = createLinePath(lineLayer!.frame)
        lineLayer!.strokeColor = lineColor.CGColor
    }
    
    override func intrinsicContentSize() -> CGSize {
        var existingSize = self.frame.size
        existingSize.height = thickNess + (verticalInset * 2)
        return existingSize
    }
}