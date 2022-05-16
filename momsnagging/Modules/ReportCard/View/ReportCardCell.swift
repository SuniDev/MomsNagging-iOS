//
//  ReportCardCell.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/15.
//

import UIKit
import Then
import SnapKit

class ReportCardCell: UICollectionViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
        todayCheck()
    }
    // MARK: - Variable
    var isToday = false
    // MARK: - UI Properties
    lazy var number = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.regular.font(size: 10)
        $0.textAlignment = .center
    })
    lazy var ic = UIImageView().then({
        $0.image = UIImage(asset: Asset.Assets.emojiDefault)
    })
    
    lazy var todayFrame = UIView().then({
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor(asset: Asset.Color.monoLight030)
        $0.isHidden = true
    })
    lazy var selectDayFrame = UIView().then({
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor(asset: Asset.Color.monoDark040)?.cgColor
        $0.layer.borderWidth = 1
        $0.isHidden = true
    })
    
}
extension ReportCardCell {
    private func setUI() {
        contentView.addSubview(todayFrame)
        contentView.addSubview(selectDayFrame)
        contentView.addSubview(number)
        contentView.addSubview(ic)
        number.snp.makeConstraints({
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
        })
        ic.snp.makeConstraints({
            $0.top.equalTo(number.snp.bottom).offset(4)
            $0.width.height.equalTo(36)
            $0.centerX.equalTo(contentView.snp.centerX)
        })
        todayFrame.snp.makeConstraints({
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.bottom.equalTo(contentView.snp.bottom)
        })
        selectDayFrame.snp.makeConstraints({
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.bottom.equalTo(contentView.snp.bottom)
        })
    }
    
    func todayCheck() {
        if isToday {
            todayFrame.isHidden = false
        } else {
            todayFrame.isHidden = true
        }
    }
}
