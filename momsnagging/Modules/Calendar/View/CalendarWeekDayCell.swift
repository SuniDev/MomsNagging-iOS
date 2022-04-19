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
        $0.textColor = UIColor.white
        $0.font = .systemFont(ofSize: 17, weight: .bold)
    })
    
}
extension CalendarWeekDayCell {
    private func setUI() {
        contentView.addSubview(dayWeekLabel)
        dayWeekLabel.snp.makeConstraints({
            $0.center.equalTo(contentView.snp.center)
        })
    }
}
