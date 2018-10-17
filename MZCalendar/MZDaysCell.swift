//
//  MZDaysCell.swift
//  MZCalendar
//
//  Created by Jerry.li on 2018/10/17.
//  Copyright © 2018年 51app. All rights reserved.
//

import UIKit

class MZDaysCell: UICollectionViewCell {
    
    lazy var daysLabel: UILabel = {
        let margin: CGFloat = (itemWidth - 32)/2.0
        let daysLabel = UILabel(frame: CGRect(x: margin, y: margin, width: 32, height: 32))
        daysLabel.textAlignment = .center
        daysLabel.font = UIFont.systemFont(ofSize: 14)
        daysLabel.layer.cornerRadius = 32.0 / 2.0
        daysLabel.layer.masksToBounds = true
        daysLabel.layer.shouldRasterize = true
        return daysLabel
    }()
    
    var isPointHidden: Bool = false {
        didSet {
            if isPointHidden {
                self.daysLabel.layer.addSublayer(self.pointLayer)
            } else {
                pointLayer.removeFromSuperlayer()
            }
        }
    }
    
    var isSelectedItem: Bool = false {
        didSet {
            if isSelectedItem {
                self.daysLabel.backgroundColor = UIColor.hexString(hex: "ff6c13")
                self.daysLabel.textColor = UIColor.white
            } else {
                daysLabel.backgroundColor = UIColor.white
                daysLabel.textColor = UIColor.hexString(hex: "333333")
            }
        }
    }
    
    //是否禁用
    var isDisable: Bool = false {
        didSet {
            if isDisable {
                self.daysLabel.textColor = UIColor.hexString(hex: "bfbfbf")
            }
        }
    }
    
    //清除现有日期label上的所有样式
    func clearDaysLabelStyle() {
        daysLabel.text = ""
        daysLabel.backgroundColor = UIColor.white
        daysLabel.textColor = UIColor.hexString(hex: "333333")
        pointLayer.removeFromSuperlayer()
    }
    
    private lazy var pointLayer: CALayer = {
        let point = CALayer()
        point.backgroundColor = UIColor.hexString(hex: "ff6c13").cgColor
        var originX: CGFloat = (self.daysLabel.frame.width - 6) / 2.0
        point.frame = CGRect(x: originX, y: self.daysLabel.frame.height - 6, width: 6, height: 6)
        point.cornerRadius = point.bounds.width / 2
        point.masksToBounds = true
        return point
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.addSubview(daysLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
