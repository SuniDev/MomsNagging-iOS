//
//  DiaryCalendarCell.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/06.
//

import UIKit
import Then
import SnapKit

class DiaryCalendarCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
        todayCheck()
    }
    // MARK: - Variable
    var isToday = false // 오늘인지 아닌지 여부
    var isWroteDiary = false //일기 씀 여부
    var isEmpty = false //숫자가 없는 빈 배열처리를 위함
    // MARK: - UI Properties
    lazy var defaultRoundFrame = UIView().then({
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        $0.layer.borderColor = UIColor(asset: Asset.Color.monoLight030)?.cgColor
        $0.layer.borderWidth = 1
    })
    lazy var wroteDiaryRoundFrame = UIView().then({
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor(asset: Asset.Color.subLight020)
    })
    lazy var number = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
    })
    lazy var todayRoundFrame = UIView().then({
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor(asset: Asset.Color.priMain)
        $0.isHidden = true
    })
    lazy var selectDayRoundFrame = UIView().then({
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor(asset: Asset.Color.priMain)?.cgColor
        $0.layer.borderWidth = 1
        $0.isHidden = true
    })
    
}
extension DiaryCalendarCell {
    private func setUI() {
        contentView.addSubview(defaultRoundFrame)
        contentView.addSubview(wroteDiaryRoundFrame)
        contentView.addSubview(todayRoundFrame)
        contentView.addSubview(selectDayRoundFrame)
        contentView.addSubview(number)
        
        defaultRoundFrame.snp.makeConstraints({
            $0.center.equalTo(contentView.snp.center)
            $0.width.height.equalTo(40)
        })
        wroteDiaryRoundFrame.snp.makeConstraints({
            $0.center.equalTo(contentView.snp.center)
            $0.width.height.equalTo(40)
        })
        number.snp.makeConstraints({
            $0.center.equalTo(contentView.snp.center)
        })
        todayRoundFrame.snp.makeConstraints({
            $0.center.equalTo(contentView.snp.center)
            $0.width.height.equalTo(40)
        })
        selectDayRoundFrame.snp.makeConstraints({
            $0.center.equalTo(contentView.snp.center)
            $0.width.height.equalTo(40)
        })
    }
    
    func todayCheck() {
        if isToday {
            todayRoundFrame.isHidden = false
            defaultRoundFrame.isHidden = true
            wroteDiaryRoundFrame.isHidden = true
        } else {
            todayRoundFrame.isHidden = true
            if isWroteDiary {
                defaultRoundFrame.isHidden = true
                wroteDiaryRoundFrame.isHidden = false
            } else {
                defaultRoundFrame.isHidden = false
                wroteDiaryRoundFrame.isHidden = true
            }
        }
        if isEmpty {
            defaultRoundFrame.isHidden = true
            wroteDiaryRoundFrame.isHidden = true
        }
    }
}
