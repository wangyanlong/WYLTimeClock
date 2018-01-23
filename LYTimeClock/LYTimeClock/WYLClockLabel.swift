//
//  WYLClockLabel.swift
//  LYTimeClock
//
//  Created by wyl on 2018/1/20.
//  Copyright © 2018年 wyl. All rights reserved.
//

import UIKit

class WYLClockLabel: UIImageView {

    var blackView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, top: Bool) {
        
        self.init(frame: frame)
                
        blackView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        blackView?.backgroundColor = UIColor.init(colorWithHexValue: 0x404146)
        if top {
            blackView?.corner(byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], radii: 6.3)
        }else{
            blackView?.corner(byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radii: 6.3)
        }
        blackView?.alpha = 0.0
        self.addSubview(blackView!)
    }
    
}

extension UIView {
    
    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

