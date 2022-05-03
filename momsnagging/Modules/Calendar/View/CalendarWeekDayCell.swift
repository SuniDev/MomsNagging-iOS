//
//  CalendarWeekDayCell.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/26.
//

import UIKit
import Then
import SnapKit

class CalendarWeekDayCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
    }
    
    lazy var dayWeekLabel = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 10)
    })
    
}
extension CalendarWeekDayCell {
    private func setUI() {
        contentView.addSubview(dayWeekLabel)
        dayWeekLabel.snp.makeConstraints({
            $0.top.equalTo(contentView.snp.top)
            $0.centerX.equalTo(contentView.snp.centerX)
        })
    }
}
