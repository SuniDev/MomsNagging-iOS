//
//  WeekDayCalendarTodayCell.swift
//  momsnagging
//
//  Created by 전창평 on 2022/09/01.
//

import UIKit
import Then
import SnapKit

class WeekDayCalendarTodayCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
        todayCheck()
    }
    
    // MARK: - Variable
    var isToday: Bool = true
    
    var day: Int?
    var month: Int?
    var year: Int?
    
    // MARK: - UI Properties
    lazy var weekDayLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 10)
    })
    lazy var itemBackgroundFrame = UIView().then({
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 3
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor(asset: Asset.Color.priLight010)
        $0.isHidden = true
    })
    lazy var todayRoundFrame = UIView().then({
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor(asset: Asset.Color.priMain)
        $0.isHidden = true
    })
    lazy var selectDayRoundFrame = UIView().then({
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor(asset: Asset.Color.priMain)?.cgColor
        $0.layer.borderWidth = 1
        $0.isHidden = true
    })
    lazy var numberLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoWhite)
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
    })
    
}
extension WeekDayCalendarTodayCell {
    private func setUI() {
        
        contentView.addSubview(itemBackgroundFrame)
        contentView.addSubview(weekDayLbl)
        contentView.addSubview(todayRoundFrame)
        contentView.addSubview(selectDayRoundFrame)
        contentView.addSubview(numberLbl)
        
        itemBackgroundFrame.snp.makeConstraints({
            $0.edges.equalTo(contentView.snp.edges)
        })
        weekDayLbl.snp.makeConstraints({
            $0.centerX.equalTo(itemBackgroundFrame.snp.centerX)
            $0.top.equalTo(itemBackgroundFrame.snp.top).offset(3)
        })
        todayRoundFrame.snp.makeConstraints({
            $0.top.equalTo(weekDayLbl.snp.bottom).offset(8)
            $0.width.height.equalTo(28)
            $0.centerX.equalTo(itemBackgroundFrame.snp.centerX)
        })
        selectDayRoundFrame.snp.makeConstraints({
            $0.top.equalTo(weekDayLbl.snp.bottom).offset(8)
            $0.width.height.equalTo(28)
            $0.centerX.equalTo(itemBackgroundFrame.snp.centerX)
        })
        numberLbl.snp.makeConstraints({
            $0.center.equalTo(todayRoundFrame.snp.center)
        })
    }
    
    func todayCheck(){
        if isToday {
            itemBackgroundFrame.isHidden = false
            todayRoundFrame.isHidden = false
        }
    }
}
