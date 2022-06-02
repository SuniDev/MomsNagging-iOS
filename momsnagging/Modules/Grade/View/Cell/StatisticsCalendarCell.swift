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
        selectionStyle = .none
        setUI()
    }
    
    lazy var viewBacground = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    lazy var weekLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark020)
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
    })
    lazy var reportLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 20)
    })
}

extension StatisticsCalendarCell {
    private func setUI() {
        contentView.backgroundColor = Asset.Color.monoWhite.color
        contentView.addSubview(viewBacground)
        viewBacground.addSubview(weekLbl)
        viewBacground.addSubview(reportLbl)
        viewBacground.snp.makeConstraints({
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(145)
        })
        weekLbl.snp.makeConstraints({
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        })
        reportLbl.snp.makeConstraints({
            $0.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        })
    }
}
