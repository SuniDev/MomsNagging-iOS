//
//  RecommendedHabitCell.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/15.
//

import UIKit
import Then
import SnapKit

class RecommendedHabitCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
        selectionStyle = .none
    }
    var itemBackgroundColor: String?
    lazy var itemFrame = UIView().then({
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    })
    lazy var title = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
    })
}

extension RecommendedHabitCell {
    private func setUI(){
        contentView.addSubview(itemFrame)
        contentView.addSubview(title)
        itemFrame.snp.makeConstraints({
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-12)
        })
        title.snp.makeConstraints({
            $0.center.equalTo(itemFrame.snp.center)
        })
    }
}
