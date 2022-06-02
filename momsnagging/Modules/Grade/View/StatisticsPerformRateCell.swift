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
        setUI()
        selectionStyle = .none
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
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
    })
}

extension StatisticsPerformRateCell {
    private func setUI(){
        contentView.addSubview(titleLbl)
        contentView.addSubview(dataLbl)
        contentView.addSubview(suffixLbl)
        
        titleLbl.snp.makeConstraints({
            $0.top.equalTo(contentView.snp.top).offset(1.5)
            $0.leading.equalTo(contentView.snp.leading)
        })
        suffixLbl.snp.makeConstraints({
            $0.centerY.equalTo(titleLbl.snp.centerY)
            $0.trailing.equalTo(contentView.snp.trailing)
        })
        dataLbl.snp.makeConstraints({
            $0.centerY.equalTo(titleLbl.snp.centerY)
            $0.trailing.equalTo(suffixLbl.snp.leading).offset(-10)
        })
    }
}
