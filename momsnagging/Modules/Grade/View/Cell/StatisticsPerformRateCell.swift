//
//  StatisticsPerformRateCell.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/21.
//

import UIKit
import Then
import SnapKit

class StatisticsPerformRateCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionStyle = .none
        setUI()
    }
    
    lazy var titleLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark020)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    lazy var dataLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.priMain)
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
    })
    lazy var suffixLbl = UILabel().then({
        $0.textAlignment = .right
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
    })
    lazy var descriptionLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark030)
        $0.font = FontFamily.Pretendard.regular.font(size: 12)
    })

}

extension StatisticsPerformRateCell {
    private func setUI() {
        contentView.addSubview(titleLbl)
        contentView.addSubview(dataLbl)
        contentView.addSubview(suffixLbl)
        contentView.addSubview(descriptionLbl)
        
        titleLbl.snp.makeConstraints({
            $0.height.equalTo(25)
            $0.leading.top.equalToSuperview()
        })
        dataLbl.snp.makeConstraints({
            $0.centerY.equalTo(titleLbl.snp.centerY)
            $0.trailing.equalTo(suffixLbl.snp.leading).offset(-10)
        })
        suffixLbl.snp.makeConstraints({
            $0.width.equalTo(16)
            $0.centerY.equalTo(titleLbl.snp.centerY)
            $0.trailing.equalToSuperview()
        })
        
        descriptionLbl.snp.makeConstraints({
            $0.height.equalTo(25)
            $0.top.equalTo(titleLbl.snp.bottom)
            $0.leading.equalTo(titleLbl)
            $0.trailing.equalTo(suffixLbl)
            $0.bottom.equalToSuperview()
        })
    }
}
