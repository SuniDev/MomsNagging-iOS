//
//  SettingCell.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/22.
//

import UIKit
import Then
import SnapKit

class SettingCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
        selectionStyle = .none
    }
    
    lazy var titleLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
    })
    lazy var rightBtn = UIButton().then({
        $0.setImage(UIImage(asset: Asset.Icon.chevronRight), for: .normal)
    })
    lazy var versionLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark030)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    lazy var underLine = UIView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
    })
}

extension SettingCell {
    private func setUI(){
        contentView.addSubview(titleLbl)
        contentView.addSubview(rightBtn)
        contentView.addSubview(versionLbl)
        contentView.addSubview(underLine)
        contentView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        titleLbl.snp.makeConstraints({
            $0.leading.equalTo(contentView.snp.leading).offset(18)
            $0.centerY.equalTo(contentView.snp.centerY)
        })
        rightBtn.snp.makeConstraints({
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-18)
            $0.width.height.equalTo(18)
        })
        versionLbl.snp.makeConstraints({
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-18)
        })
        underLine.snp.makeConstraints({
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.height.equalTo(1)
        })
    }
}
