//
//  ViewController.swift
//  MZCalendar
//
//  Created by Jerry.li on 2018/10/17.
//  Copyright © 2018年 51app. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var calendarKit: MZCalendarKit = {
        let calendarKit = MZCalendarKit(frame: CGRect(x: 0, y: 64, width: kScreenWidth, height: 400))
//        calendarKit.backgroundColor = UIColor.green
        return calendarKit
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(calendarKit)
        calendarKit.originPointArray = [20, 23, 25]
    }


}

