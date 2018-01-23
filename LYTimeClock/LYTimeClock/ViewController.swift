//
//  ViewController.swift
//  LYTimeClock
//
//  Created by wyl on 2018/1/19.
//  Copyright © 2018年 wyl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let end_time = "2018-01-24 12:16:00"

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT:0)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let date = dateFormatter.date(from: end_time)

        let clock: WYLTimeClock = WYLTimeClock.init(frame: CGRect.init(x: 100, y: 100, width: 227, height: 227), date: date!)
        clock.setUpStaticLabel()
        clock.perform(#selector(clock.setUpTimeLabel), with: nil, afterDelay: 1.0)
        self.view.addSubview(clock)
        
        
//        let view: UIView = UIView.init(frame: CGRect.init(x: 50, y: 50, width: 100, height: 100))
//        view.backgroundColor = UIColor.blue
//        self.view.addSubview(view)
//
//        let view2: UIView = UIView.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
//        view2.backgroundColor = UIColor.green
//        self.view.addSubview(view2)
//        
//        let view3: UIView = UIView.init(frame: CGRect.init(x: 140, y: 140, width: 100, height: 100))
//        view3.backgroundColor = UIColor.yellow
//        self.view.addSubview(view3)
//     
//        //最后调用的放在最后
//        self.view.sendSubview(toBack: view3)
//        self.view.sendSubview(toBack: view2)

    }
    
    func getHHMMSSFormSS(seconds:Int) -> String {
        let str_day = NSString(format: "%02ld", seconds/24)
        let str_hour = NSString(format: "%02ld", seconds/3600)
        let str_minute = NSString(format: "%02ld", (seconds%3600)/60)
        let str_second = NSString(format: "%02ld", seconds%60)
        let format_time = NSString(format: "%@:%@:%@:%@",str_day,str_hour,str_minute,str_second)
        return format_time as String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

