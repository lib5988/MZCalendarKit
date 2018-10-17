//
//  MZCalendarKit.swift
//  MZCalendar
//
//  Created by Jerry.li on 2018/10/17.
//  Copyright © 2018年 51app. All rights reserved.
//

import UIKit

/** 设备的物理宽度 */
let kScreenWidth: CGFloat = UIScreen.main.bounds.width
/** 设备的物理高度 */
let kScreenHeight: CGFloat = UIScreen.main.bounds.height

let margin: CGFloat = 10.0
let paddingLeft: CGFloat = 20.0
let itemWidth: CGFloat = (kScreenWidth - paddingLeft * 2 - margin * 6) / 7.0

class MZCalendarKit: UIView {
    
    fileprivate var identifier: String = "daysCell"
    fileprivate var date = Date()
    fileprivate var isCurrentMonth: Bool = false //是否当月
    fileprivate var currentMonthTotalDays: Int = 0 //当月的总天数
    fileprivate var firstDayIsWeekInMonth: Int = 0 //每月的一号对于的周几
    fileprivate var lastSelectedItemIndex: IndexPath? //获取最后一次选中的索引
    fileprivate let today: String = String(MZDateUtils.day(Date()))  //当天几号
    //原点
    var originPointArray: Array<Int> = Array<Int>() {
        didSet {
            calendarCollectionView.reloadData()
        }
    }
    
    //日历控件头部
    private lazy var calendarHeadView: UIView = {
        let calendarHeadView = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: 64))
        calendarHeadView.backgroundColor = UIColor.hexString(hex: "0074ff")
        return calendarHeadView
    }()
    
    //日历控件title
    fileprivate lazy var dateLabel: UILabel = {
        let labelWidth: CGFloat = 100.0
        let originX: CGFloat = (kScreenWidth - labelWidth) / 2.0
        let dateLabel = UILabel(frame: CGRect(x: originX, y: 5, width: labelWidth, height: 20))
        dateLabel.textAlignment = .center
        dateLabel.textColor = UIColor.white
        dateLabel.font = UIFont.systemFont(ofSize: 18)
        dateLabel.backgroundColor = UIColor.clear
        return dateLabel
    }()
    
    //上个月
    fileprivate lazy var lastMonthButton: UIButton = {
        let last = self.createButton(imageName: "last_month_normal", disabledImage: "last_month_enabled")
        last.frame.origin.x = self.dateLabel.frame.minX - last.width - 5
        last.addTarget(self, action: #selector(lastAction), for: .touchUpInside)
        return last
    }()
    
    //下个月
    fileprivate lazy var nextMonthButton: UIButton = {
        let next = self.createButton(imageName: "next_month_normal", disabledImage: "next_month_enabled")
        next.frame.origin.x = self.dateLabel.right
        next.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return next
    }()
    
    private lazy var weekView: UIView = {
        let originY: CGFloat = self.calendarHeadView.height - 13.0 - 15.0
        let weekView = UIView(frame: CGRect(x: paddingLeft, y: originY, width: kScreenWidth - paddingLeft * 2, height: 15))
        weekView.backgroundColor = UIColor.clear
        
        //week
        var weekArray = ["日", "一", "二", "三", "四", "五", "六"]
        var originX: CGFloat = 0.0
        for weekStr in weekArray {
            let week = UILabel()
            week.frame = CGRect(x: originX, y: 0, width: itemWidth, height: 15)
            week.text = weekStr
            week.textColor = UIColor.white
            week.font = UIFont.boldSystemFont(ofSize: 15)
            week.textAlignment = .center
            weekView.addSubview(week)
            originX = week.frame.maxX + margin
        }
        return weekView
    }()
    
    private func createButton(imageName: String, disabledImage: String) -> UIButton {
        let image: UIImage = UIImage.init(named: imageName)!
        let button = UIButton(type: .custom)
        let originY: CGFloat = self.dateLabel.centerY - image.size.height / 2
        button.frame = CGRect(x: 0, y: originY, width: image.size.width, height: image.size.height)
        button.setBackgroundImage(image, for: .normal)
        button.setBackgroundImage(image, for: .highlighted)
        button.setBackgroundImage(UIImage(named: disabledImage), for: .disabled)
        return button
    }
    
    fileprivate lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        
        let vWidth: CGFloat = kScreenWidth - paddingLeft * 2
        let tempRect = CGRect(x: paddingLeft, y: self.calendarHeadView.bottom, width: vWidth, height: 244)
        let calendarCollectionView = UICollectionView(frame: tempRect, collectionViewLayout: layout)
        calendarCollectionView.backgroundColor = UIColor.white
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        calendarCollectionView.register(MZDaysCell.self, forCellWithReuseIdentifier: self.identifier)
        return calendarCollectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //init
        _initCalendarInfo()
        
        self.addSubview(calendarHeadView)
        calendarHeadView.addSubview(dateLabel)
        calendarHeadView.addSubview(lastMonthButton)
        calendarHeadView.addSubview(nextMonthButton)
        calendarHeadView.addSubview(weekView)
        
        self.addSubview(calendarCollectionView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化日历信息
    func _initCalendarInfo() {
        //当前月份的总天数
        self.currentMonthTotalDays = MZDateUtils.daysInCurrMonth(date: date)
        
        //当前月份第一天是周几
        self.firstDayIsWeekInMonth = MZDateUtils.firstDayIsWeekInMonth(date: date)
        
        self.dateLabel.text = MZDateUtils.stringFromDate(date: date, format: "yyyy-MM")
        
        //是否当月
        let nowDate: String = MZDateUtils.stringFromDate(date: Date(), format: "yyyy-MM")
        self.isCurrentMonth = nowDate == self.dateLabel.text
        
        //重置日历高度
        let days = self.currentMonthTotalDays + self.firstDayIsWeekInMonth
        let rowCount: Int = (days / 7) + 1
        let kitHeight: CGFloat = itemWidth * CGFloat(rowCount) + CGFloat(rowCount) * margin
        calendarCollectionView.frame.size.height = kitHeight
    }
}

extension MZCalendarKit: UICollectionViewDelegate, UICollectionViewDataSource {
    //UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let days = self.currentMonthTotalDays + self.firstDayIsWeekInMonth
        return days
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as! MZDaysCell
        cell.clearDaysLabelStyle()
        
        var day = 0
        let index = indexPath.row
        
        if index < self.firstDayIsWeekInMonth {
            cell.daysLabel.text = ""
        } else {
            day = index - self.firstDayIsWeekInMonth + 1
            cell.daysLabel.text = String(day)
            
            if originPointArray.contains(day) {
                cell.isPointHidden = true
            }
            
            if isCurrentMonth {
                //当天
                if cell.daysLabel.text == today {
                    cell.isSelectedItem = true
                    self.lastSelectedItemIndex = indexPath
                } else {
                    cell.isSelectedItem = false
                }
                
                //当月当天以前的日期置灰，不可点击
                let itemValue = cell.daysLabel.text!
                let currDay = Int(itemValue)
                if currDay! < Int(today)! {
                    cell.isDisable = true
                }
            } else {
                //非当前自然月的1号默认选中
                if cell.daysLabel.text == "1" {
                    cell.isSelectedItem = true
                    self.lastSelectedItemIndex = indexPath
                } else {
                    cell.isSelectedItem = false
                }
            }
        }
        return cell
    }
    
    //UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCell = collectionView.cellForItem(at: indexPath) as! MZDaysCell
        
        //是否已经选中
        guard !currentCell.isSelectedItem else {
            return
        }
        
        //是否有值
        let itemText: String = currentCell.daysLabel.text!
        guard !itemText.isEmpty else {
            return
        }
        
        let curDate = Date()
        let today = MZDateUtils.day(curDate)
        let currDay = Int(itemText)
        
        //选中日期小于当天并且非当月
        if self.isCurrentMonth && currDay! < today {
            return
        }
        
        //获取上一次选中的item
        let preCell = collectionView.cellForItem(at: self.lastSelectedItemIndex!) as! MZDaysCell
        preCell.isSelectedItem = false
        
        //获取当前选中的item
        currentCell.isSelectedItem = true
        self.lastSelectedItemIndex = indexPath
    }
    
}

extension MZCalendarKit {
    func lastAction() {
        self.date = MZDateUtils.lastMonth(date)
        self._initCalendarInfo()
        calendarCollectionView.reloadData()
    }
    
    func nextAction() {
        self.date = MZDateUtils.nextMonth(date)
        self._initCalendarInfo()
        calendarCollectionView.reloadData()
    }
}
