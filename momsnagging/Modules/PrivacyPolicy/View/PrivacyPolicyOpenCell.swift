//
//  PrivacyPolicyOpenCell.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/23.
//

import UIKit
import Then
import SnapKit

class PrivacyPolicyOpenCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
        selectionStyle = .none
    }
    
    var selectCheck: Bool = false
    
    lazy var titleLbl = UILabel().then({
        $0.text = "????"
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
    })
    lazy var rightBtn = UIButton().then({
        $0.setImage(UIImage(asset: Asset.Icon.chevronDown), for: .normal)
    })
    lazy var contentLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark020)
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.numberOfLines = 0
    })
    lazy var underLine = UIView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
    })
}

extension PrivacyPolicyOpenCell {
    private func setUI() {
        contentView.addSubview(rightBtn)
        contentView.addSubview(contentLbl)
        contentView.addSubview(underLine)
        contentView.addSubview(titleLbl)
        contentView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        titleLbl.snp.makeConstraints({
            $0.leading.equalTo(contentView.snp.leading).offset(18)
            $0.top.equalTo(contentView.snp.top).offset(20)
            $0.height.lessThanOrEqualTo(24)
        })
        rightBtn.snp.makeConstraints({
            $0.centerY.equalTo(titleLbl.snp.centerY)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-18)
            $0.width.height.equalTo(18)
        })
        contentLbl.snp.makeConstraints({
            $0.top.equalTo(titleLbl.snp.bottom).offset(20)
            $0.leading.equalTo(contentView.snp.leading).offset(18)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-18)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-30)
        })
        underLine.snp.makeConstraints({
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.height.equalTo(1)
        })
    }
}
