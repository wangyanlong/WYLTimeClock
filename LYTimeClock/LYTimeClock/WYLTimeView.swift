//
//  WYLTimeView.swift
//  LYTimeClock
//
//  Created by wyl on 2018/1/19.
//  Copyright © 2018年 wyl. All rights reserved.
//

import UIKit

class WYLTimeView: UIImageView {

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let width = 90
        
//        let top1: WYLClockLabel = WYLClockLabel.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 66),top: true)
////        top1.blackView?.alpha = 1.0
//        top1.contentMode = .scaleAspectFit
//        var img = UIImage.init(named: "1-top")
//        top1.image = img
//        self.addSubview(top1)
//
//        let bottom1: WYLClockLabel = WYLClockLabel.init(frame: CGRect.init(x: -45, y: 32, width: width, height: 68),top: true)
//        bottom1.contentMode = .scaleAspectFit
//        img = UIImage.init(named: "1-bottom")
//        bottom1.layer.anchorPoint = CGPoint.init(x: 0.0, y: 1.0)
//        bottom1.image = img
////        bottom1.alpha = 0.0
//        self.addSubview(bottom1)
//
//        let top0: WYLClockLabel = WYLClockLabel.init(frame: CGRect.init(x: -45, y: 32, width: width, height: 68), top: true)
//        top0.contentMode = .scaleAspectFit
//        img = UIImage.init(named: "0-top")
//        top0.image = img
//        self.addSubview(top0)
//        top0.layer.anchorPoint = CGPoint.init(x: 0.0, y: 1.0)
//
//
//        let bottom0: WYLClockLabel = WYLClockLabel.init(frame: CGRect.init(x: 0, y: 66, width: width, height: 68), top: false)
//        bottom0.contentMode = .scaleAspectFit
//        img = UIImage.init(named: "0-bottom")
//        bottom0.image = img
//        self.addSubview(bottom0)
//
//        let transform = CATransform3DIdentity
//        UIView.animate(withDuration: 0.8, delay: 1, options: .curveEaseOut, animations: {
//            top1.blackView?.alpha = 0.0
//            bottom0.blackView?.alpha = 1.0
//            bottom1.layer.transform.m34 = 1.0 / -500;
//            bottom1.layer.transform = CATransform3DRotate(transform, .pi/1, 1, 0, 0)
//            bottom1.alpha = 1.0
//            top0.layer.transform.m34 = 1.0 / -500;
//            top0.layer.transform = CATransform3DRotate(transform, .pi/1, 10, 0, 0)
//            top0.blackView?.alpha = 1.0
//            top0.alpha = 0.0
//        }) { (finish) in
//            top0.removeFromSuperview()
//            bottom0.removeFromSuperview()
//        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension UIImage {
    func image(withRotation radians: CGFloat) -> UIImage {
        let cgImage = self.cgImage!
        let LARGEST_SIZE = CGFloat(max(self.size.width, self.size.height))
        let context = CGContext.init(data: nil, width:Int(LARGEST_SIZE), height:Int(LARGEST_SIZE), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue)!
        
        var drawRect = CGRect.zero
        drawRect.size = self.size
        let drawOrigin = CGPoint(x: (LARGEST_SIZE - self.size.width) * 0.5,y: (LARGEST_SIZE - self.size.height) * 0.5)
        drawRect.origin = drawOrigin
        var tf = CGAffineTransform.identity
        tf = tf.translatedBy(x: LARGEST_SIZE * 0.5, y: LARGEST_SIZE * 0.5)
        tf = tf.rotated(by: CGFloat(radians))
        tf = tf.translatedBy(x: LARGEST_SIZE * -0.5, y: LARGEST_SIZE * -0.5)
        context.concatenate(tf)
        context.draw(cgImage, in: drawRect)
        var rotatedImage = context.makeImage()!
        
        drawRect = drawRect.applying(tf)
        
        rotatedImage = rotatedImage.cropping(to: drawRect)!
        let resultImage = UIImage(cgImage: rotatedImage)
        return resultImage
        
        
    }
}
