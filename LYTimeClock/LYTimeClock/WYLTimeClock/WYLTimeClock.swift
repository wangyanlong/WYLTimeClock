//
//  LYTimeClock.swift
//  LYTimeClock
//
//  Created by wyl on 2018/1/19.
//  Copyright © 2018年 wyl. All rights reserved.
//

import UIKit
import SnapKit

class WYLTimeClock: UIView {

    // MARK:翻页的label
    
    var secondSingleDigitTop: WYLClockLabel?
    var secondSingleDigitBottom: WYLClockLabel?
    var secondReverseSingleDigitTop: WYLClockLabel?
    var secondReverseSingleDigitBottom: WYLClockLabel?
    
    var secondTenDigitTop: WYLClockLabel?
    var secondTenDigitBottom: WYLClockLabel?
    var secondReverseTenDigitTop: WYLClockLabel?
    var secondReverseTenDigitBottom: WYLClockLabel?
    
    var minuteSingleDigitTop: WYLClockLabel?
    var minuteSingleDigitBottom: WYLClockLabel?
    var minuteReverseSingleDigitTop: WYLClockLabel?
    var minuteReverseSingleDigitBottom: WYLClockLabel?
    
    var minuteTenDigitTop: WYLClockLabel?
    var minuteTenDigitBottom: WYLClockLabel?
    var minuteReverseTenDigitTop: WYLClockLabel?
    var minuteReverseTenDigitBottom: WYLClockLabel?
    
    var hourSingleDigitTop: WYLClockLabel?
    var hourSingleDigitBottom: WYLClockLabel?
    var hourReverseSingleDigitTop: WYLClockLabel?
    var hourReverseSingleDigitBottom: WYLClockLabel?
    
    var hourTenDigitTop: WYLClockLabel?
    var hourTenDigitBottom: WYLClockLabel?
    var hourReverseTenDigitTop: WYLClockLabel?
    var hourReverseTenDigitBottom: WYLClockLabel?
    
    var day: UILabel?
    var dateLabel: UILabel?
    var endDate: Date?
    var dateCopy: Date?
    
    let timeZone: TimeZone = {
        // +0:00
        if let timeZone = TimeZone(secondsFromGMT:0) {
            return timeZone
        } else {
            //assertionFailure()
            return TimeZone.autoupdatingCurrent
        }
    }()
    
    var implement: Bool = false
    
    // MARK:生命周期
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, date: Date){
        
        self.init(frame: frame)
        
        endDate = date
        
        self.backgroundColor = UIColor.init(colorWithHexValue: 0xFBF6F0)
        
        self.layer.cornerRadius = 110
        self.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.init(colorWithHexValue: 0x000000).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.5
        self.clipsToBounds = false

    }
    
    deinit {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    // MARK:核心方法-翻页动画
    
    @objc func setUpTimeLabel(){
        
        dateCopy = localDate(date: Date.init())

        let com = ComparisonDate(date1: endDate!, date2: dateCopy!)
        
        if com < 0{
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(setUpTimeLabel), object: nil)
            setUpStaticLabel()
            return
        }else{
            
            let view = self.viewWithTag(3000)
            if view != nil{
                for i in 3000...3005{
                    let view2 = self.viewWithTag(i)
                    view2?.removeFromSuperview()
                }
            }
            
        }
        
        if implement {
            return
        }
        
        implement = true
        
        var timeInterval:TimeInterval = dateCopy!.timeIntervalSince1970
        timeInterval += 1

        var calendar = Calendar.current
        calendar.timeZone = timeZone
        var commponent: DateComponents = DateComponents()
        var unit:Set<Calendar.Component> = [.day,.hour,.minute,.second]
        commponent = calendar.dateComponents(unit, from: dateCopy!, to: endDate!)
        
        var x: CGFloat = kRealValue() * 8.5
        var y: CGFloat = kRealValue() * 31.7
        
        if hourReverseTenDigitTop == nil{
            setUpHourLabel(xBase: x, yBase: y, commponent: commponent)
        }
        
        //--------------
        
        if minuteReverseSingleDigitTop == nil{
            x = (hourReverseSingleDigitTop?.frame.origin.x)! + (hourReverseSingleDigitTop?.frame.size.width)! + 3
            y = (hourReverseSingleDigitTop?.frame.origin.y)! + 10
            setUpColon(x: x, y: y)
        }
        
        
        //--------------

        if minuteReverseSingleDigitTop == nil{
            setUpMinuteLabel(xBase: x, yBase: y, commponent: commponent)
        }
        
        //-----------
        
        if secondReverseSingleDigitTop == nil{
            x = (minuteReverseSingleDigitTop?.frame.origin.x)! + (minuteReverseSingleDigitTop?.frame.size.width)! + 3
            y = (minuteReverseSingleDigitTop?.frame.origin.y)! + 10
            setUpColon(x: x, y: y)
        }
        
        //--------------
        
        if secondReverseSingleDigitTop == nil{
            setUpSecondLabel(xBase: x, yBase: y, commponent: commponent)
        }
        
        let secondSingleDigit = commponent.second! % 10
        let secondTenDigit = commponent.second! / 10
        let minuteSingleDigit = commponent.minute! % 10
        let minuteTenDigit = commponent.minute! / 10
        let hourSingleDigit = commponent.hour! % 10
        let hourTenDigit = commponent.hour! / 10
        
        UIView.animate(withDuration: 0.7, animations: {
            
            if (hourTenDigit - 1) < 0 && (hourSingleDigit - 1) < 0 && (secondTenDigit - 1) < 0 && (secondSingleDigit - 1) < 0 && (minuteSingleDigit - 1) < 0 && (minuteTenDigit - 1) < 0{
                
                self.hourTenAnimation()
                self.hourSingleAnimation()
                self.minuteTenAnimation()
                self.minuteSingleAnimation()
                self.secondSingleAnimation()
                self.secondTenAnimation()
            }else if (hourSingleDigit - 1) < 0 && (secondTenDigit - 1) < 0 && (secondSingleDigit - 1) < 0 && (minuteSingleDigit - 1) < 0 && (minuteTenDigit - 1) < 0{
                self.hourTenAnimation()
                self.hourSingleAnimation()
                self.minuteTenAnimation()
                self.minuteSingleAnimation()
                self.secondSingleAnimation()
                self.secondTenAnimation()
            }else if (secondTenDigit - 1) < 0 && (secondSingleDigit - 1) < 0 && (minuteSingleDigit - 1) < 0 && (minuteTenDigit - 1) < 0 {
                self.hourSingleAnimation()
                self.minuteTenAnimation()
                self.minuteSingleAnimation()
                self.secondSingleAnimation()
                self.secondTenAnimation()
            }else if (secondTenDigit - 1) < 0 && (secondSingleDigit - 1) < 0 && (minuteSingleDigit - 1) < 0{
                self.minuteTenAnimation()
                self.minuteSingleAnimation()
                self.secondSingleAnimation()
                self.secondTenAnimation()
            }else if (secondTenDigit - 1) < 0 && (secondSingleDigit - 1) < 0 {
                self.minuteSingleAnimation()
                self.secondSingleAnimation()
                self.secondTenAnimation()
            }else if (secondSingleDigit - 1) < 0{
                self.secondSingleAnimation()
                self.secondTenAnimation()
            }else{
                self.secondSingleAnimation()
            }
            
        }) { (finish) in
            
            if (hourTenDigit - 1) < 0 && (hourSingleDigit - 1) < 0 && (secondTenDigit - 1) < 0 && (secondSingleDigit - 1) < 0 && (minuteSingleDigit - 1) < 0 && (minuteTenDigit - 1) < 0{
                
                var calendar = Calendar.current
                calendar.timeZone = self.timeZone
                
                let unit:Set<Calendar.Component> = [.day,.hour,.minute,.second]
                commponent = calendar.dateComponents(unit, from: self.localDate(date: Date.init()), to: self.endDate!)
                self.day!.text = "剩下\(commponent.day!)天"
                
                self.hourTenAnimationFinish(commponent: commponent,across: true)
                self.hourSingleAnimationFinish(commponent: commponent,across: true)
                self.minuteTenAnimationFinish(commponent: commponent,across: true)
                self.minuteSingleAnimationFinish(commponent: commponent,across: true)
                self.secondSingleAnimationFinish(commponent: commponent,across: true)
                self.secondTenAnimationFinish(commponent: commponent,across: true)
                
            }else if (hourSingleDigit - 1) < 0 && (secondTenDigit - 1) < 0 && (secondSingleDigit - 1) < 0 && (minuteSingleDigit - 1) < 0 && (minuteTenDigit - 1) < 0{
                self.hourTenAnimationFinish(commponent: commponent,across: false)
                self.hourSingleAnimationFinish(commponent: commponent,across: false)
                self.minuteTenAnimationFinish(commponent: commponent,across: false)
                self.minuteSingleAnimationFinish(commponent: commponent,across: false)
                self.secondSingleAnimationFinish(commponent: commponent,across: false)
                self.secondTenAnimationFinish(commponent: commponent,across: false)
            }else if (secondTenDigit - 1) < 0 && (secondSingleDigit - 1) < 0 && (minuteSingleDigit - 1) < 0 && (minuteTenDigit - 1) < 0 {
                self.hourSingleAnimationFinish(commponent: commponent,across: false)
                self.minuteTenAnimationFinish(commponent: commponent,across: false)
                self.minuteSingleAnimationFinish(commponent: commponent,across: false)
                self.secondSingleAnimationFinish(commponent: commponent,across: false)
                self.secondTenAnimationFinish(commponent: commponent,across: false)
            }else if (secondTenDigit - 1) < 0 && (secondSingleDigit - 1) < 0 && (minuteSingleDigit - 1) < 0{
                self.minuteTenAnimationFinish(commponent: commponent,across: false)
                self.minuteSingleAnimationFinish(commponent: commponent,across: false)
                self.secondSingleAnimationFinish(commponent: commponent,across: false)
                self.secondTenAnimationFinish(commponent: commponent,across: false)
            }else if (secondTenDigit - 1) < 0 && (secondSingleDigit - 1) < 0 {
                self.minuteSingleAnimationFinish(commponent: commponent,across: false)
                self.secondSingleAnimationFinish(commponent: commponent,across: false)
                self.secondTenAnimationFinish(commponent: commponent,across: false)
            }else if (secondSingleDigit - 1) < 0{
                self.secondSingleAnimationFinish(commponent: commponent,across: false)
                self.secondTenAnimationFinish(commponent: commponent,across: false)
            }else{
                self.secondSingleAnimationFinish(commponent: commponent,across: false)
            }

            unit = [.nanosecond]
            let nextDate: Date = Date.init(timeIntervalSince1970: timeInterval)
            let dateLocal = self.localDate(date: Date.init())
            
            self.implement = false
            
            commponent = calendar.dateComponents(unit, from:dateLocal , to: nextDate)
            let time = Double(commponent.nanosecond!) / 1000000000
            self.perform(#selector(self.setUpTimeLabel), with: nil, afterDelay: time)
            
        }
        
    }
    
    // MARK:动画-hour
    func hourTenAnimation(){
        
        let transform = CATransform3DIdentity
        
        self.hourReverseTenDigitTop?.blackView?.alpha = 0.0
        
        self.hourTenDigitTop?.layer.transform.m34 = 1.0 / -500;
        self.hourTenDigitTop?.layer.transform = CATransform3DRotate(transform, .pi/1, 1, 0, 0)
        self.hourTenDigitTop?.blackView?.alpha = 1.0
        self.hourTenDigitTop?.alpha = 0.0
        
        self.hourReverseTenDigitBottom?.layer.transform.m34 = 1.0 / -500;
        self.hourReverseTenDigitBottom?.layer.transform = CATransform3DRotate(transform, .pi/1, 1, 0, 0)
        self.hourReverseTenDigitBottom?.alpha = 1.0
        
        self.hourTenDigitBottom?.blackView?.alpha = 1.0
    }
    
    func hourTenAnimationFinish(commponent: DateComponents, across: Bool){
        
        let transform = CATransform3DIdentity
        
        let hourTenDigit = commponent.hour! / 10
        
        var num: Int?
        
        if across {
            num = 2
        }else{
            num = (hourTenDigit - 1) >= 0 ? (hourTenDigit - 1) : 2
        }
        
        //no.1 先把被盖住的bottom放到前面,改变图标
        self.hourTenDigitBottom?.image = UIImage.init(named: "\(String(describing: num!))-bottom")
        self.hourTenDigitBottom?.blackView?.alpha = 0.0
        self.bringSubview(toFront: self.hourTenDigitBottom!)
        
        //no.2 把翻转过来的2个view放到后面,重新翻转回去
        self.sendSubview(toBack: self.hourReverseTenDigitBottom!)
        self.sendSubview(toBack: self.hourReverseTenDigitTop!)
        
        var numNext: Int?
        if across{
            numNext = 1
        }else{
            numNext = (num! - 1) >= 0 ? (num! - 1) : 2
        }
        
        self.hourTenDigitTop?.blackView?.alpha = 0.0
        self.hourTenDigitTop?.image = UIImage.init(named: "\(String(describing: num!))-top")
        self.hourTenDigitTop?.layer.transform = CATransform3DRotate(transform, (.pi * -2) , 1, 0, 0)
        self.hourTenDigitTop?.alpha = 1.0
        
        self.hourReverseTenDigitBottom?.alpha = 0.0
        self.hourReverseTenDigitBottom?.layer.transform = CATransform3DRotate(transform, (.pi * -2) , 1, 0, 0)
        self.hourReverseTenDigitBottom?.image = UIImage.init(named: "\(String(describing: numNext!))-bottom-reverse")
        
        self.hourReverseTenDigitTop?.image = UIImage.init(named: "\(String(describing: numNext!))-top")
        
    }
    
    func hourSingleAnimationFinish(commponent : DateComponents, across: Bool){
        
        let transform = CATransform3DIdentity
        
        let hourSingleDigit = commponent.hour! % 10
        
        var num: Int?
        
        if across {
            num = 3
        }else{
            num = (hourSingleDigit - 1) >= 0 ? (hourSingleDigit - 1) : 9
        }
        
        //no.1 先把被盖住的bottom放到前面,改变图标
        self.hourSingleDigitBottom?.image = UIImage.init(named: "\(String(describing: num!))-bottom")
        self.hourSingleDigitBottom?.blackView?.alpha = 0.0
        self.bringSubview(toFront: self.hourSingleDigitBottom!)
        
        //no.2 把翻转过来的2个view放到后面,重新翻转回去
        self.sendSubview(toBack: self.hourReverseSingleDigitBottom!)
        self.sendSubview(toBack: self.hourReverseSingleDigitTop!)
        
        var numNext: Int?
        if across {
            numNext = 2
        }else{
            numNext = (num! - 1) >= 0 ? (num! - 1) : 9
        }
        
        self.hourSingleDigitTop?.blackView?.alpha = 0.0
        self.hourSingleDigitTop?.image = UIImage.init(named: "\(String(describing: num!))-top")
        self.hourSingleDigitTop?.layer.transform = CATransform3DRotate(transform, (.pi * -2) , 1, 0, 0)
        self.hourSingleDigitTop?.alpha = 1.0
        
        self.hourReverseSingleDigitBottom?.alpha = 0.0
        self.hourReverseSingleDigitBottom?.layer.transform = CATransform3DRotate(transform, (.pi * -2) , 1, 0, 0)
        self.hourReverseSingleDigitBottom?.image = UIImage.init(named: "\(String(describing: numNext!))-bottom-reverse")
        
        self.hourReverseSingleDigitTop?.image = UIImage.init(named: "\(String(describing: numNext!))-top")
        
    }
    
    func hourSingleAnimation(){
        
        let transform = CATransform3DIdentity
        
        self.hourReverseSingleDigitTop?.blackView?.alpha = 0.0
        
        self.hourSingleDigitTop?.layer.transform.m34 = 1.0 / -500;
        self.hourSingleDigitTop?.layer.transform = CATransform3DRotate(transform, .pi/1, 1, 0, 0)
        self.hourSingleDigitTop?.blackView?.alpha = 1.0
        self.hourSingleDigitTop?.alpha = 0.0
        
        self.hourReverseSingleDigitBottom?.layer.transform.m34 = 1.0 / -500;
        self.hourReverseSingleDigitBottom?.layer.transform = CATransform3DRotate(transform, .pi/1, 1, 0, 0)
        self.hourReverseSingleDigitBottom?.alpha = 1.0
        
        self.hourSingleDigitBottom?.blackView?.alpha = 1.0
        
    }
    
    // MARK:动画-minute
    func minuteTenAnimation(){
        
        let transform = CATransform3DIdentity
        
        self.minuteReverseTenDigitTop?.blackView?.alpha = 0.0
        
        self.minuteTenDigitTop?.layer.transform.m34 = 1.0 / -500;
        self.minuteTenDigitTop?.layer.transform = CATransform3DRotate(transform, .pi/1, 1, 0, 0)
        self.minuteTenDigitTop?.blackView?.alpha = 1.0
        self.minuteTenDigitTop?.alpha = 0.0
        
        self.minuteReverseTenDigitBottom?.layer.transform.m34 = 1.0 / -500;
        self.minuteReverseTenDigitBottom?.layer.transform = CATransform3DRotate(transform, .pi/1, 1, 0, 0)
        self.minuteReverseTenDigitBottom?.alpha = 1.0
        
        self.minuteTenDigitBottom?.blackView?.alpha = 1.0
        
    }
    
    func minuteTenAnimationFinish(commponent : DateComponents, across: Bool){
        
        let transform = CATransform3DIdentity
        
        let minuteTenDigit = commponent.minute! / 10
        
        var num: Int?
        if across{
            num = 5
        }else{
            num = (minuteTenDigit - 1) >= 0 ? (minuteTenDigit - 1) : 5
        }
        
        //no.1 先把被盖住的bottom放到前面,改变图标
        self.minuteTenDigitBottom?.image = UIImage.init(named: "\(String(describing: num!))-bottom")
        self.minuteTenDigitBottom?.blackView?.alpha = 0.0
        self.bringSubview(toFront: self.minuteTenDigitBottom!)
        
        //no.2 把翻转过来的2个view放到后面,重新翻转回去
        self.sendSubview(toBack: self.minuteReverseTenDigitBottom!)
        self.sendSubview(toBack: self.minuteReverseTenDigitTop!)
        
        var numNext: Int?
        if across {
            numNext = 4
        }else{
            numNext = (num! - 1) >= 0 ? (num! - 1) : 5
        }
        
        self.minuteTenDigitTop?.blackView?.alpha = 0.0
        self.minuteTenDigitTop?.image = UIImage.init(named: "\(String(describing: num!))-top")
        self.minuteTenDigitTop?.layer.transform = CATransform3DRotate(transform, (.pi * -2) , 1, 0, 0)
        self.minuteTenDigitTop?.alpha = 1.0
        
        self.minuteReverseTenDigitBottom?.alpha = 0.0
        self.minuteReverseTenDigitBottom?.layer.transform = CATransform3DRotate(transform, (.pi * -2) , 1, 0, 0)
        self.minuteReverseTenDigitBottom?.image = UIImage.init(named: "\(String(describing: numNext!))-bottom-reverse")
        
        self.minuteReverseTenDigitTop?.image = UIImage.init(named: "\(String(describing: numNext!))-top")
        
    }
    
    func minuteSingleAnimationFinish(commponent : DateComponents, across: Bool){
        
        let transform = CATransform3DIdentity
        
        let minuteSingleDigit = commponent.minute! % 10
        
        var num: Int?
        if across {
            num = 9
        }else{
            num = (minuteSingleDigit - 1) >= 0 ? (minuteSingleDigit - 1) : 9
        }
        
        //no.1 先把被盖住的bottom放到前面,改变图标
        self.minuteSingleDigitBottom?.image = UIImage.init(named: "\(String(describing: num!))-bottom")
        self.minuteSingleDigitBottom?.blackView?.alpha = 0.0
        self.bringSubview(toFront: self.minuteSingleDigitBottom!)
        
        //no.2 把翻转过来的2个view放到后面,重新翻转回去
        self.sendSubview(toBack: self.minuteReverseSingleDigitBottom!)
        self.sendSubview(toBack: self.minuteReverseSingleDigitTop!)
        
        var numNext: Int?
        if across {
            numNext = 8
        }else{
            numNext = (num! - 1) >= 0 ? (num! - 1) : 9
        }
        
        self.minuteSingleDigitTop?.blackView?.alpha = 0.0
        self.minuteSingleDigitTop?.image = UIImage.init(named: "\(String(describing: num!))-top")
        self.minuteSingleDigitTop?.layer.transform = CATransform3DRotate(transform, (.pi * -2) , 1, 0, 0)
        self.minuteSingleDigitTop?.alpha = 1.0
        
        self.minuteReverseSingleDigitBottom?.alpha = 0.0
        self.minuteReverseSingleDigitBottom?.layer.transform = CATransform3DRotate(transform, (.pi * -2) , 1, 0, 0)
        self.minuteReverseSingleDigitBottom?.image = UIImage.init(named: "\(String(describing: numNext!))-bottom-reverse")
        
        self.minuteReverseSingleDigitTop?.image = UIImage.init(named: "\(String(describing: numNext!))-top")
    }
    
    func minuteSingleAnimation(){
        
        let transform = CATransform3DIdentity
        
        self.minuteReverseSingleDigitTop?.blackView?.alpha = 0.0
        
        self.minuteSingleDigitTop?.layer.transform.m34 = 1.0 / -500;
        self.minuteSingleDigitTop?.layer.transform = CATransform3DRotate(transform, .pi/1, 1, 0, 0)
        self.minuteSingleDigitTop?.blackView?.alpha = 1.0
        self.minuteSingleDigitTop?.alpha = 0.0
        
        self.minuteReverseSingleDigitBottom?.layer.transform.m34 = 1.0 / -500;
        self.minuteReverseSingleDigitBottom?.layer.transform = CATransform3DRotate(transform, .pi/1, 1, 0, 0)
        self.minuteReverseSingleDigitBottom?.alpha = 1.0
        
        self.minuteSingleDigitBottom?.blackView?.alpha = 1.0
        
    }
    
    // MARK:动画-second
    func secondTenAnimation(){
        
        let transform = CATransform3DIdentity
        
        self.secondReverseTenDigitTop?.blackView?.alpha = 0.0
        
        self.secondTenDigitTop?.layer.transform.m34 = 1.0 / -500;
        self.secondTenDigitTop?.layer.transform = CATransform3DRotate(transform, .pi/1, 1, 0, 0)
        self.secondTenDigitTop?.blackView?.alpha = 1.0
        self.secondTenDigitTop?.alpha = 0.0
        
        self.secondReverseTenDigitBottom?.layer.transform.m34 = 1.0 / -500;
        self.secondReverseTenDigitBottom?.layer.transform = CATransform3DRotate(transform, .pi/1, 1, 0, 0)
        self.secondReverseTenDigitBottom?.alpha = 1.0
        
        self.secondTenDigitBottom?.blackView?.alpha = 1.0
        
    }
    
    func secondTenAnimationFinish(commponent : DateComponents, across: Bool){
        
        let transform = CATransform3DIdentity
        
        let secondTenDigit = commponent.second! / 10
        
        var num: Int?
        if across {
            num = 5
        }else{
            num = (secondTenDigit - 1) >= 0 ? (secondTenDigit - 1) : 5
        }
        
        //no.1 先把被盖住的bottom放到前面,改变图标
        self.secondTenDigitBottom?.image = UIImage.init(named: "\(String(describing: num!))-bottom")
        self.secondTenDigitBottom?.blackView?.alpha = 0.0
        self.bringSubview(toFront: self.secondTenDigitBottom!)
        
        //no.2 把翻转过来的2个view放到后面,重新翻转回去
        self.sendSubview(toBack: self.secondReverseTenDigitBottom!)
        self.sendSubview(toBack: self.secondReverseTenDigitTop!)
        
        var numNext: Int?
        if across {
            numNext = 4
        }else{
            numNext = (num! - 1) >= 0 ? (num! - 1) : 5
        }
        
        self.secondTenDigitTop?.blackView?.alpha = 0.0
        self.secondTenDigitTop?.image = UIImage.init(named: "\(String(describing: num!))-top")
        self.secondTenDigitTop?.layer.transform = CATransform3DRotate(transform, (.pi * -2) , 1, 0, 0)
        self.secondTenDigitTop?.alpha = 1.0
        
        self.secondReverseTenDigitBottom?.alpha = 0.0
        self.secondReverseTenDigitBottom?.layer.transform = CATransform3DRotate(transform, (.pi * -2) , 1, 0, 0)
        self.secondReverseTenDigitBottom?.image = UIImage.init(named: "\(String(describing: numNext!))-bottom-reverse")
        
        self.secondReverseTenDigitTop?.image = UIImage.init(named: "\(String(describing: numNext!))-top")
    }
    
    func secondSingleAnimationFinish(commponent : DateComponents, across: Bool){
        
        let transform = CATransform3DIdentity
        
        let secondSingleDigit = commponent.second! % 10
        
        var num: Int?
        if across {
            num = 9
        }else{
            num = (secondSingleDigit - 1) >= 0 ? (secondSingleDigit - 1) : 9
        }
        
        //no.1 先把被盖住的bottom放到前面,改变图标
        self.secondSingleDigitBottom?.image = UIImage.init(named: "\(String(describing: num!))-bottom")
        self.secondSingleDigitBottom?.blackView?.alpha = 0.0
        self.bringSubview(toFront: self.secondSingleDigitBottom!)
        
        //no.2 把翻转过来的2个view放到后面,重新翻转回去
        self.sendSubview(toBack: self.secondReverseSingleDigitBottom!)
        self.sendSubview(toBack: self.secondReverseSingleDigitTop!)
        
        var numNext: Int?
        if across {
            numNext = 8
        }else{
            numNext = (num! - 1) >= 0 ? (num! - 1) : 9
        }
        
        self.secondSingleDigitTop?.blackView?.alpha = 0.0
        self.secondSingleDigitTop?.image = UIImage.init(named: "\(String(describing: num!))-top")
        self.secondSingleDigitTop?.layer.transform = CATransform3DRotate(transform, (.pi * -2) , 1, 0, 0)
        self.secondSingleDigitTop?.alpha = 1.0
        
        self.secondReverseSingleDigitBottom?.alpha = 0.0
        self.secondReverseSingleDigitBottom?.layer.transform = CATransform3DRotate(transform, (.pi * -2) , 1, 0, 0)
        self.secondReverseSingleDigitBottom?.image = UIImage.init(named: "\(String(describing: numNext!))-bottom-reverse")
        
        self.secondReverseSingleDigitTop?.image = UIImage.init(named: "\(String(describing: numNext!))-top")
    }
    
    func secondSingleAnimation(){
        
        let transform = CATransform3DIdentity

        self.secondReverseSingleDigitTop?.blackView?.alpha = 0.0
        
        self.secondSingleDigitTop?.layer.transform.m34 = 1.0 / -500;
        self.secondSingleDigitTop?.layer.transform = CATransform3DRotate(transform, .pi/1, 1, 0, 0)
        self.secondSingleDigitTop?.blackView?.alpha = 1.0
        self.secondSingleDigitTop?.alpha = 0.0
        
        self.secondReverseSingleDigitBottom?.layer.transform.m34 = 1.0 / -500;
        self.secondReverseSingleDigitBottom?.layer.transform = CATransform3DRotate(transform, .pi/1, 1, 0, 0)
        self.secondReverseSingleDigitBottom?.alpha = 1.0
        
        self.secondSingleDigitBottom?.blackView?.alpha = 1.0
        
    }
    
    // MARK:绘制UI
    
    func setUpSecondLabel(xBase: CGFloat,yBase: CGFloat,commponent: DateComponents){
        
        let secondSingleDigit = commponent.second! % 10
        let secondTenDigit = commponent.second! / 10
        
        var x:CGFloat = xBase
        var y:CGFloat = yBase
        
        var num: Int = (secondTenDigit - 1) >= 0 ? (secondTenDigit - 1) : 5
        
        x = (minuteReverseSingleDigitTop?.frame.origin.x)! + (minuteReverseSingleDigitTop?.frame.size.width)! + 10.4
        y = kRealValue() * 31.7
        
        if secondReverseTenDigitTop == nil {
            secondReverseTenDigitTop = WYLClockLabel.init(frame: CGRect.init(x: x, y: y, width: 25, height: 18), top: true)
            secondReverseTenDigitTop?.blackView?.alpha = 1.0
            self.addSubview(secondReverseTenDigitTop!)
        }
        secondReverseTenDigitTop?.image = UIImage.init(named: "\(num)-top")
        
        if secondReverseTenDigitBottom == nil {
            secondReverseTenDigitBottom = WYLClockLabel.init(frame: CGRect.init(x: x - ( 25 / 2.0), y: y + (18 / 2.0), width: 25, height: 18), top: true)
            secondReverseTenDigitBottom?.alpha = 0.0
            secondReverseTenDigitBottom?.layer.anchorPoint = CGPoint.init(x: 0.0, y: 1.00)
            self.addSubview(secondReverseTenDigitBottom!)
        }
        secondReverseTenDigitBottom?.image = UIImage.init(named: "\(num)-bottom-reverse")
        
        if secondTenDigitTop == nil{
            secondTenDigitTop = WYLClockLabel.init(frame: CGRect.init(x: x - ( 25 / 2.0), y: y + (18 / 2.0), width: 25, height: 18), top: true)
            secondTenDigitTop?.layer.anchorPoint = CGPoint.init(x: 0.0, y: 1.0)
            self.addSubview(secondTenDigitTop!)
        }
        secondTenDigitTop?.image = UIImage.init(named: "\(secondTenDigit)-top")
        
        if secondTenDigitBottom == nil{
            secondTenDigitBottom = WYLClockLabel.init(frame: CGRect.init(x: x, y: y + 18, width: 25, height: 18), top: false)
            self.addSubview(secondTenDigitBottom!)
        }
        secondTenDigitBottom?.image = UIImage.init(named: "\(secondTenDigit)-bottom")
        
        //------------
        
        num = (secondSingleDigit - 1) >= 0 ? (secondSingleDigit - 1) : 9
        x = (secondReverseTenDigitTop?.frame.origin.x)! + (secondReverseTenDigitTop?.frame.size.width)! + 3
        
        if secondReverseSingleDigitTop == nil {
            secondReverseSingleDigitTop = WYLClockLabel.init(frame: CGRect.init(x: x, y: y, width: 25, height: 18), top: true)
            secondReverseSingleDigitTop?.blackView?.alpha = 1.0
            self.addSubview(secondReverseSingleDigitTop!)
        }
        secondReverseSingleDigitTop?.image = UIImage.init(named: "\(num)-top")
        
        if secondReverseSingleDigitBottom == nil {
            secondReverseSingleDigitBottom = WYLClockLabel.init(frame: CGRect.init(x: x - ( 25 / 2.0), y: y + (18 / 2.0), width: 25, height: 18), top: true)
            secondReverseSingleDigitBottom?.alpha = 0.0
            secondReverseSingleDigitBottom?.layer.anchorPoint = CGPoint.init(x: 0.0, y: 1.00)
            self.addSubview(secondReverseSingleDigitBottom!)
        }
        secondReverseSingleDigitBottom?.image = UIImage.init(named: "\(num)-bottom-reverse")
        
        if secondSingleDigitTop == nil{
            secondSingleDigitTop = WYLClockLabel.init(frame: CGRect.init(x: x - ( 25 / 2.0), y: y + (18 / 2.0), width: 25, height: 18), top: true)
            secondSingleDigitTop?.layer.anchorPoint = CGPoint.init(x: 0.0, y: 1.0)
            self.addSubview(secondSingleDigitTop!)
        }
        secondSingleDigitTop?.image = UIImage.init(named: "\(secondSingleDigit)-top")
        
        if secondSingleDigitBottom == nil {
            secondSingleDigitBottom = WYLClockLabel.init(frame: CGRect.init(x: x, y: y + 18, width: 25, height: 18), top: false)
            self.addSubview(secondSingleDigitBottom!)
        }
        secondSingleDigitBottom?.image = UIImage.init(named: "\(secondSingleDigit)-bottom")
        
    }
    
    func setUpMinuteLabel(xBase: CGFloat,yBase: CGFloat,commponent: DateComponents){
        
        let minuteSingleDigit = commponent.minute! % 10
        let minuteTenDigit = commponent.minute! / 10
        
        var x:CGFloat = xBase
        var y:CGFloat = yBase
        
        var num: Int = (minuteTenDigit - 1) >= 0 ? (minuteTenDigit - 1) : 5
        
        x = (hourReverseSingleDigitTop?.frame.origin.x)! + (hourReverseSingleDigitTop?.frame.size.width)! + 10.4
        y = kRealValue() * 31.7
        
        if minuteReverseTenDigitTop == nil {
            minuteReverseTenDigitTop = WYLClockLabel.init(frame: CGRect.init(x: x, y: y, width: 25, height: 18), top: true)
            minuteReverseTenDigitTop?.blackView?.alpha = 1.0
            self.addSubview(minuteReverseTenDigitTop!)
        }
        minuteReverseTenDigitTop?.image = UIImage.init(named: "\(num)-top")
        
        if minuteReverseTenDigitBottom == nil{
            minuteReverseTenDigitBottom = WYLClockLabel.init(frame: CGRect.init(x: x - ( 25 / 2.0), y: y + (18 / 2.0), width: 25, height: 18), top: true)
            minuteReverseTenDigitBottom?.alpha = 0.0
            minuteReverseTenDigitBottom?.layer.anchorPoint = CGPoint.init(x: 0.0, y: 1.0)
            self.addSubview(minuteReverseTenDigitBottom!)
        }
        minuteReverseTenDigitBottom?.image = UIImage.init(named: "\(num)-bottom-reverse")
        
        if minuteTenDigitTop == nil {
            minuteTenDigitTop = WYLClockLabel.init(frame: CGRect.init(x: x - ( 25 / 2.0), y: y + (18 / 2.0), width: 25, height: 18), top: true)
            minuteTenDigitTop?.layer.anchorPoint = CGPoint.init(x: 0.0, y: 1.0)
            self.addSubview(minuteTenDigitTop!)
        }
        minuteTenDigitTop?.image = UIImage.init(named: "\(minuteTenDigit)-top")
        
        if minuteTenDigitBottom == nil {
            minuteTenDigitBottom = WYLClockLabel.init(frame: CGRect.init(x: x, y: y + 18, width: 25, height: 18), top: false)
            self.addSubview(minuteTenDigitBottom!)
        }
        minuteTenDigitBottom?.image = UIImage.init(named: "\(minuteTenDigit)-bottom")
        
        //------------
        
        num = (minuteSingleDigit - 1) >= 0 ? (minuteSingleDigit - 1) : 9
        x = (minuteReverseTenDigitTop?.frame.origin.x)! + (minuteReverseTenDigitTop?.frame.size.width)! + 3
        
        if minuteReverseSingleDigitTop == nil {
            minuteReverseSingleDigitTop = WYLClockLabel.init(frame: CGRect.init(x: x, y: y, width: 25, height: 18), top: true)
            minuteReverseSingleDigitTop?.blackView?.alpha = 1.0
            self.addSubview(minuteReverseSingleDigitTop!)
        }
        minuteReverseSingleDigitTop?.image = UIImage.init(named: "\(num)-top")
        
        if minuteReverseSingleDigitBottom == nil {
            minuteReverseSingleDigitBottom = WYLClockLabel.init(frame: CGRect.init(x: x - ( 25 / 2.0), y: y + (18 / 2.0), width: 25, height: 18), top: true)
            minuteReverseSingleDigitBottom?.alpha = 0.0
            minuteReverseSingleDigitBottom?.layer.anchorPoint = CGPoint.init(x: 0.0, y: 1.00)
            self.addSubview(minuteReverseSingleDigitBottom!)
        }
        minuteReverseSingleDigitBottom?.image = UIImage.init(named: "\(num)-bottom-reverse")
        
        if minuteSingleDigitTop == nil {
            minuteSingleDigitTop = WYLClockLabel.init(frame: CGRect.init(x: x - ( 25 / 2.0), y: y + (18 / 2.0), width: 25, height: 18), top: true)
            minuteSingleDigitTop?.layer.anchorPoint = CGPoint.init(x: 0.0, y: 1.0)
            self.addSubview(minuteSingleDigitTop!)
        }
        minuteSingleDigitTop?.image = UIImage.init(named: "\(minuteSingleDigit)-top")
        
        if minuteSingleDigitBottom == nil {
            minuteSingleDigitBottom = WYLClockLabel.init(frame: CGRect.init(x: x, y: y + 18, width: 25, height: 18), top: false)
            self.addSubview(minuteSingleDigitBottom!)
        }
        minuteSingleDigitBottom?.image = UIImage.init(named: "\(minuteSingleDigit)-bottom")
        
    }
    
    func setUpHourLabel(xBase: CGFloat,yBase: CGFloat,commponent: DateComponents){
        
        let hourSingleDigit = commponent.hour! % 10
        let hourTenDigit = commponent.hour! / 10
        
        var x:CGFloat = xBase
        let y:CGFloat = yBase
        
        var num: Int = (hourTenDigit - 1) >= 0 ? (hourTenDigit - 1) : 2
        
        if hourReverseTenDigitTop == nil {
            hourReverseTenDigitTop = WYLClockLabel.init(frame: CGRect.init(x: x, y: y, width: 25, height: 18), top: true)
            hourReverseTenDigitTop?.blackView?.alpha = 1.0
            self.addSubview(hourReverseTenDigitTop!)
        }
        hourReverseTenDigitTop?.image = UIImage.init(named: "\(num)-top")
        
        if hourReverseTenDigitBottom == nil {
            hourReverseTenDigitBottom = WYLClockLabel.init(frame: CGRect.init(x: x - ( 25 / 2.0), y: y + (18 / 2.0), width: 25, height: 18), top: true)
            hourReverseTenDigitBottom?.alpha = 0.0
            hourReverseTenDigitBottom?.layer.anchorPoint = CGPoint.init(x: 0.0, y: 1.0)
            self.addSubview(hourReverseTenDigitBottom!)
        }
        hourReverseTenDigitBottom?.image = UIImage.init(named: "\(num)-bottom-reverse")
        
        if hourTenDigitTop == nil {
            hourTenDigitTop = WYLClockLabel.init(frame: CGRect.init(x: x - ( 25 / 2.0), y: y + (18 / 2.0), width: 25, height: 18), top: true)
            hourTenDigitTop?.layer.anchorPoint = CGPoint.init(x: 0.0, y: 1.0)
            self.addSubview(hourTenDigitTop!)
        }
        hourTenDigitTop?.image = UIImage.init(named: "\(hourTenDigit)-top")
        
        if hourTenDigitBottom == nil{
            hourTenDigitBottom = WYLClockLabel.init(frame: CGRect.init(x: x, y: y + 18, width: 25, height: 18), top: false)
            self.addSubview(hourTenDigitBottom!)
        }
        hourTenDigitBottom?.image = UIImage.init(named: "\(hourTenDigit)-bottom")
        
        //-----------------
        
        if (hourTenDigit - 1) < 0 {
            num = (hourSingleDigit - 1) >= 0 ? (hourSingleDigit - 1) : 3
        }else{
            num = (hourSingleDigit - 1) >= 0 ? (hourSingleDigit - 1) : 9
        }
        
        x = (hourReverseTenDigitTop?.frame.origin.x)! + (hourReverseTenDigitTop?.frame.size.width)! + 3
        
        if hourReverseSingleDigitTop == nil{
            hourReverseSingleDigitTop = WYLClockLabel.init(frame: CGRect.init(x: x, y: y, width: 25, height: 18), top: true)
            hourReverseSingleDigitTop?.blackView?.alpha = 1.0
            self.addSubview(hourReverseSingleDigitTop!)
        }
        hourReverseSingleDigitTop?.image = UIImage.init(named: "\(num)-top")
        
        if hourReverseSingleDigitBottom == nil{
            hourReverseSingleDigitBottom = WYLClockLabel.init(frame: CGRect.init(x: x - ( 25 / 2.0), y: y + (18 / 2.0), width: 25, height: 18), top: true)
            hourReverseSingleDigitBottom?.alpha = 0.0
            hourReverseSingleDigitBottom?.layer.anchorPoint = CGPoint.init(x: 0.0, y: 1.0)
            self.addSubview(hourReverseSingleDigitBottom!)
        }
        hourReverseSingleDigitBottom?.image = UIImage.init(named: "\(num)-bottom-reverse")
        
        if hourSingleDigitTop == nil {
            hourSingleDigitTop = WYLClockLabel.init(frame: CGRect.init(x: x - ( 25 / 2.0), y: y + (18 / 2.0), width: 25, height: 18), top: true)
            hourSingleDigitTop?.layer.anchorPoint = CGPoint.init(x: 0.0, y: 1.0)
            self.addSubview(hourSingleDigitTop!)
        }
        hourSingleDigitTop?.image = UIImage.init(named: "\(hourSingleDigit)-top")
        
        if hourSingleDigitBottom == nil {
            hourSingleDigitBottom = WYLClockLabel.init(frame: CGRect.init(x: x, y: y + 18, width: 25, height: 18), top: false)
            self.addSubview(hourSingleDigitBottom!)
        }
        hourSingleDigitBottom?.image = UIImage.init(named: "\(hourSingleDigit)-bottom")
        
    }
    
    
    /// 设置冒号
    ///
    /// - Parameters:
    ///   - x: 冒号的x坐标
    ///   - y: 冒号的y坐标
    func setUpColon(x: CGFloat, y: CGFloat){
        
        let top: UIView = UIView.init(frame: CGRect.init(x: x, y: y, width: 4.5, height: 4.5))
        top.backgroundColor = UIColor.init(colorWithHexValue: 0x404146)
        self.addSubview(top)
        
        let bottom: UIView = UIView.init(frame: CGRect.init(x: x, y: y+12, width: 4.5, height: 4.5))
        bottom.backgroundColor = UIColor.init(colorWithHexValue: 0x404146)
        self.addSubview(bottom)

    }
    
    func setUpStaticLabel(){
        
        weak var weakSelf = self
        
        day = UILabel.init()
        day?.textAlignment = .center
        day?.font = UIFont.boldSystemFont(ofSize: 18)
        day?.textColor = UIColor.init(colorWithHexValue: 0x59616A)
        self.addSubview(day!)
        
        day?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(weakSelf!).offset(kRealValue() * 11.3)
            maker.left.equalTo(weakSelf!).offset(0)
            maker.width.equalTo(frame.size.width)
            maker.height.equalTo(30)
        })
        
        dateLabel = UILabel.init()
        dateLabel?.textAlignment = .center
        dateLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        dateLabel?.textColor = UIColor.init(colorWithHexValue: 0x59616A)
        self.addSubview(dateLabel!)
        
        dateLabel?.snp.makeConstraints({ (maker) in
            maker.bottom.equalTo(weakSelf!).offset(kRealValue() * -12.3)
            maker.left.equalTo(weakSelf!).offset(0)
            maker.width.equalTo(frame.size.width)
            maker.height.equalTo(17)
        })
        
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        var commponent: DateComponents = DateComponents()
        commponent = calendar.dateComponents([.year,.month,.day], from: endDate!)
        dateLabel?.text = "  距离 \(commponent.year!)年\(commponent.month!)月\(commponent.day!)日"
        
        let unit:Set<Calendar.Component> = [.day,.hour,.minute,.second]
        commponent = calendar.dateComponents(unit, from: localDate(date: Date.init()), to: endDate!)
        let dayNum: Int = commponent.day!
        if dayNum >= 0{
            day?.text = "剩下\(dayNum)天"
        }else{
            day!.text = "已过期"
        }
        
        var x: CGFloat = kRealValue() * 8.5
        var y: CGFloat = kRealValue() * 31.7
        
        let hour1:UIImageView = UIImageView.init(frame: CGRect.init(x: x, y: y, width: 25, height: 36))
        hour1.image = UIImage.init(named: "ClockLabelNone")
        hour1.tag = 3000
        self.addSubview(hour1)
        
        x = hour1.frame.origin.x  + hour1.frame.size.width + 3
        let hour2:UIImageView = UIImageView.init(frame: CGRect.init(x: x, y: y, width: 25, height: 36))
        hour2.image = UIImage.init(named: "ClockLabelNone")
        hour2.tag = 3001
        self.addSubview(hour2)
        
        
        x = hour2.frame.origin.x + hour2.frame.size.width + 3
        y = hour2.frame.origin.y + 10
        setUpColon(x: x, y: y)
        
        x = hour2.frame.origin.x + hour2.frame.size.width + 10.4
        y = kRealValue() * 31.7
        
        let minute1:UIImageView = UIImageView.init(frame: CGRect.init(x: x, y: y, width: 25, height: 36))
        minute1.tag = 3002
        minute1.image = UIImage.init(named: "ClockLabelNone")
        self.addSubview(minute1)
        
        x = minute1.frame.origin.x  + minute1.frame.size.width + 3
        let minute2:UIImageView = UIImageView.init(frame: CGRect.init(x: x, y: y, width: 25, height: 36))
        minute2.image = UIImage.init(named: "ClockLabelNone")
        minute2.tag = 3003
        self.addSubview(minute2)
        
        x = minute2.frame.origin.x + minute2.frame.size.width + 3
        y = minute2.frame.origin.y + 10
        setUpColon(x: x, y: y)
        
        x = minute2.frame.origin.x + minute2.frame.size.width + 10.4
        y = kRealValue() * 31.7
        
        let second1:UIImageView = UIImageView.init(frame: CGRect.init(x: x, y: y, width: 25, height: 36))
        second1.tag = 3004
        second1.image = UIImage.init(named: "ClockLabelNone")
        self.addSubview(second1)
        
        x = second1.frame.origin.x  + second1.frame.size.width + 3
        let second2:UIImageView = UIImageView.init(frame: CGRect.init(x: x, y: y, width: 25, height: 36))
        second2.tag = 3005
        second2.image = UIImage.init(named: "ClockLabelNone")
        self.addSubview(second2)
        
    }
    
    // MARK:计算方法
    func localDate(date: Date)->Date{
        let nowTimeZone: NSTimeZone = NSTimeZone.system as NSTimeZone
        let interval = nowTimeZone.secondsFromGMT(for: date)
        return date.addingTimeInterval(TimeInterval(interval))
    }
    
    func ComparisonDate(date1: Date,date2: Date) -> Int{
        
        return date1.compare(date2).rawValue
        
    }
    
}

extension UIColor {
    
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

