//
//  InconvenienceListCell.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/25.
//

import UIKit
import Then
import SnapKit

class InconvenienceListCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
        selectionStyle = .none
    }
    
    lazy var contentLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
    })
}

extension InconvenienceListCell {
    private func setUI() {
        contentView.addSubview(contentLbl)
        contentView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        contentLbl.snp.makeConstraints({
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.leading.equalTo(contentView.snp.leading).offset(16)
        })
    }
}
