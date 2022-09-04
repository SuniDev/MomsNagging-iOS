//
//  HomeCalendarCell.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/01.
//

import UIKit
import Then
import SnapKit

class HomeCalendarCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
    }
    // MARK: - Variable
    var isToday = false
    // MARK: - UI Properties
    lazy var number = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
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

}
extension HomeCalendarCell {
    private func setUI() {
        contentView.addSubview(todayRoundFrame)
        contentView.addSubview(selectDayRoundFrame)
        contentView.addSubview(number)
        number.snp.makeConstraints({
            $0.center.equalTo(contentView.snp.center)
        })
        todayRoundFrame.snp.makeConstraints({
            $0.center.equalTo(contentView.snp.center)
            $0.width.height.equalTo(28)
        })
        selectDayRoundFrame.snp.makeConstraints({
            $0.center.equalTo(contentView.snp.center)
            $0.width.height.equalTo(28)
        })
    }
}
