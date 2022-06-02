//
//  StatisticsCalendarCell.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/21.
//

import UIKit
import Then
import SnapKit

class StatisticsCalendarCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
        selectionStyle = .none
    }
    
    lazy var weekLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark020)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 16)
    })
    lazy var reportLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.bold.font(size: 20)
    })
}

extension StatisticsCalendarCell {
    private func setUI() {
        contentView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        contentView.addSubview(weekLbl)
        contentView.addSubview(reportLbl)
        weekLbl.snp.makeConstraints({
            $0.trailing.equalTo(contentView.snp.centerX).offset(-35)
            $0.top.equalTo(contentView.snp.top)
        })
        reportLbl.snp.makeConstraints({
            $0.centerY.equalTo(weekLbl.snp.centerY)
            $0.leading.equalTo(weekLbl.snp.trailing).offset(87)
        })
    }
}
